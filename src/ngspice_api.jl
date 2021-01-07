# Julia wrapper for header: sharedspice.h
# Automatically generated using Clang.jl

function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, ngspice), Cint, (Ptr{SendChar}, Ptr{SendStat}, Ptr{ControlledExit}, Ptr{SendData}, Ptr{SendInitData}, Ptr{BGThreadRunning}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end

function ngSpice_Init_Sync(vsrcdat, isrcdat, syncdat, ident, userData)
    ccall((:ngSpice_Init_Sync, ngspice), Cint, (Ptr{GetVSRCData}, Ptr{GetISRCData}, Ptr{GetSyncData}, Ptr{Cint}, Ptr{Cvoid}), vsrcdat, isrcdat, syncdat, ident, userData)
end

function ngSpice_Command(command)
    ccall((:ngSpice_Command, ngspice), Cint, (Cstring,), command)
end

function ngGet_Vec_Info(vecname)
    ccall((:ngGet_Vec_Info, ngspice), pvector_info, (Cstring,), vecname)
end

function ngSpice_Circ(circarray)
    ccall((:ngSpice_Circ, ngspice), Cint, (Ptr{Cstring},), circarray)
end

function ngSpice_CurPlot()
    ccall((:ngSpice_CurPlot, ngspice), Cstring, ())
end

function ngSpice_AllPlots()
    ccall((:ngSpice_AllPlots, ngspice), Ptr{Cstring}, ())
end

function ngSpice_AllVecs(plotname)
    ccall((:ngSpice_AllVecs, ngspice), Ptr{Cstring}, (Cstring,), plotname)
end

function ngSpice_running()
    ccall((:ngSpice_running, ngspice), Cint, ())
end

function ngSpice_SetBkpt()
    ccall((:ngSpice_SetBkpt, ngspice), Cint, ())
end
