const data = map(i -> parse(Int, i), split.(readlines("input.txt"), ",")[1])

allfish = Dict([(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0)])

for i in data
	allfish[i] += 1
end

println(allfish)

function step(allfish)
	newfish = Dict([(0, 0), (1, 0), (2, 0), (3, 0), (4, 0), (5, 0), (6, 0), (7, 0), (8, 0)])
	for k in 1:8
		newfish[k-1] = allfish[k]
	end
	newfish[6] += allfish[0]
	newfish[8] = allfish[0]
	return newfish
end

function dofish(allfish)
	for i in 1:256
		allfish = step(allfish)
		println("Done day $i")
	end
	total = 0
	for i in 0:8
		total += allfish[i]
	end
	println(total)
end

dofish(allfish)