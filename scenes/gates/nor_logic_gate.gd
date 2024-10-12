class_name NorLogicGate2D
extends Gate2I1O

func get_output() -> bool:
	return not(input_1 or input_2)
