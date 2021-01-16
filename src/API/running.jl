cmd(command) = ngSpice_Command(command) #should typeof(command) be restricted

init()      = (pvoid = convert(Ptr{Nothing}, 0); 
                ngSpice_Init(psendchar, psendstat, pcontrolledexit, 
                psenddata, psendinitdata, pbgthread, pvoid))

isrunning() = ngSpice_running()

simrun()    = (init(); cmd(:run))
bgrun()     = (init(); cmd(:bg_run))

simhalt()   = cmd(:halt)
bghalt()    = cmd(:bg_halt) 

reset()     = cmd(:reset)

