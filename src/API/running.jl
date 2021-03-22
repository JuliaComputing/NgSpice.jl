cmd(command) = ngSpice_Command(command) #should typeof(command) be restricted

init()      = (pvoid = convert(Ptr{Nothing}, 0); 
                ngSpice_Init(psendchar, psendstat, pcontrolledexit, 
                psenddata, psendinitdata, pbgthread, pvoid))

# isrunning() = ngSpice_running() # always returns 0

run()     = cmd("run")
bgrun()   = cmd("bg_run")

set_breakpoint(bkpt::Float64) = ngSpice_SetBkpt(bkpt)

stop()    = cmd("stop")
bghalt()  = cmd("bg_halt") 

reset()   = cmd("reset")
resume()  = cmd("resume")

exit()    = cmd("unset askquit")
