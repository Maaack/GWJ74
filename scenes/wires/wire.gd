@tool
class_name Wire
extends Line2D

signal charge_changed(new_charge : float)

@export var start_position : Vector2 :
	set(value):
		start_position = value
		_update_line()

@export var end_position : Vector2 :
	set(value):
		end_position = value
		_update_line()

var start_global_position : Vector2 :
	set(value):
		var _value_changed = start_global_position != value
		start_global_position = value
		if _value_changed:
			start_position = start_global_position - global_position

var end_global_position : Vector2 :
	set(value):
		var _value_changed = end_global_position != value
		end_global_position = value
		if _value_changed:
			end_position = end_global_position - global_position

var charge : float = 0 :
	set(value):
		charge = value
		charge_changed.emit(charge)

func _update_line():
	var points_array = points
	points_array.clear()
	points_array.append(start_position)
	points_array.append(end_position)
	points = points_array
	
