command(cmd::Symbol) = ngSpice_Command(cmd)

init()      = ngSpice_Init(sendcharptr, sendstatptr, controlledexitptr, 
                senddataptr, sendinitdataptr, bgthreadptr, Ptr{Cvoid})

isrunning() = ngSpice_running()

run()       = (init(); command(:run))
bgrun()     = (init(); command(:bg_run))

halt()      = command(:bg_halt)
bghalt()    = command(:bg_halt) 

reset()     = command(:reset)

