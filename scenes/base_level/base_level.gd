@tool
class_name BaseLevel
extends Node2D

signal level_won
signal level_lost

const MATCH_REQUIREMENT_MOD = 2.5

@export var input_wires : Array[Wire] :
	set(value):
		input_wires = value
		_combinations = pow(input_wires.size(), 2)
		expected_outputs.resize(_combinations)
		_consecutive_matches_required = int(_combinations * MATCH_REQUIREMENT_MOD)

@export var output_wires : Array[Wire]
@export var expected_outputs : Array[int] = []
@export var output_check_delay : float = 0.3

var _combinations : int = 0
var _consecutive_matches_required : int = 0
var _consecutive_matches : int = 0
var input_iter : int = -1

func _update_inputs():
	input_iter += 1
	if input_iter >= _combinations:
		input_iter = 0
	var _current_input = int(input_iter)
	var _wire_iter := 0
	for input_wire in input_wires:
		var bit_mask : int = pow(2, _wire_iter)
		#print("input %d wire iter %d bitmask %d and %d" % [_current_input, _wire_iter, bit_mask, bit_mask & _current_input])
		var wire_charged : bool = (bit_mask & _current_input) > 0
		if wire_charged:
			input_wire.charge = 1.0
		else:
			input_wire.charge = 0.0
		_wire_iter += 1

func _check_level_won():
	if _consecutive_matches >= _consecutive_matches_required:
		level_won.emit()

func _check_output():
	var _current_output = _get_current_output()
	print("%d match %d to " % [input_iter, expected_outputs[input_iter]], _current_output)
	if _current_output == expected_outputs[input_iter]:
		_consecutive_matches += 1
	else:
		_consecutive_matches = 0

func _get_current_output():
	var _current_output : int = 0
	var _wire_iter := 0
	for output_wire in output_wires:
		var bit_value := pow(2, _wire_iter)
		if round(output_wire.charge) > 0:
			_current_output += bit_value
		_wire_iter += 1
	return _current_output

func _delay_check_output():
	await get_tree().create_timer(output_check_delay).timeout
	_check_output()
	_check_level_won()

func update():
	_update_inputs()
	_delay_check_output()

func _on_update_timer_timeout():
	update()
