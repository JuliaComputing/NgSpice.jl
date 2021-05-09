const JLPATH_PREFIX = "jlpkg:"

function c_strdup(str)
	ptr = @ccall libngspice.tmalloc((sizeof(str)+1)::Cint)::Ptr{UInt8}
	@GC.preserve str Base.unsafe_copyto!(ptr, pointer(str), sizeof(str))
	unsafe_store!(ptr, UInt8(0), sizeof(str) + 1)
	ptr
end

function path_resolve(name::Cstring, dir::Cstring)::Cstring
    name = unsafe_string(name)
    dir = unsafe_string(dir)

    if startswith(name, JLPATH_PREFIX)
        path = name[sizeof(JLPATH_PREFIX)+1:end]
        components = splitpath(path)

        @assert components[1] != "/"

        pkg_path = Base.locate_package(Base.PkgId(components[1]))
        if pkg_path !== nothing
            pkg_path = realpath(joinpath(dirname(pkg_path), ".."))
            file_path = joinpath(pkg_path, components[2:end]...)
            return c_strdup(file_path)
        end

        return Ptr{Cchar}(-1)
    end
    return C_NULL
end
