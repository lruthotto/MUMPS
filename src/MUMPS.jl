module MUMPS

    type MUMPSfactorization
        ptr::Int64
        nrow::Int64
        ncol::Int64
        real::Bool
        time::Float64
    end
	include("MUMPSfuncs.jl")

    export solveMUMPS, factorMUMPS, applyMUMPS,destroyMUMPS, MUMPSfactorization

end