cmd(command) = ngSpice_Command(command)

function init()
    pvoid = convert(Ptr{Nothing}, 0)
    ngSpice_Init(gen_psendchar(), gen_psendstat(),
        gen_pcontrolledexit(),
        gen_psenddata(),
        gen_psendinitdata(),
        gen_pbgthread(), pvoid)
    ngSpice_Init_JLExtensions(
        @cfunction(path_resolve, Cstring, (Cstring, Cstring))
    )

end

isrunning() = ngSpice_running() # always returns 0

run()     = (println("Running the simulator"); cmd("run"))
bgrun()   = (println("Running the simulator in a background thread");
                cmd("bg_run"))

set_breakpoint(bkpt::Float64) = ngSpice_SetBkpt(bkpt)

stop()    = (println("Stopping the simulator"); cmd("stop"))
bghalt()  = (println("Halting the simulator in a background thread");
                cmd("bg_halt"))

reset()   = (println("Resetting the simulator"); cmd("reset"))
resume()  = (println("Resuming the simulator"); cmd("resume"))

quit()    = n.cmd("quit")
exit()    = (println("Quitting immediately"); cmd("unset askquit"))
