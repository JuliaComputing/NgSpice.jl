# Deterministic reproducer for the NgHerb / ngspice "random" segfault.
#
#   julia --project test/sigsegv_repro.jl         # Julia 1.12 default (-t1,1)
#   julia -t 4 --project test/sigsegv_repro.jl
#   julia -t 1 --project test/sigsegv_repro.jl    # control: never crashes
#
# Mechanism: ngSpice_Init re-installs Julia's SIGSEGV handler with signal(),
# dropping SA_SIGINFO|SA_ONSTACK. Julia then cannot recognise its own GC
# safepoint faults, so any stop-the-world GC that catches a *second* thread
# running Julia code kills the process. With one thread there is never a
# second thread to stop, which is why `-t 1` hides it.

using NgHerb

# Inspect the SIGSEGV handler flags directly (Linux / glibc layout).
function segv_flags()
    buf = zeros(UInt8, 256)
    ccall(:sigaction, Cint, (Cint, Ptr{Cvoid}, Ptr{UInt8}), 11, C_NULL, buf)
    flags = reinterpret(Int32, buf[137:140])[1]
    (SA_SIGINFO = flags & 0x4 != 0, SA_ONSTACK = flags & 0x08000000 != 0)
end

println("Julia ", VERSION, ": ", Threads.nthreads(:default), " default + ",
        Threads.nthreads(:interactive), " interactive thread(s)")

# Exercise ngspice a bit (init already ran in __init__; this also runs the
# expression evaluator, which resets SIGILL).
NgHerb.be_quiet()
NgHerb.load_netlist("""
test circuit
V1 1 0 1
R1 1 2 1k
R2 2 0 1k
.op
.end
""")
NgHerb.cmd("run")
NgHerb.cmd("let x = v(2)*2+1")
println("SIGSEGV handler flags after ngspice calls: ", segv_flags())

# The unfixed NgHerb calls GC.enable(false) and never re-enables it, which
# hides the bug (and leaks). Undo that so the GC can actually run.
GC.enable(true)

stop = Threads.Atomic{Bool}(false)
spinner = Threads.@spawn begin          # keep a second thread executing Julia code
    acc, i = 0.0, 0
    while !stop[]
        acc += sum(rand(16))            # allocates -> polls GC safepoints
        (i += 1) % 1000 == 0 && yield() # lets the -t 1 control case make progress
    end
    acc
end
sleep(0.2)

const N = 2000
for k in 1:N
    GC.gc(false)                        # stop-the-world: spinner must hit the safepoint page
end
stop[] = true
wait(spinner)
println("survived $N stop-the-world collections")
