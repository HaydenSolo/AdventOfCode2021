a = parse.(Int, readlines("input.txt"))

add(x,y,z) = x + y + z
tup(x,y) = (x,y)

sums = add.(a[1:end-2], a[2:end-1], a[3:end])
together = tup.(sums[1:end-1], sums[2:end])
larger = [x for x in together if x[2] > x[1]]

println(size(larger))