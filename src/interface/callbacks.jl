function sendchar(_text::Ptr{Cchar}, id::Cint, userdata::Ptr{Cvoid})::Cint
    copy_len = ccall(:strlen, Csize_t, (Ptr{Cchar},), _text)
    for c in 1:copy_len
        push!(string_buffer,unsafe_load(_text,c))
    end
    push!(string_buffer,'\n')
        
    ccall(:uv_async_send, Cint, (Ptr{Cvoid},), async_cond[].handle)
    return zero(Int32)
end
precompile(sendchar,(Ptr{Cchar},Cint,Ptr{Cvoid}))



function controlledexit(exitstatus::Cint, immediate::Cint, quitexit::Cint, id::Cint, userdata::Ptr{Cvoid})::Cint
    quitexit == 1 && println("Returned from quit with exit status")
    return exitstatus
end



