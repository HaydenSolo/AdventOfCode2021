using AStarSearch

lines = map(collect, readlines("input.txt"))
risks = parse.(Int, permutedims(hcat(lines...)))

UP = CartesianIndex(-1, 0)
DOWN = CartesianIndex(1, 0)
LEFT = CartesianIndex(0, -1)
RIGHT = CartesianIndex(0, 1)
DIRECTIONS = [UP, DOWN, LEFT, RIGHT]

manhattan(a::CartesianIndex, b::CartesianIndex) = sum((*).(abs.((b - a).I), 1))

getmazeneighbours(maze, state) = filter(x -> (1 <= x[1] <= size(maze)[1]*5) && (1 <= x[2] <= size(maze)[2]*5), [state + d for d in DIRECTIONS])

function getrisk(maze, state)
	(sx, sy) = size(maze)
	(x, y) = state[1], state[2]
	
	remx = rem(x, sx)
	remy = rem(y, sy)
	timesx = div(x, sx)
	timesy = div(y, sy)
	remx == 0 && (remx = sx; timesx -= 1)
	remy == 0 && (remy = sy; timesy -= 1)

	value = maze[CartesianIndex(remx, remy)]
	for _ in 1:timesx
		value = value == 9 ? 1 : value + 1
	end
	for _ in 1:timesy
		value = value == 9 ? 1 : value + 1
	end
	return value
end

movecost(maze, state) = getrisk(risks, state)

currentmazeneighbours(state) = getmazeneighbours(risks, state)
currentmovecost(state) = movecost(risks, state)
start = CartesianIndex(1, 1)
goal = CartesianIndex(size(risks)[1]*5, size(risks)[2]*5)

res = astar(currentmazeneighbours, start, goal, heuristic=manhattan, cost=movecost)
println(res.cost)