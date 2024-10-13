class_name Socket2I1O
extends Socket2D

@export var input_1_wire : Wire
@export var input_2_wire : Wire
@export var output_1_wire : Wire

func update():
	if not (input_1_wire and input_2_wire and output_1_wire): return
	if inserted_gate is Gate2I1O:
		inserted_gate.input_1 = round(input_1_wire.charge)
		inserted_gate.input_2 = round(input_2_wire.charge)
		output_1_wire.charge = float(inserted_gate.get_output())
