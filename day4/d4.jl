data = readlines("input.txt")
const nums = parse.(Int, split(popfirst!(data), ','))
data = filter(n -> n != "", data)

data = map(line -> parse.(Int, line), split.(data))

masknums(board, num) = map(line -> map(digit -> digit == num ? -1 : digit, line), board)

function checkwin(board)
	for i in 1:5
		verticalwin = true
		horizontalwin = true
		for j in 1:5
			board[i][j] == -1 || (verticalwin = false)
			board[j][i] == -1 || (horizontalwin = false)
		end
		(verticalwin || horizontalwin) && (return true)
	end
	return false
end

function sumboard(board)
	ret = 0
	for row in board, num in row
		ret += num == -1 ? 0 : num
	end
	return ret
end

function reportwin(board, num)
	println(board)
	println(sumboard(board))
	println(num)
	println(sumboard(board)*num)
end

function run1(data, nums)
	boards = []
	num_boards = length(data)/5
	for board in 1:5:length(data)
		push!(boards, data[board:board+4])
	end
	for num in nums
		maskedboards = []
		for board in boards
			newboard = masknums(board, num)
			push!(maskedboards, newboard)
			if checkwin(newboard)
				reportwin(newboard, num)
				return
			end
		end
		boards = maskedboards
	end
end

run1(data, nums)

function run2(data, nums)
	boards = []
	num_boards = length(data)/5
	for board in 1:5:length(data)
		push!(boards, data[board:board+4])
	end
	for num in nums
		maskedboards = []
		for board in boards
			newboard = masknums(board, num)
			if !checkwin(newboard) || length(boards) == 1
				push!(maskedboards, newboard)
			end
		end
		if length(maskedboards) == 1 && checkwin(maskedboards[1])
			reportwin(maskedboards[1], num)
			return
		end
		boards = maskedboards
	end
end

run2(data, nums)