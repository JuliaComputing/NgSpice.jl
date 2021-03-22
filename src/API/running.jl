cmd(command) = ngSpice_Command(command) #should typeof(command) be restricted

init()      = (pvoid = convert(Ptr{Nothing}, 0); 
                ngSpice_Init(psendchar, psendstat, pcontrolledexit, 
                pvoid, pvoid,  pbgthread, pvoid))
                #psenddata, psendinitdata, pbgthread, pvoid))

# isrunning() = ngSpice_running() # always returns 0

run()     = (init(); cmd("run"))
bgrun()   = (init(); cmd("bg_run"))

stop()    = cmd("stop")
bghalt()  = cmd("bg_halt") 

reset()   = cmd("reset")
resume()  = cmd("resume")

exit()    = cmd("unset askquit")
