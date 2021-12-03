data = readlines("input.txt")

best(a, b) = a > b ? '0' : '1'
worst(a, b) = a <= b ? '0' : '1'

function gettargets(data)
	siz = length(data[1])
	zerocounts = zeros(siz)
	onecounts = zeros(siz)
	for binary in data, (i, b) in enumerate(binary)
		b == '0' && (zerocounts[i] += 1)
		b == '1' && (onecounts[i] += 1)
	end
	bests = best.(zerocounts, onecounts)
	worsts = worst.(zerocounts, onecounts)

	return join(bests), join(worsts)
end

bests, worsts = gettargets(data)

conv(x) = parse(Int, x, base=2)

answer = conv(bests)*conv(worsts)
println(answer)

test(list, target, index) = filter(w -> w[index] == target[index], list)

function runthrough(list, high)
	i = 1
	while size(list)[1] > 1
		hightarget, lowtarget = gettargets(list)
		target = high ? hightarget : lowtarget
		list = filter(w -> w[i] == target[i], list)
		i += 1
	end
	return list[1]
end

o2 = runthrough(data, true)
co2 = runthrough(data, false)

answer2 = conv(o2)*conv(co2)
println(answer2)