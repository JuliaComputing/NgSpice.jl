# Raw libngspice entry points. Each call is serialised through NGSPICE_LOCK and
# restores Julia's signal handlers afterwards (see interface/signals.jl).

function ngSpice_Init(printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
    # Snapshot Julia's handlers before ngspice gets a chance to touch them.
    isempty(saved_sigactions) && save_julia_signal_handlers!()
    lock(NGSPICE_LOCK) do
        # While ngSpice_Init runs, ngspice's own SIGSEGV handler is installed, so
        # no stop-the-world GC may start. This disable/enable pair is balanced and
        # has no yield point in between, so it cannot migrate between threads.
        gc_was_on = GC.enable(false)
        try
            with_julia_signals() do
                ccall((:ngSpice_Init, libngspice), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}), printfcn, statfcn, ngexit, sdata, sinitdata, bgtrun, userData)
            end
        finally
            GC.enable(gc_was_on)
        end
    end
end

function ngSpice_Init_JLExtensions(path_resolve)
    ret = try;
        _ngcall() do
            ccall((:ngSpice_Init_JLExtensions, libngspice), Cint, (Cint, Ptr{Cvoid},),
                1, path_resolve)
        end
    catch e;
        @warn "Failed to initialize julia extensions. Some features may not work."
        return false
    end
    if ret != 0
        error("Failed to initialize julia extensions")
    end
    return true
end

function ngSpice_Init_Sync(vsrcdat, isrcdat, syncdat, ident, userData)
    _ngcall() do
        ccall((:ngSpice_Init_Sync, libngspice), Cint, (Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cvoid}, Ptr{Cint}, Ptr{Cvoid}), vsrcdat, isrcdat, syncdat, ident, userData)
    end
end

function ngSpice_Command(command)
    _ngcall() do
        ccall((:ngSpice_Command, libngspice), Cint, (Cstring,), command)
    end
end

function ngGet_Vec_Info(vecname)
    _ngcall() do
        ccall((:ngGet_Vec_Info, libngspice), pvector_info, (Cstring,), vecname)
    end
end

function ngSpice_Circ(circarray)
    _ngcall() do
        ccall((:ngSpice_Circ, libngspice), Cint, (Ptr{Ptr{UInt8}},), circarray)
    end
end

function ngSpice_CurPlot()
    _ngcall() do
        ccall((:ngSpice_CurPlot, libngspice), Ptr{UInt8}, ())
    end
end

function ngSpice_AllPlots()
    _ngcall() do
        ccall((:ngSpice_AllPlots, libngspice), Ptr{Ptr{UInt8}}, ())
    end
end

function ngSpice_AllVecs(plotname)
    _ngcall() do
        ccall((:ngSpice_AllVecs, libngspice), Ptr{Ptr{UInt8}}, (Cstring,), plotname)
    end
end

function ngSpice_running()
    _ngcall() do
        ccall((:ngSpice_running, libngspice), Cint, ())
    end
end

function ngSpice_SetBkpt(bkpt)
    _ngcall() do
        ccall((:ngSpice_SetBkpt, libngspice), Cint, (Cdouble,), bkpt)
    end
end
