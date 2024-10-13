class_name NandLogicGate
extends HauntableGate2I1O

func _get_raw_output() -> int:
	return bit_not(input_1 & input_2)
