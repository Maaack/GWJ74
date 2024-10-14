extends Control

@export var win_scene : PackedScene
@export var lose_scene : PackedScene

var current_level

func _ready():
	InGameMenuController.scene_tree = get_tree()

func _on_level_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_level_won():
	$LevelLoader.advance_and_load_level()

func _try_connecting_signal_to_node(node : Node, signal_name : String, callable : Callable):
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func _boot_tests():
	%RunButton.button_pressed = false
	%TestsContainer.clear()
	%TestingProgressBar.value = 0
	if current_level is BaseLevel:
		for input in range(current_level.input_range):
			await get_tree().create_timer(0.1).timeout
			var expected_output = current_level.expected_outputs[input]
			%TestsContainer.add_test(input, expected_output, current_level.input_wires.size())
		await get_tree().create_timer(0.5).timeout
		%RunButton.button_pressed = true

func _on_level_check_output(input: int, output: int, progress: float):
	%TestsContainer.add_output(input, output)
	await get_tree().create_timer(0.1).timeout
	var tween = create_tween()
	tween.tween_property(%TestingProgressBar, "value", progress, 0.1)
	await get_tree().create_timer(0.1).timeout
	if progress == 1.0:
		_on_level_won()

func _on_level_loader_level_loaded():
	current_level = $LevelLoader.current_level
	await current_level.ready
	_try_connecting_signal_to_node(current_level, &"level_won", _on_level_won)
	_try_connecting_signal_to_node(current_level, &"output_checked", _on_level_check_output)
	_boot_tests()
	$LoadingScreen.close()

func _on_level_loader_levels_finished():
	InGameMenuController.open_menu(win_scene, get_viewport())

func _on_level_loader_level_load_started():
	$LoadingScreen.reset()

func _on_run_button_toggled(toggled_on):
	if current_level is BaseLevel:
		current_level.toggle_tests(toggled_on)

func _on_speed_slider_value_changed(value):
	if current_level is BaseLevel:
		current_level.update_test_speed(value)
