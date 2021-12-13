lines = readlines("input.txt")

struct Point
	x::Int
	y::Int
end
function Point(str::String) 
	x, y = parse.(Int, split(str, ","))
	return Point(x, y)
end

foldsplit(fold) = fold[12:end]

function singlefold(points, fold)
	foldx = fold[1] == "x"
	line = fold[2]
	xmax = -1
	ymax = -1
	for point in points
		point.x > xmax && (xmax = point.x)
		point.y > ymax && (ymax = point.y)
	end

	newpoints = filter(p -> (foldx ? p.x : p.y) < line, points)
	replacepoints = filter(p -> (foldx ? p.x : p.y) > line, points)

	for point in replacepoints
		distancepast = (foldx ? point.x : point.y) - line
		newpos = line - distancepast
		newpoint = foldx ? Point(newpos, point.y) : Point(point.x, newpos)
		push!(newpoints, newpoint)
	end
	return newpoints
end


function runfolds(points, folds)
	for fold in folds
		points = singlefold(points, fold)
	end
	return Set(points)
end


function printpoints(points)
	xmax = -1
	ymax = -1
	for point in points
		point.x > xmax && (xmax = point.x)
		point.y > ymax && (ymax = point.y)
	end

	for y in 0:ymax
		for x in 0:xmax
			print(Point(x, y) in points ? "#" : ".")
		end
		println()
	end
end


ind = -1
for (i, l) in enumerate(lines)
	if l == ""
		global ind = i
	end
end

points = Point.(lines[1:ind-1])
folds = foldsplit.(lines[ind+1:end])

parsefold(fold) = (sfold = split(fold, "="); (sfold[1], parse(Int, sfold[2])))

parsedfolds = parsefold.(folds)
finalpoints = runfolds(points, parsedfolds)
printpoints(finalpoints)