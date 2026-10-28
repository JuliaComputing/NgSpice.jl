# libngspice keeps all of its state in globals and is not re-entrant. Since
# Julia 1.12 a session has more than one thread by default, so every call into
# the library goes through this lock (re-entrant, because load_netlist calls cmd).
const NGSPICE_LOCK = ReentrantLock()

const quiet = Ref(false)

"""
    ngcall(f)

Run `f()` (which calls into libngspice) under `NGSPICE_LOCK`, then restore
Julia's signal handlers and echo any ngspice output.
"""
function ngcall(f)
    @lock NGSPICE_LOCK begin
        check_alive()
        result = with_julia_signals(f)
        quiet[] ? take!(string_buffer) : dumpbuffer()
        check_alive()
        return result
    end
end

function check_alive()
    st = ngspice_exit[]
    st === nothing && return nothing
    error("ngspice requested detachment (exit status $(st[1])" *
          (st[2] == 1 ? ", after 'quit'" : "") *
          "); its state is no longer usable. Restart Julia to continue.")
end

function dumpbuffer()
    s = String(take!(string_buffer))
    isempty(s) && return nothing
    for l in eachsplit(chomp(s), '\n')
        println(replace(l, r"^stdout " => ""))
    end
    return nothing
end

function cmd(command::AbstractString)
    # bg_* commands run the simulation on an ngspice-owned thread, which would
    # call back into Julia concurrently with this session. Not supported.
    startswith(lstrip(command), "bg_") &&
        error("bg_* commands are not supported by NgHerb; use the synchronous form")
    ngcall(() -> ngSpice_Command(command))
    return nothing
end
precompile(cmd, (String,))

function init()
    # Snapshot Julia's handlers *before* ngspice gets a chance to touch them.
    save_julia_signal_handlers!()
    @lock NGSPICE_LOCK begin
        # While ngSpice_Init runs, ngspice's own SIGSEGV handler is installed, so
        # no stop-the-world GC may start. The disable/enable pair is balanced and
        # cannot migrate threads (no yield point in between), unlike the old code.
        gc_was_on = GC.enable(false)
        try
            with_julia_signals() do
                ngSpice_Init(gen_psendchar[], C_NULL, gen_pcontrolledexit[],
                             C_NULL, C_NULL, C_NULL, C_NULL)
            end
        finally
            GC.enable(gc_was_on)
        end
    end
    # The init banner stays in string_buffer and is echoed by the first command,
    # as before.
    return nothing
end
