extends VBoxContainer

@export var result_row_scene : PackedScene
@onready var results_container = %ResultsContainer

func clear():
	for child in results_container.get_children():
		child.queue_free()

func add_test(input : int, expected_output : int, bit_range : int = 2):
	var result_instance = result_row_scene.instantiate()
	results_container.add_child(result_instance)
	result_instance.bit_range = bit_range
	await get_tree().create_timer(0.1, true).timeout
	result_instance.input = input
	await get_tree().create_timer(0.1, true).timeout
	result_instance.expected_output = expected_output

func add_output(input : int, output : int):
	if results_container.get_child_count() == 0: return
	var result_instance = results_container.get_child(input)
	if result_instance.input != input:
		push_warning("got wrong result_instance for input %d" % input)
	result_instance.output = output
