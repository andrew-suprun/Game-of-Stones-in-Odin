package board

import "../score"


Scores :: #simd[2]score.Score

Board :: struct($Move: typeid, $SIZE: int, $WIN_STONES: int) {
	_value_table: [2][WIN_STONES * WIN_STONES + 1]Scores,
}


init :: proc(board: ^Board($Move, $SIZE, $WIN_STONES), scores: [WIN_STONES]score.Score) {
	s: [WIN_STONES + 1]score.Score
	for score, i in scores {
		s[i] = scores[i]
	}
	s[WIN_STONES] = score.win

	v2: [WIN_STONES][2]score.Score
	v2[0] = {1, -1}
	for i in 0 ..< WIN_STONES - 1 {
		v2[i + 1] = {s[i + 2] - s[i + 1], -s[i + 1]}
	}

	for i in 0 ..< WIN_STONES - 1 {
		board._value_table[0][i * WIN_STONES] = {v2[i][1], -v2[i][0]}
		board._value_table[0][i] = {v2[i + 1][0] - v2[i][0], v2[i][1] - v2[i + 1][1]}
		board._value_table[1][i] = {-v2[i][0], v2[i][1]}
		board._value_table[1][i * WIN_STONES] = {v2[i][1] - v2[i + 1][1], v2[i + 1][0] - v2[i][0]}
	}
}

import "core:fmt"

main :: proc() {
	board: Board(int, 19, 6)
	init(&board, [6]score.Score{0, 1, 5, 25, 125, 625})

	for i in 0 ..< 2 {
		fmt.println("---")
		for y in 0 ..< 6 {
			for x in 0 ..< 6 {
				fmt.print(board._value_table[i][y * 6 + x], "   ")
			}
			fmt.println()
		}
	}
}
