using ReplMaker
using .Plots

function _ngspice_parser(str)
    if str == "init" init()       
    elseif occursin("plot", str)
        _plotswitch(str)
    else 
        cmd(str)
    end
end

function _repl_parser(str)
    if occursin(".sp", str) && str[1:7] == "source "
        source_sp(str[8:end])
    else
        _ngspice_parser(str)
    end
end

interactive() = (init(); 
           initrepl(_repl_parser,
                  prompt_text  = "NgSpice> ",
                  prompt_color = :yellow,
                  start_key    = '~',
                  mode_name    = "for NgSpice is",
                  ))

 