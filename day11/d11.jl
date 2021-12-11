import Base.+

struct Energy
	val::Int
end
Energy(s::Char) = Energy(parse(Int, s))
(+)(x::Energy, y::Int) = x.val + y
inc(a::Energy) = Energy(a.val == 0 ? 0 : a+1)

lines = map(collect, readlines("input.txt"))
energy = Energy.(permutedims(hcat(lines...)))


const imax, jmax = size(energy)

function neighbours(i, j) 
	out = []
	if i > 1
		push!(out, (i-1, j))
		if j > 1
			push!(out, (i-1, j-1))
		end
		if j < jmax
			push!(out, (i-1, j+1))
		end
	end
	if i < imax
		push!(out, (i+1, j))
		if j > 1
			push!(out, (i+1, j-1))
		end
		if j < jmax
			push!(out, (i+1, j+1))
		end
	end
	if j > 1
		push!(out, (i, j-1))
	end
	if j < jmax
		push!(out, (i, j+1))
	end
	return out
end


function step(energy)
	for i in 1:imax, j in 1:jmax
		energy[i, j] = Energy(energy[i, j]+1)
	end
	changed = true
	flashes = 0
	while changed
		changed = false
		for i in 1:imax, j in 1:jmax
			current = energy[i, j]
			current.val <= 9 && continue
			energy[i, j] = Energy(0)
			changed = true
			flashes += 1
			n = neighbours(i, j)
			for neigh in n
				ni, nj = neigh
				energy[ni, nj] = inc(energy[ni, nj])
			end
		end
	end
	return flashes
end

function run(energy, steps)
	flashes = 0
	for i in 1:steps
		newflashes = step(energy)
		flashes += newflashes
		if length(energy) == newflashes
			println("Sync on step $i")
			return flashes
		end
	end
	return flashes
end

flashes = run(energy, 1000)
println(flashes)
