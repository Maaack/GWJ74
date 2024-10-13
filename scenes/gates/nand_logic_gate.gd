class_name NandLogicGate2D
extends Gate2I1O

func get_output() -> int:
	return bit_not(input_1 & input_2)
