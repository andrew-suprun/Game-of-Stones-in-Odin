package heap

Heap :: struct($E: typeid, $N: int) {
	items: [N]E,
	len:   int,
}

add :: proc(heap: ^Heap($E, $N), item: E, less: proc(_: int, _: int) -> bool) {
	if heap.len == N {
		if !less(heap.items[0], item) {
			return
		}
		idx := 0
		for true {
			first := idx
			left_child_idx := idx * 2 + 1
			if left_child_idx < heap.len && less(heap.items[left_child_idx], item) {
				first = left_child_idx
			}
			right_child_idx := idx * 2 + 2
			if right_child_idx < heap.len &&
			   less(heap.items[right_child_idx], item) &&
			   less(heap.items[right_child_idx], heap.items[left_child_idx]) {
				first = right_child_idx
			}
			if idx == first {
				break
			}
			heap.items[idx] = heap.items[first]
			idx = first
		}

		heap.items[idx] = item
		return
	}
	heap.items[heap.len] = item
	child_idx := heap.len
	child := heap.items[child_idx]
	for child_idx > 0 && less(child, heap.items[(child_idx - 1) / 2]) {
		parent_idx := (child_idx - 1) / 2
		heap.items[child_idx] = heap.items[parent_idx]
		child_idx = parent_idx
	}
	heap.items[child_idx] = child
	heap.len += 1
}

clear :: proc(heap: ^Heap($E, $N)) {
	heap.len = 0
}

import "core:math/rand"
import "core:testing"

@(test)
heap_test :: proc(t: ^testing.T) {
	values := make([]int, 100)
	defer delete(values)
	for i in 0 ..< 100 {
		values[i] = i + 1
	}
	rand.shuffle(values)

	heap := Heap(int, 20){}

	for i in 0 ..< 100 {
		add(&heap, values[i], less)
	}

	for i in 1 ..< 20 {
		parent := heap.items[(i - 1) / 2]
		child := heap.items[i]
		testing.expect(t, parent < child)
	}
}


less :: proc(i, j: int) -> bool {
	return i < j
}

import "core:fmt"
import "core:time"

main :: proc() {
	heap := Heap(int, 20){}

	for _ in 0 ..< 5 {
		sw := time.Stopwatch{}
		time.stopwatch_start(&sw)
		for _ in 0 ..< 1_000_000 {
			clear(&heap)
			for i in 0 ..< 100 {
				add(&heap, i * 17 % 100, less)
			}
		}
		time.stopwatch_stop(&sw)
		fmt.println("heap bench: time:", time.stopwatch_duration(sw))
	}
}
