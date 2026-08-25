function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    ccall((:ngSpice_Init, libngspice), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
end

#-----------------------------------------------------------------
# This implementation is really worried about thread safety,
# but maybe not altogether necessary? I assume the command
# string will be consumed rapidly by the receiving ccall
# and not needed again after it returns.
function ngSpice_Command(command::String)
    # Calculate bytes needed (including the NUL terminator)
    byte_count = sizeof(command) + 1 
    
    # 1. Allocate raw system memory that Julia's GC will completely ignore
    c_buffer = Libc.malloc(byte_count)
    
    # 2. Safely copy Julia's string data into the raw system buffer
    GC.@preserve command begin
        src_ptr = Base.unsafe_convert(Cstring, command)
        # Copy the characters + trailing NUL byte
        unsafe_copyto!(convert(Ptr{UInt8}, c_buffer), convert(Ptr{UInt8}, src_ptr), byte_count)

        @ccall libngspice.ngSpice_Command(c_buffer::Ptr{Cchar})::Cint
    end
end


#-----------------------------------------------------------------
# These seem safe
function ngSpice_CurPlot()
    ccall((:ngSpice_CurPlot, libngspice), Ptr{UInt8}, ())
end

function ngSpice_AllPlots()
    ccall((:ngSpice_AllPlots, libngspice), Ptr{Ptr{UInt8}}, ())
end


#-----------------------------------------------------------------
# These functions are potentially unsafe due to passing String
# to Csting on foreign thread
function ngGet_Vec_Info(vecname)
    ccall((:ngGet_Vec_Info, libngspice), pVectorInfo, (Cstring,), vecname)
end


function ngSpice_AllVecs(plotname)
    ccall((:ngSpice_AllVecs, libngspice), Ptr{Ptr{UInt8}}, (Cstring,), plotname)
end


#-----------------------------------------------------------------
# Is this safe?
function ngSpice_Circ(circarray)
    ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Ptr{UInt8}},), circarray)
end
