import Base.+

mutable struct MutInt
	val::Int
end
# add(int::MutInt, )
(+)(a::MutInt, b::Int) = (a.val += b; a)

abstract type Packet end
abstract type Operator <: Packet end

struct Literal <: Packet
	value::Int
end
function Literal(decoded, ind)
	checking = true
	toparse = ""
	while checking
		checking = (decoded[ind.val] == '1')
		ind + 1
		toparse *= decoded[ind.val:ind.val+3]
		ind + 4
	end
	return Literal(binparse(toparse))
end

struct AddOp <: Operator
	children::Vector{Packet}
end
struct MultOp <: Operator
	children::Vector{Packet}
end
struct MinOp <: Operator
	children::Vector{Packet}
end
struct MaxOp <: Operator
	children::Vector{Packet}
end
struct GreatOp <: Operator
	children::Vector{Packet}
end
struct LessOp <: Operator
	children::Vector{Packet}
end
struct EqOp <: Operator
	children::Vector{Packet}
end

function Operator(decoded, ind::MutInt, type)
	id = decoded[ind.val]
	ind + 1
	if id == '0'
		children = bits(decoded, ind)
	else
		children = subpackets(decoded, ind)
	end
	typemap = Dict(0 => AddOp, 1 => MultOp, 2 => MinOp, 3 => MaxOp, 5 => GreatOp, 6 => LessOp, 7 => EqOp)
	return typemap[type](children)
end


function bits(decoded, ind)
	numbits = binparse(decoded[ind.val:ind.val+14])
	ind + 15
	currentind = ind.val
	children = Packet[]
	while ind.val - currentind < numbits
		child = Packet(decoded, ind)
		push!(children, child)
	end
	return children
end

function subpackets(decoded, ind)
	numbits = binparse(decoded[ind.val:ind.val+10])
	ind + 11
	children = Packet[]
	for _ in 1:numbits
		child = Packet(decoded, ind)
		push!(children, child)
	end
	return children
end

function Packet(decoded, ind::MutInt)
	version = binparse(decoded[ind.val:ind.val+2])
	ind + 3
	type = binparse(decoded[ind.val:ind.val+2])
	ind + 3
	if type == 4
		return Literal(decoded, ind)
	else
		return Operator(decoded, ind, type)
	end
end


function packets(decoded)
	ind = MutInt(1)
	structure = Packet(decoded, ind)
	return structure
end

evaluate(a::Literal) = a.value
evaluate(a::AddOp) = sum(evaluate.(a.children))
evaluate(a::MultOp) = reduce(*, evaluate.(a.children))
evaluate(a::MinOp) = minimum(evaluate.(a.children))
evaluate(a::MaxOp) = maximum(evaluate.(a.children))
evaluate(a::GreatOp) = (c = evaluate.(a.children); c[1] > c[2] ? 1 : 0)
evaluate(a::LessOp) = (c = evaluate.(a.children); c[1] < c[2] ? 1 : 0)
evaluate(a::EqOp) = (c = evaluate.(a.children); c[1] == c[2] ? 1 : 0)

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
structure = packets(decoded)
println(evaluate(structure))