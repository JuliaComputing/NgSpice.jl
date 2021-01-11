function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, libngspice), Cint, (Ptr{SendChar}, Ptr{SendStat}, Ptr{ControlledExit}, Ptr{SendData}, Ptr{SendInitData}, Ptr{BGThreadRunning}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end #function pointers tbd

function ngSpice_Init_Sync(vsrcdat, isrcdat, syncdat, ident, userData)
    ccall((:ngSpice_Init_Sync, libngspice), Cint, (Ptr{GetVSRCData}, Ptr{GetISRCData}, Ptr{GetSyncData}, Ptr{Cint}, Ptr{Cvoid}), vsrcdat, isrcdat, syncdat, ident, userData)
end #function pointers tbd

function ngSpice_Command(command)
    ccall((:ngSpice_Command, libngspice), Cint, (Cstring,), command)
end #ROME without a trace

function ngGet_Vec_Info(vecname)
    ccall((:ngGet_Vec_Info, libngspice), pvector_info, (Cstring,), vecname)
end #ROME without a trace

function ngSpice_Circ(circarray)
    ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Cstring},), circarray)
end #unsafe_convert between ::Type{Ptr{Cstring}}, ::Type{Ptr{String}} needs to be added 

function ngSpice_CurPlot()
    ccall((:ngSpice_CurPlot, libngspice), Cstring, ())
end

function ngSpice_AllPlots()
    ccall((:ngSpice_AllPlots, libngspice), Ptr{Cstring}, ())
end #ROME without a trace

function ngSpice_AllVecs(plotname)
    ccall((:ngSpice_AllVecs, libngspice), Ptr{Cstring}, (Cstring,), plotname)
end

function ngSpice_running()
    ccall((:ngSpice_running, libngspice), Cint, ())
end

function ngSpice_SetBkpt()
    ccall((:ngSpice_SetBkpt, libngspice), Cint, ())
end
