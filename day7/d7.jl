const data = map(i -> parse(Int, i), split.(readlines("input.txt"), ",")[1])
using Statistics

movement(x, final) = abs(x - final)
weightedsum(x) = x*(x+1)/2

m = floor(mean(data))

moves = weightedsum.(movement.(data, m))

println(m)
println(moves)
println(Int(sum(moves)))