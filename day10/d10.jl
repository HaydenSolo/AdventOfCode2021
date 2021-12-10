const data = map(c -> only.(c), split.(readlines("input.txt"), ""))

opens = Set(('(', '{', '<', '['))
closes = Set((')', '}', '>', ']'))
corrects = Dict('('=>')', '{'=>'}', '<'=>'>', '['=>']')
valmap = Dict(')'=> 3, ']' => 57, '}' => 1197, '>' => 25137)

function chunk(line)
	stack = []
	for c in line
		if c in opens
			push!(stack, corrects[c])
		else
			target = pop!(stack)
			target == c || (return c)
		end
	end
	return nothing
end

wrongs = filter(c -> c !== nothing, chunk.(data))
points = map(c -> valmap[c], wrongs)
println(points)
println(sum(points))