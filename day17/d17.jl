input = readline("input.txt")
important = split(input[14:end], ", ")

function gettarget(str)
	nums = str[3:end]
	indnums = split(nums, "..")
	num1 = parse(Int, indnums[1])
	num2 = parse(Int, indnums[2])
	return num1:num2
end

targets = gettarget.(important)
xtarget, ytarget = targets

function singleshot(xvel, yvel, xtarget, ytarget)
	x, y = 0, 0
	while x <= xtarget[end] && y >= ytarget[1]
		x += xvel
		y += yvel
		yvel -= 1
		xvel = xvel == 0 ? 0 : xvel - 1
		x in xtarget && y in ytarget && (return true)
	end
	return false
end

function getxrange(xtarget)
	rangeend = xtarget[end]
	for i in 1:xtarget[1]
		added = i*(i+1)/2
		added >= xtarget[1] && (return i:rangeend)
	end
	return -1:rangeend
end

xrange = getxrange(xtarget)
yrange = ytarget[1]:100

function testshots(xtarget, ytarget, xrange, yrange)
	corrects = Tuple{Int, Int}[]
	for x in xrange, y in yrange
		singleshot(x, y, xtarget, ytarget) && push!(corrects, (x, y))
	end
	return corrects
end

corrects = testshots(xtarget, ytarget, xrange, yrange)
println(length(corrects))