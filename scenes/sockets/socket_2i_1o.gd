@tool
class_name Socket2I1O
extends Socket1I1O

@export var input_2_wire : Wire :
	set(value):
		input_2_wire = value
		_update_wire_input_2_position()
		if input_2_wire is Wire:
			_try_to_connect_signal_to_node(input_2_wire, &"charge_changed", func(_a):update())

func get_input_2_global_position() -> Vector2:
	return $Input2Line2D.global_position + $Input2Line2D.points[0]

func _update_wire_input_2_position():
	if input_2_wire is Wire:
		input_2_wire.end_global_position = get_input_2_global_position()

func _update_wire_positions():
	_update_wire_input_1_position()
	_update_wire_input_2_position()
	_update_wire_output_1_position()

func update():
	if not (input_1_wire and input_2_wire and output_1_wire): return
	if inserted_gate is Gate2I1O:
		inserted_gate.input_1 = round(input_1_wire.charge)
		inserted_gate.input_2 = round(input_2_wire.charge)
		output_1_wire.charge = float(inserted_gate.get_output())
