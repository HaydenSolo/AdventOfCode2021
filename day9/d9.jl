const data = map(line -> parse.(Int, line), split.(readlines("input.txt"), ""))

imax = length(data)
jmax = length(data[1])

low(data, i, j) = (current = data[i][j]; (i == 1 || current < data[i-1][j]) && (i == imax || current < data[i+1][j]) && (j == 1 || current < data[i][j-1]) && (j == jmax || current < data[i][j+1]))

function basin(data, i, j, visited)
	current = data[i][j]
	current == 9 && (return 0)
	total = 1
	visited[i, j] = 1
	i == 1 || visited[i-1, j] || (data[i-1][j] > current && (total += basin(data, i-1, j, visited)))
	i == imax || visited[i+1, j] || (data[i+1][j] > current && (total += basin(data, i+1, j, visited)))
	j == 1 || visited[i, j-1] || (data[i][j-1] > current && (total += basin(data, i, j-1, visited)))
	j == jmax || visited[i, j+1] || (data[i][j+1] > current && (total += basin(data, i, j+1, visited)))
	return total
end


lowpoints = []
for i in 1:imax, j in 1:jmax
	low(data, i, j) && (push!(lowpoints, (i, j)))
end

basins = []
visited = falses(imax, jmax)
for l in lowpoints
	s = basin(data, l[1], l[2], visited)
	push!(basins, s)
end

sorted = sort(basins, rev=true)
firstthree = sorted[1:3]
test = [data[i][j] for i in 1:imax, j in 1:jmax if data[i][j] != 9]
println(firstthree[1]*firstthree[2]*firstthree[3])