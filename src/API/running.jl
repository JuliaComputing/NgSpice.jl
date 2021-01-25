cmd(command) = ngSpice_Command(command) #should typeof(command) be restricted

init()      = (pvoid = convert(Ptr{Nothing}, 0); 
                ngSpice_Init(psendchar, psendstat, pcontrolledexit, 
                pvoid, pvoid,  pbgthread, pvoid))
                #psenddata, psendinitdata, pbgthread, pvoid))

isrunning() = ngSpice_running()

ngrun()     = (init(); cmd(:run))
bgrun()     = (init(); cmd(:bg_run))

ngstop()    = cmd(:stop)
bghalt()    = cmd(:bg_halt) 

reset()     = cmd(:reset)

