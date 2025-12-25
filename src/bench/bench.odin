package bench

import "core:fmt"
import "core:time"

bench1 :: proc($g: proc(_: int) -> int) {
	sw := time.Stopwatch{}
	time.stopwatch_start(&sw)
	count := 0
	for i in 0 ..< 100_000_000 {
		count += g(i)
	}
	time.stopwatch_stop(&sw)
	fmt.println("bench1: count:", count, "time:", time.stopwatch_duration(sw))

}

bench2 :: proc(g: proc(_: int) -> int) {
	sw := time.Stopwatch{}
	time.stopwatch_start(&sw)
	count := 0
	for i in 0 ..< 100_000_000 {
		count += g(i)
	}
	time.stopwatch_stop(&sw)
	fmt.println("bench2: count:", count, "time:", time.stopwatch_duration(sw))

}

fib :: #force_no_inline proc(i: int) -> int {
	if i < 2 do return i
	return fib(i - 1) + fib(i - 2)
}

bench_assert :: proc() {
	sw := time.Stopwatch{}
	time.stopwatch_start(&sw)
	assert(fib(42) > 10_000_000)
	time.stopwatch_stop(&sw)
	fmt.println("bench_assert: time:", time.stopwatch_duration(sw))
}

import "core:log"

bench_logger :: proc() {
	sw := time.Stopwatch{}
	time.stopwatch_start(&sw)
	if context.logger.procedure != nil {
		log.debug(fib(42) > 10_000_000)
	}
	time.stopwatch_stop(&sw)
	fmt.println("bench_logger: time:", time.stopwatch_duration(sw))
}

@(disabled = ODIN_DISABLE_ASSERT)
debug :: proc(b: bool) {
	fmt.println("--debug--")
}


bench_disabled :: proc() {
	sw := time.Stopwatch{}
	time.stopwatch_start(&sw)
	debug(fib(42) > 10_000_000)
	time.stopwatch_stop(&sw)
	fmt.println("bench_disabled: time:", time.stopwatch_duration(sw))
}
