class_name NandLogicGate2D
extends Gate2I1O

func get_output() -> bool:
	return not(input_1 and input_2)
