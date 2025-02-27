## Partial sketch solutions for PS2.
## Time-permitting I may add in more details, potentially based on student solutions.
## Caution: I have not checked the code as much as I should, so if you see
## a potential problem, it may well be an error on my part.

## Problem 1a

function sumdict(d::Dict{<:Any,<:Number})
       sum = 0.;
       for elem in values(d)
         sum += elem;
       end
       return sum
end

y = Dict("a" => 3,'b' => 7.5)
sumdict(y)

## Problem 1b

## This turned out to be trickier than I intended/thought it would be, as
## one needs to define the type of the dictionary values when the dictionary
## is created, which is not user-friendly.

StringLike = Union{String, Char};

function sumdict(d::Dict{<:Any,<:StringLike})
       conc = "";
       for elem in values(d)
         conc *= elem;
       end
       return conc
end

y = Dict{Any,StringLike}("a" => "abc", 'b' => "def", 'c' => 'g')
sumdict(y)

## This won't find a `sumdict` method that can be used.
y = Dict("a" => "abc", 'b' => "def", 'c' => 'g')
sumdict(y)

## Perhaps best would be not to check the types of the Dict keys and values
## in the definition, but to check at run-time and error out if needed.

## Problem 2a

using FiniteDifferences

## If using `FiniteDifferences`, this turned out to be harder than I thought it
## would be, as one can't pass additional args to `central_fdm`.
## If one had written one's own numerical derivative function, or perhaps if
## using other finite differencing package, we wouldn't need to create the wrapper
## function.

function newton(x, fun; tol = 1e-5, maxit = 100, kwargs...)
    ## Need a wrapper that embeds the use of the `kwargs` via scoping.
    function simple_fun(x)
        return fun(x; kwargs...)
    end
    
    x_old = Inf
    it = 0
    while abs(x_old - x) > tol && it <= maxit
        x_old = x;
        x = x - central_fdm(2, 1)(simple_fun, x)/central_fdm(3, 2)(simple_fun, x);
        it += 1;
    end
    return x
end

function cosplus(x; y)
    return sin(x) + y
end

newton(2.0, cosplus, y = 35)


## problem 2b and 2c (i)

function newton_robust(x, fun; tol = 1e-5, maxit = 100)
    x_orig = x;
    x_hist_2step = Inf;
    x_hist_1step = x;
    it = 0;
    while abs(x_hist_2step - x_hist_1step) > tol && it < maxit
        x = x - central_fdm(2, 1)(fun, x)/central_fdm(3, 2)(fun, x);
        if fun(x) > fun(x_hist_1step)
            @warn "Optimization moved uphill at iteration $(it) and may be converging to a local maximum."
            ## TODO: insert code for backtracking.
        end
        if (it >0 && x < x_hist_2step && x < x_hist_1step) || (it > 0 && x > x_hist_2step && x > x_hist_1step)
            @info "Optimization stepped outside of previous interval at iteration $(it) and may be diverging."
            ## TODO: insert code for bisection
        end
        x_hist_2step = x_hist_1step;
        x_hist_1step = x;
        it += 1;
    end
    if it == maxit 
        converged = 1;
    else
        converged = 0;
    end
    if fun(x) > fun(x_orig)
        minimum = false;
    else
        minimum = true;
    end
    return (x = x, value = fun(x), converged = converged, minimum = minimum, iterations = it)
end

function tricky_fun(x)
    return x*atan(x) - 0.5*log(abs(1+x*x))
end

newton_robust(2, cos)

newton_robust(0.1, tricky_fun)

## Problem 2d

### I did not get a chance to set up a solution for this.

## Problem 3

"""
A wrapper function that counts the number of times a function is called.
"""
function counter(f)
   cnt=0;
   name = string(f)
   function wrapper(args...; kwargs...)
       cnt += 1;
       println("`$(name)` has been run $(cnt) times.")
       return f(args...; kwargs...)
   end
   return wrapper
end

"""
A wrapper function that counts the number of times a function is called,
only reporting if `_report = true`.
"""
function counter_report(f)
   cnt=0;
   name = string(f)
   function wrapper(args...; kwargs...)
       if :_report ∈ keys(kwargs) && kwargs[:_report]
         println("`$(name)` has been run $(cnt) times.")
       else 
         cnt += 1;
         return f(args...; kwargs...)
       end
   end
   return wrapper
end

function tmp(x; y)
    return nothing
end

wrap_orig = counter(tmp)
wrap_report = counter_report(tmp)

wrap_orig(3; y=2)
wrap_orig(3; y=2)
wrap_orig(3; y=2)
wrap_report(3; y=2)
wrap_report(3; y=2)
wrap_report(;_report = true)

## Problem 3 (alternate; with a macro)

const CALL_COUNTS = Dict{Any, Int}()

import ExprTools

