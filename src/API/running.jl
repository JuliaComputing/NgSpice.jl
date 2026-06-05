cmd(command) = GC.@preserve command ngSpice_Command(command)
precompile(cmd,(String,))

function init()
    #pvoid = convert(Ptr{Nothing}, 0)
    ngSpice_Init(gen_psendchar[], gen_psendstat[],
        gen_pcontrolledexit[],
        gen_psenddata[],
        gen_psendinitdata[],
        gen_pbgthread[], C_NULL)

end


