
using BinaryProvider
using Libdl: dlext

const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

const url = "https://github.com/schrodinger/coordgenlibs/archive/v1.2.2.tar.gz"
const hash = "e663e59c521e352d4994176b6826adf6c39a5b980291c26a68ea55f964bd88ef"
products = Product[
    LibraryProduct(prefix, "libcoordgen", :libcoordgen)
]

if any(!satisfied(p; verbose=verbose) for p in products)
    tarball_dir = joinpath(prefix, "downloads")
    tarball_path = joinpath(prefix, "downloads", "v1.2.2.tar.gz")
    source_dir = joinpath(prefix, "downloads", "src")
    install_dir = joinpath(source_dir, "build")
    # delete old files
    rm(tarball_dir, force=true, recursive=true)
    rm(source_dir, force=true, recursive=true)
    
    verbose && @info("Unpacking $tarball_path into $source_dir")
    download_verify(url, hash, tarball_path, force=true, verbose=verbose)
    unpack(tarball_path, source_dir; verbose=verbose)
    verbose && @info("Compiling in $source_dir...")
    mkdir(install_dir)
    cd(install_dir) do
        run(`cmake ..`)
    end
    # write_deps_file(joinpath(@__DIR__, "deps.jl"), products, verbose=true)
end