# Macro to create a counted version of a function
macro counted(func)
    def = ExprTools.splitdef(func)
    name = def[:name]
    body = def[:body]
     
    # Create new function definition that increments counter
    def[:body] =  quote
        CALL_COUNTS[$name] = get(CALL_COUNTS, $name, 0) + 1
        $body
    end

    return esc(ExprTools.combinedef(def))
end

@counted function my_add(x, y)
    return x + y
end

# Use the function
my_add(2, 3)
my_add(4, 5)

CALL_COUNTS[my_add]


## Problem 4a

### I used Claude as a starting point, providing it with the LaTeX equation for the denominator.
### It did not combine the 2nd and 3rd terms, though it noted that they would cancel!

using SpecialFunctions  # for log factorial

function logf_one(k::Int, n::Int, p::Float64, ϕ::Float64)
    # Compute in log space for numerical stability
    log_result = 0.0
    
    # Term 1: log of binomial coefficient (could also use `loggamma`).
    log_result += logabsbinomial(n, k)[1];

    # Combine Terms 2 and 3, by raising to ϕ-1 power.
    # Account for log(0^0) = 0.
    if k > 0
        log_result -= (ϕ-1) * k * log(k);
    end
    if k < n
        log_result -= (ϕ-1) * (n-k) * log(n-k); 
    end
    if n > 0
        log_result += (ϕ-1) * n * log(n);
    end
    
    # Term 4
    log_result += k * ϕ * log(p) + (n-k) * ϕ * log(1-p); 
end

function denom_loop(n::Int, p::Float64, ϕ::Float64)
    # Input validation
    n > 0 || throw(ArgumentError("n must be positive"))
    0 ≤ p ≤ 1 || throw(ArgumentError("p must be between 0 and 1"))
    ϕ > 0 || throw(ArgumentError("ϕ must be positive"))
    
    result = 0.0;
    for k in 1:n
        result += exp(logf_one(k, n, p, ϕ));
    end
    return result
end

function denom_vec(n::Int, p::Float64, ϕ::Float64)
    kvals = 0:n;
    klogk = kvals .* log.(kvals);
    klogk[1] = 0;
    
    nmk = n .- kvals;
    nmklognmk = nmk .* log.(nmk);
    nmklognmk[n+1] = 0;

    ## Awkward/inefficient to work with `logabsbinomial.` as it returns a vector of tuples,
    ## so write out 'manually' using log gamma function.
    return sum(exp.(lgamma(n+1) .- lgamma.(kvals.+1) .- lgamma.(nmk.+1) .+ (ϕ-1)*(n*log(n) .- klogk .- nmklognmk) +
                 ϕ .* kvals .* log(p) + (n .- kvals) .* ϕ .* log(1-p)))
end

n = 10000;
p = 0.3;
ϕ = 0.5;

## Slight numerical differences:
@time denom_loop(n, p, ϕ) # 1.414257917333967
@time denom_vec(n, p, ϕ)  # 1.4142579173388334

using BenchmarkTools

@btime denom_loop(n, p, ϕ); #  1.699 ms (0 allocations: 0 bytes)
@btime denom_vec(n, p, ϕ);  #  1.382 ms (16 allocations: 625.88 KiB)

## Problem 4b

## Vectorized outside a function:
@btime begin
    kvals = 0:n;
    klogk = kvals .* log.(kvals);
    klogk[1] = 0;
    
    nmk = n .- kvals;
    nmklognmk = nmk .* log.(nmk);
    nmklognmk[n+1] = 0;

    ## Awkward/inefficient to work with `logabsbinomial.` as it returns a vector of tuples.
    result = sum(exp.(lgamma(n+1) .- lgamma.(kvals.+1) .- lgamma.(nmk.+1) .+ (ϕ-1)*(n*log(n) .- klogk .- nmklognmk) +
                 ϕ .* kvals .* log(p) + (n .- kvals) .* ϕ .* log(1-p)));
end
# 1.396 ms (47 allocations: 626.91 KiB)

## Actually, the speed is very similar, perhaps because the vectorized calls are already compiled.

## Looped approach outside a function:

@btime begin
    result = 0.0;
    for k in 1:n

        # Compute in log space for numerical stability
        log_result = 0.0
        
        # Term 1: log of binomial coefficient (could also use `loggamma`).
        log_result += logabsbinomial(n, k)[1];
        
        # Combine Terms 2 and 3 by raising to ϕ-1 power.
        # Account for log(0^0) = 0.
        if k > 0
            log_result -= (ϕ-1) * k * log(k);
        end
        if k < n
            log_result -= (ϕ-1) * (n-k) * log(n-k); 
        end
        if n > 0
            log_result += (ϕ-1) * n * log(n);
        end
        
        # Term 4
        log_result += k * ϕ * log(p) + (n-k) * ϕ * log(1-p);
        
        result += exp(log_result);
    end
end
# 7.429 ms (297439 allocations: 4.84 MiB)

## So that is rather slower.

