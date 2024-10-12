class_name LogicGate2D
extends Node2D

signal gate_held
signal gate_dropped

var hovering : bool = false
var selected : bool = false
var holding : bool = false

@onready var holding_timer := $HoldingTimer

var _nearby_sockets : Array[Socket2D]
var _colliding_gates : Array[LogicGate2D]
var _snap_to_relative : Vector2
var _last_clear_global_position : Vector2

func _on_area_2d_mouse_entered():
	hovering = true

func _on_area_2d_mouse_exited():
	hovering = false

func _get_nearest_socket() -> Socket2D:
	if _nearby_sockets.is_empty() : return
	var nearest_socket : Socket2D
	var nearest_range := INF
	for socket in _nearby_sockets:
		var distance = global_position.distance_to(socket.global_position)
		if distance < nearest_range:
			nearest_range = distance
			nearest_socket = socket
	return nearest_socket

func _update_position():
	global_position = get_global_mouse_position()
	var nearest_socket := _get_nearest_socket()
	if nearest_socket is Socket2D:
		_snap_to_relative = nearest_socket.global_position - global_position
	else:
		_snap_to_relative = Vector2.ZERO
	if _colliding_gates.size() == 0:
		_last_clear_global_position = global_position
	else:
		_snap_to_relative = _last_clear_global_position - global_position
	$ShadowSprite2D.position = _snap_to_relative

func _drop():
	if not holding_timer.is_stopped(): 
		holding_timer.stop()
	if holding: 
		holding = false
	selected = false
	if not _snap_to_relative.is_zero_approx():
		position += _snap_to_relative
		$ShadowSprite2D.position = Vector2.ZERO
	gate_dropped.emit()

func _unhandled_input(event):
	if event.is_action_pressed(&"select"):
		if hovering == true:
			if selected:
				_drop()
			else:
				selected = true
				holding_timer.start()
				gate_held.emit()
	elif event.is_action_released(&"select"):
		holding_timer.stop()
		if selected and holding:
			_drop()
	elif event.is_action_pressed(&"drop"):
		if selected:
			_drop()
	elif selected and event is InputEventMouseMotion:
		_update_position()

func _on_holding_timer_timeout():
	holding = true

func _on_area_2d_area_entered(area):
	if area is Socket2D:
		_nearby_sockets.append(area)
	if area.get_parent() is LogicGate2D:
		_colliding_gates.append(area.get_parent())

func _on_area_2d_area_exited(area):
	if area is Socket2D and area in _nearby_sockets:
		_nearby_sockets.erase(area)
	if area.get_parent() is LogicGate2D and area.get_parent() in _colliding_gates:
		_colliding_gates.erase(area.get_parent())
