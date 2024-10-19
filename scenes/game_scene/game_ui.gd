extends Control

@export var win_scene : PackedScene
@export var win_level_scene : PackedScene
@export var lose_scene : PackedScene

var current_level

var _muted : bool = false

func _ready():
	InGameMenuController.scene_tree = get_tree()

func _on_level_lost():
	InGameMenuController.open_menu(lose_scene, get_viewport())

func _on_level_skipped():
	$LevelLoader.advance_and_load_level()

func _on_level_won():
	if $LevelLoader.is_on_last_level():
		InGameMenuController.open_menu(win_scene, get_viewport())
	else:
		InGameMenuController.open_menu(win_level_scene, get_viewport())
		InGameMenuController.current_menu.continue_pressed.connect(_on_level_skipped)
		InGameMenuController.current_menu.restart_pressed.connect(func():$LevelLoader.load_level())

func _try_connecting_signal_to_node(node : Node, signal_name : String, callable : Callable):
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func _boot_tests():
	%RunButton.button_pressed = false
	%TestsContainer.clear()
	%TestingProgressBar.value = 0
	%SidePanelUI.hide()
	if current_level is BaseLevel:
		%SidePanelUI.show()
		for input in range(current_level.input_range):
			await get_tree().create_timer(0.1).timeout
			var expected_output = current_level.expected_outputs[input]
			%TestsContainer.add_test(input, expected_output, current_level.get_input_bit_range(), current_level.get_output_bit_range())
		await get_tree().create_timer(0.5).timeout
		%RunButton.button_pressed = true
		current_level.update_test_speed(%SpeedSlider.value)

func _on_level_check_output(input: int, output: int):
	%TestsContainer.add_output(input, output)

func _play_lost_progress_effect():
	if _muted: return
	if $LostProgressTimer.is_stopped():
		$LostProgressTimer.start()
		$LostProgressStreamPlayer.play()

func _play_gained_progress_effect():
	if _muted: return
	if $GainedProgressTimer.is_stopped():
		$GainedProgressTimer.start()
		$GainedProgressStreamPlayer.play()

func _on_level_progress_updated(progress: float):
	var tween = create_tween()
	tween.tween_property(%TestingProgressBar, "value", progress, 0.1)
	await get_tree().create_timer(0.1).timeout
	if progress == 0:
		_play_lost_progress_effect()
	else:
		_play_gained_progress_effect()
	if progress == 1.0:
		_on_level_won()

func _on_level_loader_level_loaded():
	current_level = $LevelLoader.current_level
	await current_level.ready
	_try_connecting_signal_to_node(current_level, &"level_won", _on_level_won)
	_try_connecting_signal_to_node(current_level, &"level_skipped", _on_level_skipped)
	_try_connecting_signal_to_node(current_level, &"output_checked", _on_level_check_output)
	_try_connecting_signal_to_node(current_level, &"progress_updated", _on_level_progress_updated)
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

func _on_mute_button_toggled(toggled_on):
	_muted = toggled_on
