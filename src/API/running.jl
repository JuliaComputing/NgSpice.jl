

function cmd(command)
    GC.@preserve command ngSpice_Command(command)
    sleep(0.1)
    dumpbuffer()
end    
precompile(cmd,(String,))


function init()

    ngSpice_Init(gen_psendchar[], gen_psendstat[],
        gen_pcontrolledexit[],
        gen_psenddata[],
        gen_psendinitdata[],
        gen_pbgthread[], C_NULL)

end


