class_name NotLogicGate
extends Gate1I1O

func _get_raw_output() -> int:
	return bit_not(input_1)
