with open('input.txt', 'r') as data:
	a = [int(d) for d in data.readlines()]
	sums = [i + j + k for i, j, k in zip(a[:-2], a[1:-1], a[2:])]
	together = [(b, c) for b, c in zip(sums[:-1], sums[1:])]
	larger = [x for x in together if x[1] > x[0]]
	print(len(together))
	print(len(larger))