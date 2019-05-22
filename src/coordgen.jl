#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

using BinaryProvider
using Libdl: dlext


# Settings
url = "https://github.com/zeromq/libzmq/releases/download/v4.2.5/zeromq-4.2.5.tar.gz"
hash = ""
prefix = Prefix("../deps")

function compile()
    tarball_path = join(prefix, "downloads", "src.tar.gz")

    download_verify_unpack(url, hash, tarball_path, force=true, verbose=false)
    rm(tarball_dir, force=true, recursive=true)

    cd(source_path) do
        run(`./configure --prefix=$install_dir`)
        run("make")
        run("make install")
    end
end

# install

install(url, tarball_hash, prefix=prefix)
products = [LibraryProduct(prefix, ["coordgenlibs"], "src.tar.gz")]

write_deps_file(joinpath(@__DIR__, "deps.jl", products)
