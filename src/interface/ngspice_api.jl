function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, libngspice), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end

function ngSpice_Init_Sync(vsrcdat, isrcdat, syncdat, ident, userData)
    ccall((:ngSpice_Init_Sync, libngspice), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cvoid}), vsrcdat, isrcdat, syncdat, ident, userData)
end 

function ngSpice_Command(command)
    ccall((:ngSpice_Command, libngspice), Cint, (Cstring,), command)
end

function ngGet_Vec_Info(vecname)
    ccall((:ngGet_Vec_Info, libngspice), pvector_info, (Cstring,), vecname)
end

function ngSpice_Circ(circarray)
    ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Ptr{UInt8}},), circarray)
end 

function ngSpice_CurPlot()
    ccall((:ngSpice_CurPlot, libngspice), Ptr{UInt8}, ())
end

function ngSpice_AllPlots()
    ccall((:ngSpice_AllPlots, libngspice), Ptr{Ptr{UInt8}}, ())
end

function ngSpice_AllVecs(plotname)
    ccall((:ngSpice_AllVecs, libngspice), Ptr{Cstring}, (Cstring,), plotname)
end

function ngSpice_running()
    ccall((:ngSpice_running, libngspice), Cint, ())
end

function ngSpice_SetBkpt()
    ccall((:ngSpice_SetBkpt, libngspice), Cint, ())
end
