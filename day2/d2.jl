data = split.(readlines("input.txt"))
list = [(dat[1], parse(Int, dat[2])) for dat in data]
horizontal = 0
vertical = 0
aim = 0
for command in list
	num = command[2]
	text = command[1]
	if text == "forward"
		global horizontal += num
		global vertical += aim*num
	elseif text == "down"
		global aim += num
	elseif text == "up"
		global aim -= num
	end
end
println(horizontal)
println(vertical)
print(horizontal*vertical)
