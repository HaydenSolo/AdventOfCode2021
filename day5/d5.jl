const data = split.(readlines("input.txt"), " -> ")
full = map(line -> map(str -> split(str, ","), line), data)

struct Point
	x::Integer
	y::Integer
	Point(a::Vector{SubString{String}}) = new(parse(Int, a[1]), parse(Int, a[2]))
	Point(x::Integer, y::Integer) = new(x, y)
end

struct Line
	start::Point
	finish::Point
	function Line(line::Vector{Point}) 
		a = line[1]
		b = line[2]
		(b.x > a.x || b.y > a.y) ? new(a, b) : new(b, a)
	end
end

checkline(line) = return line[1][1] == line[2][1] || line[1][2] == line[2][2]

# full = filter(checkline, full)
full = map(line -> Line(map(a -> Point(a), line)), full)

allpoints = []

visited = Set{Point}()
visitedcounted = Set{Point}()
doubles = 0

function getfull(line::Line)
	if line.start.x == line.finish.x || line.start.y == line.finish.y
		full = Vector{Point}()
		for x in line.start.x:line.finish.x, y in line.start.y:line.finish.y
			point = Point(x, y)
			push!(full, point)
		end
		return full
	end

	xdistance = line.finish.x - line.start.x
	ydistance = line.finish.y - line.start.y

	xstep = line.finish.x > line.start.x ? 1 : -1
	ystep = line.finish.y > line.start.y ? 1 : -1

	allfull = [Point(x, y) for x in line.start.x:xstep:line.finish.x, y in line.start.y:ystep:line.finish.y]
	full = [allfull[i, i] for i in 1:size(allfull)[1]]
	return full
end


for line in full
	points = getfull(line)
	for point in points
		if point in visited
			point in visitedcounted || (global doubles += 1; push!(visitedcounted, point))
		else
			push!(visited, point)
		end
	end
end

println(doubles)