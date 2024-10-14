extends HBoxContainer

var input : int :
	set(value):
		input = value
		_update_input()
var expected_output : int :
	set(value):
		expected_output = value
		_update_expected_output()
var output : int :
	set(value):
		output = value
		_update_output()

func _to_base_2_string(integer : int) -> String:
	var base_2_string := ""
	for iter in range(8):
		var bit_mask : int = int(pow(2,iter))
		var result : bool = (bit_mask & integer) > 0
		if result:
			base_2_string += "1"
		else:
			base_2_string += "0"
	return base_2_string

func _update_input():
	%Input.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%Input.text = _to_base_2_string(input)

func _update_expected_output():
	%ExpectedOutput.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%ExpectedOutput.text = _to_base_2_string(expected_output)

func _update_output():
	%Output.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%Output.text = _to_base_2_string(output)

func clear_output():
	%Output.text = ""

func clear_all():
	%Input.text = ""
	%ExpectedOutput.text = ""
	%Output.text = ""
