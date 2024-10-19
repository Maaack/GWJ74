class_name Gate2I1O
extends HauntableGate

var input_1 : int = 0
var input_2 : int = 0

func _get_inputs_value():
	return input_1 + (input_2 * 2)
