using Ngspice

_command(cmd::Symbol) = (ngSpice_Command(cmd))
# define a validate function to validatethe cmd before f call                  

init()      = (p = fpgen(0, Nothing); ngSpice_Init(p,p,p,p,p,p,p))

isrunning() = ngSpice_running()

run()       = (init(); _command(:bg_run))
start()     = (init(); _command(:bg_run)) # is it necessary?

halt()      = _command(:bg_halt)
stop()      = _command(:bg_halt) # is it necessary?

reset()     = _command(:reset)


