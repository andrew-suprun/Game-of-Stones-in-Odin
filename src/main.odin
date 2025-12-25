// TODO: benchmark adding [2]f32 vs. #simd[2]f32
// TODO: wrap logging in @(disabled=ODIN_DISABLE_ASSERT) proc? Or custom -define:LOGGING=true
package main

import "core:fmt"
import "core:log"

import "bench"

g :: proc(i: int) -> int {
	return i + 1
}


@(rodata)
abc := [4]int{1, 2, 3, 4}

main :: proc() {
	context.logger = log.create_console_logger(opt = {.Short_File_Path, .Line})
	defer log.destroy_console_logger(context.logger)

	log.info(">>>Start")
	defer log.info("<<<Stop")

	{
		fmt.println(abc[1:])
	}

	{
		context.user_index = 42
		{
			context.user_index = 13
			fmt.println("context.1", context.user_index)
		}
		fmt.println("context.2", context.user_index)
	}

	{
		// no defference between `f()` and `$f()`
		bench.bench1(g)
		h := g
		bench.bench2(h)

		// asserts are free with -disable-assert
		bench.bench_assert()

		// logger is not free
		context.logger.procedure = nil
		bench.bench_logger()

		bench.bench_disabled()
	}

	moves :: proc() -> [dynamic]int {
		m := make([dynamic]int, 3)
		m[0] = 1
		m[1] = 2
		m[2] = 3
		fmt.println("moves: ", m)
		return m
	}

	game :: Game(int) {
		moves = moves,
	}

	search(game)


	// ############

	Entity :: struct {
		id:       int,
		position: [2]f32,
	}

	Foo :: struct {
		i: int,
	}

	Player :: struct {
		can_jump:     bool,
		using foo:    Foo,
		using entity: Entity,
	}

	p: Player = ---

	p = {
		id       = 7,
		position = {5, 2},
		can_jump = true,
	}

	fmt.println(p.position) // [5, 2]

	print_position :: proc(e: Entity) {
		fmt.println(e.position) // [5, 2]
	}

	print_position(p)

	// ##############

	q :: proc(nn: int) -> int {
		nn := nn
		return nn
	}

	fmt.println(most_green_color("/Users/andrewsuprun/arc/private/Pictures/2021-09-19.jpg"))


	a1 := [3]int{1, 2, 3}
	a2 := [3]int{5, 6, 7}
	fmt.println(a1 + a2)

}


import rl "vendor:raylib"

most_green_color :: proc(filename: cstring) -> rl.Color {
	img := rl.LoadImage(filename)

	if img.data == nil || img.width == 0 || img.height == 0 {
		return {}
	}

	defer rl.UnloadImage(img)

	most_green_color := rl.GetImageColor(img, 0, 0)

	for x in 0 ..< img.width {
		for y in 0 ..< img.height {
			color := rl.GetImageColor(img, i32(x), i32(y))
			if color.g == 255 do return color
			if color.g > most_green_color.g do most_green_color = color
		}
	}

	return most_green_color
}
