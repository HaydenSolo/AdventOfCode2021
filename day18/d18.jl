import Base.+

abstract type Instruction end
struct ExplodeLeft <: Instruction end
struct ExplodeRight <: Instruction end
struct NoAction <: Instruction end
struct Ret <: Instruction end
const explodeleft = ExplodeLeft()
const exploderight = ExplodeRight()
const noaction = NoAction()
const ret = Ret()

function delve(str::String)
	depth = 1
	for i in 2:length(str)
		str[i] == '[' && (depth += 1)
		str[i] == ']' && (depth -= 1)
		depth == 0 && (return i)
	end
	return -1
end

function getval(important)
	if important[1] == '['
		endpoint = delve(important)
		val = Pair(important[1:endpoint])
		important = important[endpoint:end]
	else
		val = parse(Int, important[1])
	end
	return val, important
end

mutable struct Pair
	x::Union{Pair, Int}
	y::Union{Pair, Int}
end
function Pair(str::String)
	important = str[2:end-1]
	x, important = getval(important)
	important = important[3:end]
	y, important = getval(important)
	Pair(x, y)
end
printable(p::Int) = p
printable(p::Pair) = "[$(printable(p.x)), $(printable(p.y))]"
Base.show(io::IO, z::Pair) = print(io, printable(z))
function (+)(a::Pair, b::Pair) 
	newpair = Pair(a, b)
	cont = true
	while cont
		cont = false
		instructions = checkexplode(newpair)
		if instructions != noaction
			cont = true
			continue
		end
		instructions = checksplit(newpair)
		instructions == noaction || (cont = true)
	end
	return newpair
end

function addleftmost(pair::Pair, val::Int)
	if pair.x isa Int
		pair.x += val
	else
		addleftmost(pair.x, val)
	end
end

function addrightmost(pair::Pair, val::Int)
	if pair.y isa Int
		pair.y += val
	else
		addrightmost(pair.y, val)
	end
end

function explode(val::Union{Pair, Int})
	if val isa Int
		return noaction
	else
		return val.x, val.y
	end
end

function checkexplode(pair::Pair, depth=1)
	if depth == 4
		instructions = explode(pair.x)
		if instructions != noaction
			if pair.y isa Int
				pair.y += instructions[2]
			else
				addleftmost(pair.y, instructions[2])
			end
			pair.x = 0
			return (explodeleft, instructions[1])
		end
		instructions = explode(pair.y)
		if instructions != noaction
			if pair.x isa Int
				pair.x += instructions[1]
			else
				addrightmost(pair.x, instructions[1])
			end
			pair.y = 0
			return (exploderight, instructions[2])
		end
	end

	if pair.x isa Pair
		instructions = checkexplode(pair.x, depth + 1)
		instructions == ret && (return ret)
		if instructions != noaction
			instructions[1] == explodeleft && return instructions
			if pair.y isa Int
				pair.y += instructions[2]
			else
				addleftmost(pair.y, instructions[2])
				return ret
			end
		end
	end

	if pair.y isa Pair
		instructions = checkexplode(pair.y, depth + 1)
		instructions == ret && (return ret)
		if instructions != noaction
			instructions[1] == exploderight && return instructions
			if pair.x isa Int
				pair.x += instructions[2]
			else
				addrightmost(pair.x, instructions[2])
				return ret
			end
		end
	end
	return noaction
end


function checksplit(pair::Pair)
	if pair.x isa Int
		if pair.x >= 10
			val = pair.x/2
			pair.x = Pair(Int(floor(val)), Int(ceil(val)))
			return ret
		end
	else
		instructions = checksplit(pair.x)
		instructions == ret && (return ret)
	end
	if pair.y isa Int
		if pair.y >= 10
			val = pair.y/2
			pair.y = Pair(Int(floor(val)), Int(ceil(val)))
			return ret
		end
	else
		instructions = checksplit(pair.y)
		instructions == ret && (return ret)
	end
	return noaction
end

const data = readlines("input.txt")
allpairs = Pair.(data)

function addpairs(allpairs)
	pair = allpairs[1]
	for p in allpairs[2:end]
		pair = pair + p
	end
	return pair
end

magnitude(val::Int) = val
magnitude(val::Pair) = 3*magnitude(val.x) + 2*magnitude(val.y)


final = addpairs(allpairs)
println(magnitude(final))

magnitudes = []
for i in 1:length(allpairs), j in 1:length(allpairs)
	pairs = Pair.(data)
	a = pairs[i]
	b = pairs[j]
	a == b && continue
	mag = magnitude(a + b)
	push!(magnitudes, mag)
end
println(maximum(magnitudes))