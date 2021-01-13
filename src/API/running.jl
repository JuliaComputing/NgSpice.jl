fpgen(a, fp) = (a=a; convert(Ptr{fp}, a))

_command(cmd::Symbol) = (ngSpice_Command(cmd))

init()      = (p = convert(Ptr{Nothing}, 0); ngSpice_Init(p,p,p,p,p,p,p))

isrunning() = ngSpice_running()

run()       = (init(); _command(:bg_run))
start()     = (init(); _command(:bg_run)) # is it necessary?

halt()      = _command(:bg_halt)
stop()      = _command(:bg_halt) # is it necessary?

reset()     = _command(:reset)
