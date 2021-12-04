const data = split.(readlines("input.txt"))
const list = [(dat[1], parse(Int, dat[2])) for dat in data]

function locate(list)
	horizontal = 0
	vertical = 0
	aim = 0
	for command in list
		num = command[2]
		text = command[1]
		if text == "forward"
			horizontal += num
			vertical += aim*num
		elseif text == "down"
			aim += num
		elseif text == "up"
			aim -= num
		end
	end
	return horizontal*vertical
end

x = locate(list)
print(x)