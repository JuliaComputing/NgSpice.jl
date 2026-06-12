

function cmd(command::String)
    GC.enable(false)
    ngSpice_Command(command)
end    
precompile(cmd,(String,))


function init()
    GC.enable(false)
    ngSpice_Init(gen_psendchar[], gen_psendstat[],
        gen_pcontrolledexit[],
        gen_psenddata[],
        gen_psendinitdata[],
        gen_pbgthread[], C_NULL)

end


