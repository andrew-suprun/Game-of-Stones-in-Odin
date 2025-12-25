package main

import "core:fmt"

Game :: struct($Move: typeid) {
    moves: proc() -> [dynamic]Move,
}

search :: proc(game: Game(int)) {
    moves := game.moves()
    fmt.println("moves: ", moves)
    delete(moves)
}
