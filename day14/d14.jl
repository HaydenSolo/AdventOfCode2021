const data = readlines("input.txt")

function getrules(rules)
	ruledict = Dict{Tuple{Char, Char}, Char}()
	countdict = Dict{Tuple{Char, Char}, Int}()
	elements = Set{Char}()
	for rule in rules
		key = (rule[1], rule[2])
		ruledict[key] = rule[7]
		countdict[key] = 0
		push!(elements, rule[1])
		push!(elements, rule[2])
	end
	return ruledict, countdict, elements
end

function step(counts, rules)
	newcounts = Dict{Tuple{Char, Char}, Int}(key => 0 for key in keys(counts))
	for key in keys(counts)
		c1, c2 = key
		newchar = rules[key]
		count = counts[key]
		newcounts[(c1, newchar)] += count
		newcounts[(newchar, c2)] += count
	end
	return newcounts
end

function runsteps(counts, rules, steps)
	for i in 1:steps
		counts = step(counts, rules)
	end
	return counts
end

polymer = data[1]
rules, counts, elements = getrules(data[3:end])

for key in zip(polymer[1:end-1], polymer[2:end])
	counts[key] += 1
end

counts = runsteps(counts, rules, 40)

elementcount = Dict(e => 0 for e in elements)
elementcount[polymer[1]] += 1
elementcount[polymer[end]] += 1

for ((c1, c2), v) in counts
	elementcount[c1] += v
	elementcount[c2] += v
end

for k in keys(elementcount)
	elementcount[k] /= 2
end

println(maximum(values(elementcount)) - minimum(values(elementcount)))
