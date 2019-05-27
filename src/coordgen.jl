#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

using Libdl

# Load in `deps.jl`, complaining if it does not exist
const depsjl_path = joinpath(@__DIR__, "..", "deps", "deps.jl")
if !isfile(depsjl_path)
    error("CoordGen not installed properly, run Pkg.build(\"MolecularGraph\"), restart Julia and try again")
end
include(depsjl_path)

# Module initialization function
function __init__()
    # Always check your dependencies from `deps.jl`
    check_deps()
end


export call_getcoordinates


function call_getcoordinates(mol)
    global getcoordinates

    min_mol = sketcherMinimizerMolecule()
    vector atomvec = []
    for atom in atoms
        a = addNewAtom(min_mol)
        push!(atomvec, a)
        setAtomicNumber(a, num(atom))
    end
    for bond in bonds
        b = addNewBond(min_mol, bond.u, bond.v)
        setBondOrder(b, bond.order)
    end
    minimizer = sketcherMinimizer
    minimizer.initialize(min_mol)
    minimizer.runGenerateCoordinates()
    
    coords = []
    for a in atomvec
        push!(coords, getCoordinates(a))
    end
    
    return coords


    hdl = Libdl.dlopen_e(libfoo)
    @assert hdl != C_NULL "Could not open $libfoo"
    foo = Libdl.dlsym_e(hdl, :foo)
    @assert foo != C_NULL "Could not find foo() within $libfoo"
    return ccall(foo, Cdouble, (Cdouble, Cdouble), a, b)

end
