const data = map(i -> parse(Int, i), split.(readlines("input.txt"), ",")[1])

struct Fish
	state::Integer
end
Fish() = Fish(8)
Fish(fish::Fish) = Fish(fish.state - 1)

allfish = map(dat -> Fish(dat), data)

println(allfish)

function step(allfish)
	newfish = Vector{Fish}()
	for fish in allfish
		if fish.state == 0
			push!(newfish, Fish())
			push!(newfish, Fish(6))
		else
			push!(newfish, Fish(fish))
		end
	end
	return newfish
end

function dofish(allfish)
	for i in 1:256
		allfish = step(allfish)
		println("Done day $i")
	end
	println(length(allfish))
end

dofish(allfish)