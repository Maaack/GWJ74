extends VBoxContainer

@export var results_container : PackedScene

func clear():
	for child in get_children():
		child.queue_free()

func add_test(input : int, expected_output : int):
	var container_instance = results_container.instantiate()
	add_child(container_instance)
	await get_tree().create_timer(0.1, true).timeout
	container_instance.input = input
	await get_tree().create_timer(0.1, true).timeout
	container_instance.expected_output = expected_output
