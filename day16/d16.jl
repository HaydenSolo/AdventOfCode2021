decodemap = Dict('0' => "0000",
'1' => "0001",
'2' => "0010",
'3' => "0011",
'4' => "0100",
'5' => "0101",
'6' => "0110",
'7' => "0111",
'8' => "1000",
'9' => "1001",
'A' => "1010",
'B' => "1011",
'C' => "1100",
'D' => "1101",
'E' => "1110",
'F' => "1111")

getdict(c) = decodemap(c)
binparse(x) = parse(Int, x; base=2)
line = readlines("input.txt")[1]

function decode(map, line)
	res = ""
	for c in line
		res *= map[c]
	end
	res
end

decoded = decode(decodemap, line)

function literal(decoded, ind)
	checking = true
	toparse = ""
	while checking
		checking = (decoded[ind] == '1')
		ind += 1
		toparse *= decoded[ind:ind+3]
		ind += 4
	end
	value = binparse(toparse)
	return ind, value
end

function bits(decoded, ind)
	numbits = binparse(decoded[ind:ind+14])
	ind += 15
	versum = 0
	currentind = ind
	children = Int[]
	while ind - currentind < numbits
		ind, child = packet(decoded, ind)
		push!(children, child)
	end
	return ind, children
end

function subpackets(decoded, ind)
	numbits = binparse(decoded[ind:ind+10])
	ind += 11
	children = Int[]
	for _ in 1:numbits
		ind, child = packet(decoded, ind)
		push!(children, child)
	end
	return ind, children
end

function operator(decoded, ind, type)
	id = decoded[ind]
	ind += 1
	if id == '0'
		ind, children = bits(decoded, ind)
	else
		ind, children = subpackets(decoded, ind)
	end

	if type == 0
		return ind, sum(children)
	elseif type == 1
		return ind, reduce(*, children)
	elseif type == 2
		return ind, minimum(children)
	elseif type == 3
		return ind, maximum(children)
	elseif type == 5 # >
		return ind, (children[1] > children[2] ? 1 : 0)
	elseif type == 6 # <
		return ind, (children[1] < children[2] ? 1 : 0)
	elseif type == 7 # ==
		return ind, (children[1] == children[2] ? 1 : 0)
	end
	return ind, 0
end


function packet(decoded, ind)
	version = binparse(decoded[ind:ind+2])
	ind += 3
	type = binparse(decoded[ind:ind+2])
	ind += 3
	if type == 4
		ind, value = literal(decoded, ind)
	else
		ind, value = operator(decoded, ind, type)
	end
	return ind, value
end


function packets(decoded)
	ind = 1
	ind, value = packet(decoded, ind)
	return value
end

println(packets(decoded))

