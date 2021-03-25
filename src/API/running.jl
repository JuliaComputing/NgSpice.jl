cmd(command) = ngSpice_Command(command) #should typeof(command) be restricted

init()      = (pvoid = convert(Ptr{Nothing}, 0);
                ngSpice_Init(gen_psendchar(), gen_psendstat(),
                gen_pcontrolledexit(),
                gen_psenddata(),
                gen_psendinitdata(),
                gen_pbgthread(), pvoid))

# isrunning() = ngSpice_running() # always returns 0

run()     = cmd("run")
bgrun()   = cmd("bg_run")

set_breakpoint(bkpt::Float64) = ngSpice_SetBkpt(bkpt)

stop()    = cmd("stop")
bghalt()  = cmd("bg_halt")

reset()   = cmd("reset")
resume()  = cmd("resume")

exit()    = cmd("unset askquit")
