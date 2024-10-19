class_name OrLogicGate
extends Gate2I1O

func _get_raw_output() -> int:
	return input_1 | input_2
