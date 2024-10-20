extends Camera2D

@export var zoom_step_size : float = 0.1
@export var zoom_blend_time : float = 0.2
@export var max_zoom : float
@export var min_zoom : float
@export var camera_area : Vector2

var target_zoom : Vector2 = Vector2.ONE
var target_position : Vector2 = Vector2.ZERO
var _dragging_focus : bool = false

func _update_camera_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", target_zoom, zoom_blend_time)

func _clamp_target_position():
	var _camera_area : Vector2 = camera_area * zoom
	target_position.y = clamp(target_position.y, -_camera_area.y/2, _camera_area.y/2)
	target_position.x = clamp(target_position.x, -_camera_area.x/2, _camera_area.x/2)

func _unhandled_input(event):
	if event.is_action_pressed(&"zoom_in"):
		target_zoom += Vector2(zoom_step_size, zoom_step_size)
		var _max_zoom_vector = Vector2(max_zoom, max_zoom)
		target_zoom = _max_zoom_vector.min(target_zoom)
		_update_camera_zoom()
	elif event.is_action_pressed(&"zoom_out"):
		target_zoom -= Vector2(zoom_step_size, zoom_step_size)
		var _min_zoom_vector = Vector2(min_zoom, min_zoom)
		target_zoom = _min_zoom_vector.max(target_zoom)
		_update_camera_zoom()
	if event.is_action_pressed(&"set_focus"):
		if $SetFocusTimer.is_stopped():
			$SetFocusTimer.start()
		else:
			if event.has_method(&"get_position"):
				var _viewport_half_size = get_viewport_rect().size / 2
				target_position = global_position - (_viewport_half_size - event.position)
				_clamp_target_position()
				var tween = create_tween()
				tween.tween_property(self, "position", target_position, 0.1)
			target_zoom = Vector2.ONE
			_update_camera_zoom()
	if event.is_action_pressed(&"grab_focus"):
		_dragging_focus = true
	elif event.is_action_released(&"grab_focus"):
		_dragging_focus = false
	if _dragging_focus and event is InputEventMouseMotion:
		var drag_motion = -(event.relative / zoom)
		target_position += drag_motion
		_clamp_target_position()
		position = target_position

func shake():
	var _shake_level = Config.get_config(AppSettings.VIDEO_SECTION, "CameraShake", 1.0)
	$ShakerComponent2D.intensity = _shake_level
	$ShakerComponent2D.play_shake()
