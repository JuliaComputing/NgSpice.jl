function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, libngspice), Cint, (Ptr{SendChar}, Ptr{SendStat}, Ptr{ControlledExit}, Ptr{SendData}, Ptr{SendInitData}, Ptr{BGThreadRunning}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end

function ngSpice_Init_Sync(vsrcdat, isrcdat, syncdat, ident, userData)
    ccall((:ngSpice_Init_Sync, libngspice), Cint, (Ptr{GetVSRCData}, Ptr{GetISRCData}, Ptr{GetSyncData}, Ptr{Cint}, Ptr{Cvoid}), vsrcdat, isrcdat, syncdat, ident, userData)
end #Julia crashes

function ngSpice_Command(command)
    ccall((:ngSpice_Command, libngspice), Cint, (Cstring,), command)
end 

function ngGet_Vec_Info(vecname)
    ccall((:ngGet_Vec_Info, libngspice), vector_info, (Cstring,), vecname)
end 

function ngSpice_Circ(circarray)
    ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Ptr{UInt8}},), circarray)
end #unsafe_convert between ::Type{Ptr{Cstring}}, ::Type{Ptr{String}} needs to be added 

function ngSpice_CurPlot()
    ccall((:ngSpice_CurPlot, libngspice), Ptr{UInt8}, ())
end

function ngSpice_AllPlots()
    ccall((:ngSpice_AllPlots, libngspice), Ptr{Ptr{UInt8}}, ())
end 

function ngSpice_AllVecs(plotname)
    ccall((:ngSpice_AllVecs, libngspice), Ptr{UInt8}, (Cstring,), plotname)
end

function ngSpice_running()
    ccall((:ngSpice_running, libngspice), Cint, ())
end

function ngSpice_SetBkpt()
    ccall((:ngSpice_SetBkpt, libngspice), Cint, ())
end
