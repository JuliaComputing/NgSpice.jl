# Raw libngspice entry points. None of these are thread-safe or re-entrant;
# call them only through the locked wrappers in src/API.

function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, libngspice), Cint,
          (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}),
          printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end

# ngspice copies the command, and ccall keeps `command` alive for the duration
# of the call, so a Cstring argument is sufficient (no malloc copy needed).
function ngSpice_Command(command::AbstractString)
    @ccall libngspice.ngSpice_Command(command::Cstring)::Cint
end

ngSpice_CurPlot()  = ccall((:ngSpice_CurPlot, libngspice), Ptr{UInt8}, ())
ngSpice_AllPlots() = ccall((:ngSpice_AllPlots, libngspice), Ptr{Ptr{UInt8}}, ())

ngGet_Vec_Info(vecname::AbstractString) =
    ccall((:ngGet_Vec_Info, libngspice), pVectorInfo, (Cstring,), vecname)

ngSpice_AllVecs(plotname::AbstractString) =
    ccall((:ngSpice_AllVecs, libngspice), Ptr{Ptr{UInt8}}, (Cstring,), plotname)

# Julia converts a Vector{String} to a NULL-terminated char** for this call
# and keeps the strings alive until it returns; ngspice copies the lines.
ngSpice_Circ(lines::Vector{String}) =
    ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Ptr{UInt8}},), lines)
