using Statistics

const data = map(c -> only.(c), split.(readlines("input.txt"), ""))

opens = Set(('(', '{', '<', '['))
closes = Set((')', '}', '>', ']'))
corrects = Dict('('=>')', '{'=>'}', '<'=>'>', '['=>']')
valmap = Dict(')'=> 1, ']' => 2, '}' => 3, '>' => 4)

function chunk(line)
	stack = []
	for c in line
		if c in opens
			push!(stack, corrects[c])
		else
			target = pop!(stack)
			target == c || (return nothing)
		end
	end
	needed = reverse(stack)
	total = 0
	for c in needed
		total *= 5
		total += valmap[c]
	end
	return total
end

wrongs = filter(c -> c !== nothing, chunk.(data))
println.(wrongs)
println()
println(Int(median(wrongs)))