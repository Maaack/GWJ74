@tool
extends Node2D

@export var input_wire : Wire :
	set(value):
		input_wire = value
		_update_wire_input_position()
		if input_wire is Wire:
			_try_to_connect_signal_to_node(input_wire, &"charge_changed", func(_a):update())

@export var output_wire : Wire :
	set(value):
		output_wire = value
		_update_wire_output_position()

func get_input_global_position() -> Vector2:
	return %InputMarker2D.global_position

func get_output_global_position() -> Vector2:
	return $OutputMarker2D.global_position

func _update_wire_input_position():
	if input_wire is Wire:
		input_wire.end_global_position = get_input_global_position()

func _update_wire_output_position():
	if output_wire is Wire:
		output_wire.start_global_position = get_output_global_position()

func _try_to_connect_signal_to_node(node : Node, signal_name : StringName, callable : Callable):
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func update():
	if not (input_wire and output_wire): return
	%BulbSprite2D2.visible = round(input_wire.charge) == 0
	output_wire.charge = input_wire.charge
