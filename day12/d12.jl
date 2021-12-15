abstract type Cave end

struct SmallCave <: Cave
	connections::Vector{Cave}
	name::String
end
SmallCave(name::String) = SmallCave([], name)

struct LargeCave <: Cave
	connections::Vector{Cave}
	name::String
end
LargeCave(name::String) = LargeCave([], name)

struct SpecialCave <: Cave
	connections::Vector{Cave}
	name::String
end
SpecialCave(name::String) = SpecialCave([], name)

Cave(name) = (name == "start" || name == "end") ? SpecialCave(name) : name[1] >= 'a' ? SmallCave(name) : LargeCave(name)

connect!(a::Cave, b::Cave) = (push!(a.connections, b) ; push!(b.connections, a))

caves = Dict{String, Cave}()

data = map.(s -> String(s), split.(readlines("input.txt"),"-"))
for (from, to) in data
	fromcave = haskey(caves, from) ? caves[from] : (caves[from] = Cave(from))
	tocave = haskey(caves, to) ? caves[to] : (caves[to] = Cave(to))
	connect!(fromcave, tocave)
end

function visithelper!(path::Vector{Cave}, cave::Cave, doublesmall::Bool)
	res = []
	for c in cave.connections
		next = visit(path, c, doublesmall)
		if next isa Bool
			continue
		elseif next isa Vector{Cave} 
			push!(res, next)
		else
			for p in next
				push!(res, p)
			end
		end
	end
	return res
end

function visit(path::Vector{Cave}, cave::SpecialCave, doublesmall::Bool)
	cave in path && (return false)
	path = copy(path)
	push!(path, cave)
	cave.name == "end" && (return path)
	res = []
	return visithelper!(path, cave, doublesmall)
end

function visit(path::Vector{Cave}, cave::SmallCave, doublesmall::Bool)
	doublesmall && cave in path && (return false)
	cave in path && (doublesmall = true)
	path = copy(path)
	push!(path, cave)
	return visithelper!(path, cave, doublesmall)
end

function visit(path::Vector{Cave}, cave::LargeCave, doublesmall::Bool)
	path = copy(path)
	push!(path, cave)
	return visithelper!(path, cave, doublesmall)
end


function getpaths(caves::Dict{String, Cave})
	start = caves["start"]
	path = Vector{Cave}()
	println(length(visit(path, start, false)))
end

getpaths(caves)
println(methods(visit))
