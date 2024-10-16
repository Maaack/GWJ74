@tool
class_name Socket1I1O
extends Socket2D

@export var input_1_wire : Wire :
	set(value):
		input_1_wire = value
		_update_wire_input_1_position()
		if input_1_wire is Wire:
			_try_to_connect_signal_to_node(input_1_wire, &"charge_changed", func(_a):update())

@export var output_1_wire : Wire : 
	set(value):
		output_1_wire = value
		_update_wire_output_1_position()

func get_input_1_global_position() -> Vector2:
	return $Input1Line2D.global_position + $Input1Line2D.points[0]

func get_output_1_global_position() -> Vector2:
	return $Output1Line2D.global_position + $Output1Line2D.points[$Output1Line2D.points.size()-1]

func _update_wire_input_1_position():
	if input_1_wire is Wire:
		input_1_wire.end_global_position = get_input_1_global_position()

func _update_wire_output_1_position():
	if output_1_wire is Wire:
		output_1_wire.start_global_position = get_output_1_global_position()

func _update_wire_positions():
	_update_wire_input_1_position()
	_update_wire_output_1_position()

func _try_to_connect_signal_to_node(node : Node, signal_name : StringName, callable : Callable):
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func update():
	if not (input_1_wire and output_1_wire): return
	if inserted_gate is Gate1I1O:
		inserted_gate.input_1 = round(input_1_wire.charge)
		output_1_wire.charge = float(inserted_gate.get_output())

func remove():
	super.remove()
	if output_1_wire:
		output_1_wire.charge = 0.0

func _ready():
	_update_wire_positions()
