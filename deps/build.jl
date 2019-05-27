
using BinaryProvider

# Parse some basic command-line arguments
const verbose = "--verbose" in ARGS
const prefix = Prefix(get([a for a in ARGS if a != "--verbose"], 1, joinpath(@__DIR__, "usr")))

const url = "https://github.com/schrodinger/coordgenlibs/archive/v1.2.2.tar.gz"
const hash = "8c2732785cf1f0c89830c81439dbfa59b6475f47"

# These are the two binary objects we care about
products = Product[
    LibraryProduct(prefix, "libcoordgen", :libcoordgen)
]


# First, check to see if we're all satisfied
if any(!satisfied(p; verbose=verbose) for p in products)
    # Download and install binaries
    install(url, hash; prefix=prefix, force=true, verbose=true)

    # Finally, write out a deps.jl file
    write_deps_file(joinpath(@__DIR__, "deps.jl"), products)
end
