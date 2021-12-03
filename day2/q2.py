with open('input.txt', 'r') as data:
	a = [d.split() for d in data.readlines()]
	b = [(x, int(y)) for x, y in a]
horizontal = 0
vertical = 0
aim = 0
for command in b:
	num = command[1]
	string = command[0]
	if string == 'forward':
		horizontal += num
		vertical += aim*num
	elif string == 'down':
		aim += num
	elif string == 'up':
		aim -= num
print(horizontal)
print(vertical)
print(horizontal*vertical)