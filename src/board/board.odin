package board

import "../score"


Scores :: #simd[2]score.Score
Place :: [2]i8

Board :: struct($Move: typeid, $SIZE: int, $WIN_STONES: int) {
	_value_table: [2][WIN_STONES * WIN_STONES + 1]Scores,
	_places:      [SIZE * SIZE]i8,
	_scores:      [SIZE * SIZE]Scores,
	score:        score.Score,
}


init :: proc(board: ^Board($Move, $SIZE, $WIN_STONES), scores: [WIN_STONES]score.Score) {
	init_value_table(board, scores)
	init_scores(board)
	board._places = 0
	board.score = 0

}

@(private)
init_value_table :: proc(
	board: ^Board($Move, $SIZE, $WIN_STONES),
	scores: [WIN_STONES]score.Score,
) {
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

@(private)
init_scores :: proc(board: ^Board($Move, $SIZE, $WIN_STONES)) {
	for y in 0 ..< SIZE {
		v := 1 + min(WIN_STONES - 1, y, SIZE - 1 - y, SIZE - WIN_STONES)
		for x in 0 ..< SIZE {
			h := 1 + min(WIN_STONES - 1, x, SIZE - 1 - x, SIZE - WIN_STONES)
			m := 1 + min(x, y, SIZE - 1 - x, SIZE - 1 - y, SIZE - WIN_STONES)
			t1 := max(
				0,
				min(WIN_STONES, m, SIZE - WIN_STONES + 1 - y + x, SIZE - WIN_STONES + 1 - x + y),
			)
			t2 := max(
				0,
				min(
					WIN_STONES,
					m,
					2 * SIZE - 1 - WIN_STONES + 1 - y - x,
					x + y - WIN_STONES + 1 + 1,
				),
			)
			total := score.Score(v + h + t1 + t2)

			board._scores[y * SIZE + x] = {total, total}
		}
	}
}


import "core:fmt"

main :: proc() {
	board: Board(int, 19, 6) = ---
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

	fmt.println("---")
	for y in 0 ..< 19 {
		for x in 0 ..< 19 {
			fmt.print(board._scores[y * 19 + x], "   ")
		}
		fmt.println()
	}
}
