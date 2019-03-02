#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

export
    Topology,
    topology!


struct Topology <: Annotation
    rings::Vector{Vector{Int}}
    scaffolds::Vector{Set{Int}}
    molecules::Vector{Set{Int}}
end


"""
    topology!(mol::VectorMol)

Assign graph topology parameter vectors to the molecule.
"""
function topology!(mol::VectorMol)
    haskey(mol.annotation, :Topology) && return
    # TODO: shortcut function
    # minimumcycles is derived from 2-edge connected components
    # 2-edge connected components is derived from connected components
    components = connected_components(mol.graph)  # Vector{Set{Int}}
    scaffolds = two_edge_connected(mol.graph)  # Vector{Set{Int}}
    rings = minimumcycles(mol.graph)  # Vector{Vector{Int}}

    mol.annotation[:Topology] = Topology(rings, scaffolds, components)
    # Ring membership
    mol[:RingMem] = Set{Int}[Set() for i in 1:nodecount(mol)] # dont use fill
    # Ring size
    mol[:RingSize] = Set{Int}[Set() for i in 1:nodecount(mol)]
    # Ring bond or not
    mol[:RingBond] = falses(edgecount(mol))
    # Ring bond membership
    mol[:RingBondMem] = Set{Int}[Set() for i in 1:edgecount(mol)]
    for (i, ring) in enumerate(rings)
        size = length(ring)
        for n in ring
            push!(mol[:RingMem][n], i)
            push!(mol[:RingSize][n], size)
        end
        sub = nodesubgraph(mol.graph, Set(ring))
        for e in edgekeys(sub)
            mol[:RingBond][e] = true
            push!(mol[:RingBondMem][e], i)
        end
    end
    # Ring membership count
    mol[:RingMemCount] = length.(mol[:RingMem])

    # Scaffold membership
    mol[:ScaffoldMem] = Vector{Union{Nothing,Int}}(nothing, atomcount(mol))
    for (i, scaffold) in enumerate(scaffolds)
        for s in scaffold
            mol[:ScaffoldMem][s] = i
        end
    end
    # Component membership
    mol[:ComponentMem] = Vector{Union{Nothing,Int}}(nothing, atomcount(mol))
    for (i, component) in enumerate(components)
        for c in component
            mol[:ComponentMem][c] = i
        end
    end
end
