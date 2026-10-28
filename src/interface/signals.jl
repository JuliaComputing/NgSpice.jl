# ---------------------------------------------------------------------------
# Protecting Julia's signal handlers from libngspice
#
# Julia's GC stops threads by protecting a "safepoint" page: a thread that is
# running Julia code faults on it and Julia's SIGSEGV handler (installed with
# SA_ONSTACK | SA_SIGINFO) recognises the fault by reading info->si_code and
# info->si_addr. Ctrl-C (SIGINT) is delivered the same way.
#
# libngspice 41 (src/sharedspice.c, ngSpice_Init) does
#     old = signal(SIGSEGV, sigsegvsh);  ...  signal(SIGSEGV, old);
# signal() re-installs Julia's handler WITHOUT SA_SIGINFO / SA_ONSTACK, so from
# then on Julia's handler receives an unfilled siginfo, cannot recognise its
# own safepoint faults, and treats every GC stop-the-world (or Ctrl-C) that
# lands on a thread running Julia code as a real segfault.
# Its expression evaluator (src/frontend/evaluate.c) also resets SIGILL to
# SIG_DFL after every vector expression ("let", "print", "meas", ...).
#
# Fix: snapshot Julia's own sigaction structs once (before ngSpice_Init) and
# put them back, verbatim, after every call into libngspice.
# ---------------------------------------------------------------------------

# SIGINT, SIGILL, SIGFPE, SIGBUS, SIGSEGV, SIGUSR2
const GUARDED_SIGNALS = Sys.isapple() ? Cint[2, 4, 8, 10, 11, 31] :
                                        Cint[2, 4, 8, 7, 11, 12]

# Opaque storage for `struct sigaction` (152 bytes on glibc/Linux); never
# interpreted, only copied back, so the exact layout does not matter.
const SIGACTION_BYTES = 256

const saved_sigactions = Tuple{Cint,Vector{UInt8}}[]

function save_julia_signal_handlers!()
    Sys.iswindows() && return nothing
    empty!(saved_sigactions)
    for sig in GUARDED_SIGNALS
        buf = zeros(UInt8, SIGACTION_BYTES)
        rc = ccall(:sigaction, Cint, (Cint, Ptr{Cvoid}, Ptr{UInt8}), sig, C_NULL, buf)
        rc == 0 || error("sigaction($sig) query failed")
        push!(saved_sigactions, (sig, buf))
    end
    return nothing
end

function restore_julia_signal_handlers()
    Sys.iswindows() && return nothing
    for (sig, buf) in saved_sigactions
        ccall(:sigaction, Cint, (Cint, Ptr{UInt8}, Ptr{Cvoid}), sig, buf, C_NULL)
    end
    return nothing
end

"""
    with_julia_signals(f)

Run `f()` (a call into libngspice) and reinstall Julia's signal handlers
afterwards, even if `f` throws.
"""
function with_julia_signals(f)
    try
        return f()
    finally
        restore_julia_signal_handlers()
    end
end

"""
    segv_handler_intact() -> Bool

Diagnostic (Linux only): `true` if the process's SIGSEGV handler still has the
`SA_SIGINFO` and `SA_ONSTACK` flags Julia installed it with.
"""
function segv_handler_intact()
    Sys.islinux() || error("segv_handler_intact is only implemented for Linux")
    buf = zeros(UInt8, SIGACTION_BYTES)
    ccall(:sigaction, Cint, (Cint, Ptr{Cvoid}, Ptr{UInt8}), 11, C_NULL, buf)
    flags = reinterpret(Int32, buf[137:140])[1]          # sa_flags at offset 136
    SA_SIGINFO, SA_ONSTACK = Int32(0x4), Int32(0x08000000)
    return (flags & SA_SIGINFO != 0) && (flags & SA_ONSTACK != 0)
end
