extends Camera2D

@export var zoom_step_size : float = 0.1
@export var zoom_blend_time : float = 0.2
@export var max_zoom : float
@export var min_zoom : float

var target_zoom : Vector2 = Vector2.ONE

func _update_camera_zoom():
	var tween = create_tween()
	tween.tween_property(self, "zoom", target_zoom, zoom_blend_time)

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
		
