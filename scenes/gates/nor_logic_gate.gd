class_name NorLogicGate
extends Gate2I1O

func _get_raw_output() -> int:
	return bit_not(input_1 | input_2)
