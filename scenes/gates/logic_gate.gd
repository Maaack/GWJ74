class_name LogicGate
extends Node2D

signal gate_held
signal gate_dropped

var hovering : bool = false
var selected : bool = false
var holding : bool = false
var socketed : bool = false

@onready var holding_timer := $HoldingTimer

var _nearby_sockets : Array[Socket2D]
var _colliding_gates : Array[LogicGate]
var _snap_to_relative_position : Vector2
var _nearest_socket_relative_position : Vector2
var _last_clear_global_position : Vector2
var _nearest_socket : Socket2D
var connected_socket : Socket2D

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
	_nearest_socket = _get_nearest_socket()
	if _nearest_socket is Socket2D:
		_nearest_socket_relative_position = _nearest_socket.global_position - global_position
		_snap_to_relative_position = _nearest_socket_relative_position
	else:
		_snap_to_relative_position = Vector2.ZERO
	if _colliding_gates.size() == 0:
		_last_clear_global_position = global_position
	else:
		_snap_to_relative_position = _last_clear_global_position - global_position
	$ShadowSprite2D.position = _snap_to_relative_position

func _hold():
	selected = true
	if connected_socket:
		connected_socket.remove()
		connected_socket = null
	socketed = false
	holding_timer.start()
	gate_held.emit()

func _drop():
	if not holding_timer.is_stopped(): 
		holding_timer.stop()
	if holding: 
		holding = false
	selected = false
	if not _snap_to_relative_position.is_zero_approx():
		position += _snap_to_relative_position
		if _snap_to_relative_position == _nearest_socket_relative_position:
			socketed = true
			connected_socket = _nearest_socket
			connected_socket.insert(self)
		$ShadowSprite2D.position = Vector2.ZERO
	gate_dropped.emit()

func _unhandled_input(event):
	if event.is_action_pressed(&"select") and hovering:
		if not selected:
			_hold()
		else:
			_drop()
	elif event.is_action_released(&"select"):
		holding_timer.stop()
		if selected and holding:
			_drop()
	elif event.is_action_pressed(&"drop"):
		if selected:
			_drop()
	if selected and event is InputEventMouseMotion:
		_update_position()

func _on_holding_timer_timeout():
	holding = true

func _on_area_2d_area_entered(area):
	if area is Socket2D:
		_nearby_sockets.append(area)
	if area.get_parent() is LogicGate:
		_colliding_gates.append(area.get_parent())

func _on_area_2d_area_exited(area):
	if area is Socket2D and area in _nearby_sockets:
		_nearby_sockets.erase(area)
	if area.get_parent() is LogicGate and area.get_parent() in _colliding_gates:
		_colliding_gates.erase(area.get_parent())
