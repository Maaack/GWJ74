class_name OrLogicGate2D
extends Gate2I1O

func get_output() -> int:
	return input_1 | input_2
