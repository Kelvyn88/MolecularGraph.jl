#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

using BinaryProvider
using Libdl: dlext


# Settings
url = "https://github.com/schrodinger/coordgenlibs/archive/v1.2.2.tar.gz"
prefix = Prefix("../deps")

# Download and compile
if !isexists(dylib)
    tarball_path = join(prefix, "downloads", "src.tar.gz")
    download(url, tarball_path)
    
    rm(tarball_dir, force=true, recursive=true)
    unpack()
    cd(source_path) do
        run(`./configure --prefix=$install_dir`)
        run("make")
        run("make install")
    end
end

# install

products = [LibraryProduct(prefix, ["coordgenlibs"], "src.tar.gz")]
write_deps_file(joinpath(@__DIR__, "deps.jl", products)
