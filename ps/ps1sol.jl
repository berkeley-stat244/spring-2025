## Problem 1a

using FiniteDifferences

function newton(x, fun; tol = 1e-5, maxit = 100)
    x_old = Inf
    it = 0
    while abs(x_old - x) > tol && it <= maxit
        x_old = x;
        x = x - central_fdm(2, 1)(fun, x)/central_fdm(3, 2)(fun, x);
        it += 1;
    end
    return x
end

## Problem 1b

function newton(x, fun; tol = 1e-5, maxit = 100)
    x_old = Inf
    it = 0
    while abs(x_old - x) > tol && it <= maxit
        x_old = x;
        x = x - central_fdm(2, 1)(fun, x)/central_fdm(3, 2)(fun, x);
        it += 1
    end
    return Dict(x => x, value => fun(x), converged = it < maxit)
end

## Problem 1c

function newton(x, fun; tol = 1e-5, maxit = 100)
    x_old = Inf
    it = 0
    values = Float64[]
    while abs(x_old - x) > tol && it <= maxit
        x_old = x;
        x = x - central_fdm(2, 1)(fun, x)/central_fdm(3, 2)(fun, x);
        push!(values, x)
        it += 1
    end
    return Dict(x => x, sequence => values, value => fun(x), converged = it < maxit)
end

## Problem 1d

function newton(x::Real, fun::Function; tol::Real = 1e-5, maxit::Int = 100)
    # code from above
    return Dict(x => x, value => fun(x), converged = converged)
end

## Problem 2

#=


a. third row, returning a vector
b. second row, returning a 1-row matrix
c. modifies A[1,1] in place
d. puts zeros into first three rows, 2nd and 3rd cols in place
e. replaces subblock of matrix
f. extracts 3rd column as a vector
g. pastes A together columnwise with another matrix given by row, producing a 4-row, 6 column result
h. 1st and 3rd elements of 2nd column as a vector
i. Not allowed because there is no 4th column

=#

## Problem 3: some options, though the simplest one using the `2:2:end` sequence is best.

x = 1:30
inds = 1:n
x[2:2:end]

[x[i] for i in 1:n if iseven(i)]

bools = repeat([false, true], Int(n/2))
x[bools]

x[inds .% 2 .== 0]  # returns BitVector, not usable for indexing

y=[]
for i in 1:n
    if iseven(i)
        push!(y, x[i])
    end
end

## Problem 4

A = reshape((-22:22) .% 11, 9, 5)

### Problem 4a
sum(A.^2 .< 10)
### Problem 4b
A[ : , A[1,:] .>= 0]
### Problem 4c
A[A .% 2 .== 0] .= A[A .% 2 .== 0] .* 3;
A[A .% 2 .== 0] = A[A .% 2 .== 0] .* 3
[iseven(A[i,j]) ? A[i,j]*3 : A[i,j] for i=1:size(A)[1], j = 1:size(A)[2]]

## Problem 5

## `x.b` is just a pointer to the same object referenced by `tmp`
tmp = rand(100)
x = (a=7, b=tmp)
sizeof(x)
pointer_from_objref(x.b)
pointer_from_objref(tmp)
x.b[1]
tmp[1] = 3.33

## `y["b"]` is just a pointer to the same object referenced by `tmp`
y = Dict("a" => 7, "b" =>  tmp)
sizeof(y)
pointer_from_objref(tmp)
pointer_from_objref(y["b"])
tmp[1]
tmp[1] = 5.55
y["b"][1]

## Dicts seem to be of fixed size, so presumably they are just wrappers
## in some form, and noting that lookup uses hashing, so that impacts
## how the values are actually stored.
y = Dict("a" => 7, "b" =>  tmp, "hello" => 5)
sizeof(y)
y = Dict("a" => 7, "b" =>  'd', "hello" => 5)
sizeof(y)
y = Dict("a" => 7, "b" =>  'd', "hello" => 5, 1=>1,2=>2,3=>3,4=>4,5=>5,6=>6)
sizeof(y)

## again a user-defined type just seems to be a set of pointers
struct Test
    x
    y
    z
end

v = Test(5,7,9)
w = Test(5,tmp,9)
sizeof(v)
sizeof(w)
pointer_from_objref(tmp)
pointer_from_objref(w.y)

## For arrays, we saw this in class/notes:


### Homogeneous array with all elements stored contiguously
x = rand(Float32, n)
sizeof(x) == 4*n   # 4 bytes (32 bits) per Float32 element

### Heterogeneous array with elements being pointers that reference the element values
y = Any[]
for w in x
    push!(y, w)
end
sizeof(y)/8 == n  ## 8 bytes per pointer
tmp = "aldskjflasdkjfalsfjda;ldjkf;alkdjfaljkdfalkdjfaldjkf"
y[1] = tmp
sizeof(y)



