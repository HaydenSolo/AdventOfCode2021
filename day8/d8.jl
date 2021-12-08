const data = split.(readlines("input.txt"), " | ")

struct Solution
    count::Array{Union{Missing, String}}
end
Solution() = Solution(Array{Union{Missing, String, Vector{String}}}(missing, 10))
Base.getindex(X::Solution, i::Int64) = X.count[i+1]
Base.setindex!(X::Solution, v, i::Int) = (X.count[i+1] = v)
Base.firstindex(X::Solution) = 0
Base.lastindex(X::Solution) = 9
Base.iterate(iter::Solution, state=0) = state > 9 ? nothing : ((state, iter[state]), state+1)
Base.length(iter::Solution) = 10	
function getdefined(solution::Solution)
	defined = Dict{Int, String}()
	for (i, v) in solution
		v === missing || (defined[i] = v)
	end
	return defined
end
Base.show(io::IO, solution::Solution) = print(io, getdefined(solution))
function reverse(solution::Solution)
	rev = Vector{Pair{Set{Char}, Int}}()
	for (k, v) in collect(getdefined(solution))
		push!(rev, Pair(Set(v), k))
	end
	return rev
end

function containedin(original, news)
	for f in news
		correct = true
		for n in original
			correct &= n in f
		end
		if correct
			news = filter(i -> i != f, news)
			return f, news
		end
	end
end

function getmapping(uniques)
	solution = Solution()
	for u in uniques
		length(u) == 2 && (solution[1] = u)
		length(u) == 3 && (solution[7] = u)
		length(u) == 4 && (solution[4] = u)
		length(u) == 7 && (solution[8] = u)
	end
	
	fives = filter(i -> length(i) == 5, uniques)
	sixes = filter(i -> length(i) == 6, uniques) 

	one = solution[1]
	four = solution[4]
	
	solution[3], fives = containedin(one, fives)

	# Finds 5
	for f in fives
		total = 0
		for n in four
			n in f && (total += 1)
		end
		if total == 3
			solution[5] = f
			fives = filter(i -> i != f, fives)
			break
		end
	end

	solution[2] = fives[1]
	solution[9], sixes = containedin(four, sixes)
	solution[0], sixes = containedin(one, sixes)
	solution[6] = sixes[1]

	return reverse(solution)
end


function deduce(line)
	uniques = String.(split(line[1]))
	mapping = getmapping(uniques)

	rhs = split(line[2])
	deductions = Vector{Int}()
	for n in rhs
		for m in mapping
			key, value = m[1], m[2]
			correct = length(key) == length(n)
			for c in n
				correct &= c in key
			end
			if correct
				push!(deductions, value)
				break
			end
		end
	end
	return deductions[1]*1000+deductions[2]*100+deductions[3]*10+deductions[4]
end

deductions = deduce.(data)
println(sum(deductions))