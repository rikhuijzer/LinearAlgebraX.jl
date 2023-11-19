export rrefx

"""
    rrefx(A::AbstractMatrix{T}) where {T<:IntegerX}

`rref(A)`  returns the row-reduced echelon form of the exact 
matrix `A`.
"""
function rrefx(A::AbstractMatrix{T}) where {T<:IntegerX}
    AA = big.(A // 1)
    return rrefx(AA)
end

function rrefx(A::AbstractMatrix{T}) where {T}
    AA = copy(A)
    rrefx!(AA)
    return AA
end


function _pivot!(A::AbstractMatrix{T}, i::Int, j::Int) where {T}
    r, c = size(A)
    s = A[i, j]
    row_scale!(A, i, invx(s))

    for k = 1:r
        if k != i
            s = -A[k, j]
            row_add_mult!(A, i, s, k)
        end
    end
end



function rrefx!(A::AbstractMatrix{T}) where {T}
    rn, nc = size(A)

    r = 1
    for j = 1:nc
        # see if column j's first one is at level r or below
        col = A[r:end, j]
        if all(col .== 0)
            continue
        end
        k = findfirst(col .!= 0)
        row_swap!(A, r, k + r - 1)
        _pivot!(A, r, j)
        r += 1
    end


end
