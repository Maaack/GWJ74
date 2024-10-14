extends HBoxContainer

@export var good_color : Color = Color.WHITE
@export var bad_color : Color = Color.WHITE

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

var input_bit_range : int
var output_bit_range : int

func _to_base_2_string(integer : int, bit_range) -> String:
	var base_2_string := ""
	for iter in range(bit_range):
		var bit_mask : int = int(pow(2,iter))
		var result : bool = (bit_mask & integer) > 0
		if result:
			base_2_string = "1" + base_2_string
		else:
			base_2_string = "0" + base_2_string
	return base_2_string

func _update_input():
	%Input.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%Input.text = _to_base_2_string(input, input_bit_range)

func _update_expected_output():
	%ExpectedOutput.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%ExpectedOutput.text = _to_base_2_string(expected_output, output_bit_range)

func _update_output():
	%Output.modulate = Color.WHITE
	%Output.text = ""
	await get_tree().create_timer(0.1, true).timeout
	%Output.text = _to_base_2_string(output, output_bit_range)
	if output == expected_output:
		%Output.modulate = good_color
	else:
		%Output.modulate = bad_color

func clear_output():
	%Output.text = ""

func clear_all():
	%Input.text = ""
	%ExpectedOutput.text = ""
	%Output.text = ""
