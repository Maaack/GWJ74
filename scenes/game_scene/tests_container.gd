extends VBoxContainer

@export var results_container : PackedScene

func clear():
	for child in get_children():
		child.queue_free()

func add_test(input : int, expected_output : int, bit_range : int = 2):
	var container_instance = results_container.instantiate()
	add_child(container_instance)
	container_instance.bit_range = bit_range
	await get_tree().create_timer(0.1, true).timeout
	container_instance.input = input
	await get_tree().create_timer(0.1, true).timeout
	container_instance.expected_output = expected_output

func add_output(input : int, output : int):
	if get_child_count() == 0: return
	var container_instance = get_child(input)
	if container_instance.input != input:
		push_warning("got wrong container_instance for input %d" % input)
	container_instance.output = output
