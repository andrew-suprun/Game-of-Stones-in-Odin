package score

Score :: distinct f32

win :: Score(0h7f800000)
loss :: Score(0hff800000)
draw :: Score(0h80000000)
no_score :: Score(0h7fc00000)

is_win :: proc(score: Score) -> bool {
	return score == win
}

is_loss :: proc(score: Score) -> bool {
	return score == loss
}

is_draw :: proc(score: Score) -> bool {
	return score == 0 && transmute(i32)score < 0
}

is_decisive :: proc(score: Score) -> bool {
	return is_win(score) || is_loss(score) || is_draw(score)
}

is_set :: proc(score: Score) -> bool {
	return score == score
}

import "core:testing"

@(test)
scores :: proc(t: ^testing.T) {
	testing.expect(t, is_draw(draw))
	testing.expect(t, !is_draw(0))
	testing.expect(t, is_set(draw))
	testing.expect(t, !is_set(no_score))
	testing.expect(t, !is_set(win + loss))
}
