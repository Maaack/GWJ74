class_name Gate2I1O
extends LogicGate

var input_1 : int = 0
var input_2 : int = 0

func _get_inputs_value():
	return input_1 + (input_2 * 2)

func bit_not(bit : int):
	return 0 if bit != 0 else 1

func get_output() -> int:
	return 0
