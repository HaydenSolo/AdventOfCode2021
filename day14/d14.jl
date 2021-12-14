const data = readlines("input.txt")

# struct Rule
# 	from::String
# 	to::String
# end
# Rule(str::String) = Rule(string(str[1:2]), string(str[7]))

function getrules(rules)
	ruledict = Dict{String, Char}()
	for rule in rules
		ruledict[string(rule[1:2])] = rule[7]
	end
	return ruledict
end

function step(polymer, rules)
	newpolymer::Vector{Char} = []
	for (first, second) in zip(polymer[1:end-1], polymer[2:end])
		key = first*second
		# newpolymer *= first
		push!(newpolymer, first)
		# haskey(rules, key) && (newpolymer *= rules[key])
		haskey(rules, key) && push!(newpolymer, rules[key])
	end
	# newpolymer *= polymer[end]
	push!(newpolymer, polymer[end])
	return String(newpolymer)
end

function runsteps(polymer, rules, steps)
	for i in 1:steps
		polymer = step(polymer, rules)
		println("Done step $i with length $(length(polymer))")
	end
	return polymer
end

count(polymer::String, char::Char) = Base.count(i -> i==char, polymer)

# function match(rules::Vector{Rule}, str)

polymer = data[1]
rules = getrules(data[3:end])


polymer = runsteps(polymer, rules, 40)
counts = Vector{Int}()
for char in Set(polymer)
	push!(counts, count(polymer, char))
end
println(maximum(counts) - minimum(counts))