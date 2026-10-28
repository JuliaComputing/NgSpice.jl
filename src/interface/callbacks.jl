# Callbacks invoked by libngspice. With synchronous commands (no bg_*), ngspice
# calls these on the same OS thread that is inside ngSpice_Command/ngSpice_Circ,
# i.e. while NGSPICE_LOCK is held by the calling task.
#
# Rules for code in here: never throw (an exception must not unwind through
# ngspice's C frames), and do as little as possible (no printing / yielding).

# Output text from ngspice; filled by `sendchar`, drained by `dumpbuffer`.
const string_buffer = IOBuffer()

# Set by `controlledexit`: (exit status, quit flag). Once set, ngspice has asked
# to be detached and must not be used again in this process.
const ngspice_exit = Ref{Union{Nothing,Tuple{Cint,Cint}}}(nothing)

function sendchar(text::Ptr{Cchar}, id::Cint, userdata::Ptr{Cvoid})::Cint
    try
        n = ccall(:strlen, Csize_t, (Ptr{Cchar},), text)
        unsafe_write(string_buffer, Ptr{UInt8}(text), n)
        write(string_buffer, UInt8('\n'))
    catch
    end
    return Cint(0)
end
precompile(sendchar, (Ptr{Cchar}, Cint, Ptr{Cvoid}))

function controlledexit(exitstatus::Cint, immediate::Cint, quitexit::Cint,
                        id::Cint, userdata::Ptr{Cvoid})::Cint
    ngspice_exit[] = (exitstatus, quitexit)
    return exitstatus
end
precompile(controlledexit, (Cint, Cint, Cint, Cint, Ptr{Cvoid}))
