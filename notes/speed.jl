using BenchmarkTools

function pi_loop(num_throws = 10000)
    in_circle = 0;
    for _ in 1:num_throws
        # Generate random x and y coordinates between -1 and 1
        xpos = rand() * 2 - 1;  # Equivalent to random.uniform(-1.0, 1.0)
        ypos = rand() * 2 - 1;
        
        # Check if point is inside unit circle
        if sqrt(xpos^2 + ypos^2) <= 1.0;  
            in_circle += 1;
        end
    end
    return 4 * in_circle / num_throws
end

function pi_vec(num_throws = 10000)
    xpos = rand(num_throws) .* 2 .- 1;
    ypos = rand(num_throws) .* 2 .- 1;
    in_circle = sum(sqrt.(xpos.^2 + ypos.^2) .<= 1.0);
    return 4 * in_circle / num_throws
end

## Why no compilation time?
@time pi_loop()

## Restart Julia
@time pi_loop(10000)

## Restart Julia
n = 10000;
@time pi_loop(n)
@time pi_loop(n)


@btime pi_loop(1000000)
## Try to decipher the allocations.
## How many 8 MB allocations would there be without loop fusion?
@btime pi_vec(1000000)

## We can deconstruct `pi_vec` to try to see the memory use.
function pi_vec_test(num_throws = 10000)
    xpos = rand(num_throws) .* 2 .- 1;
    ypos = rand(num_throws) .* 2 .- 1;
    in_circle = 0;
    return 4 * in_circle / num_throws
end
@btime pi_vec_test(1000000)
