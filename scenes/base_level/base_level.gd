@tool
class_name BaseLevel
extends Node2D

signal output_checked(input: int, output: int)
signal progress_updated(progress: float)

const MATCH_REQUIREMENT_MOD = 4

@export var input_ports : Array[IOPort] :
	set(value):
		input_ports = value
		if not input_ports.is_empty():
			input_range = pow(2, input_ports.size())
			expected_outputs.resize(input_range)
			matches_required = int(input_range * MATCH_REQUIREMENT_MOD)

@export var output_ports : Array[IOPort]
@export var expected_outputs : Array[int] = []
@export var output_check_delay : float = 0.3
@export var cycle_input_time : float = 0.5
@export var matches_required : int

var input_range : int = 0
var _consecutive_matches : int = 0
var input_iter : int = -1
var cycle_input_modifier : float = 1.0

func _update_inputs():
	input_iter += 1
	if input_iter >= input_range:
		input_iter = 0
	var _current_input = int(input_iter)
	var _wire_iter := 0
	for input_port in input_ports:
		var input_wire = input_port.wire
		var bit_mask : int = pow(2, _wire_iter)
		#print("input %d wire iter %d bitmask %d and %d" % [_current_input, _wire_iter, bit_mask, bit_mask & _current_input])
		var wire_charged : bool = (bit_mask & _current_input) > 0
		if wire_charged:
			input_wire.charge = 1.0
		else:
			input_wire.charge = 0.0
		_wire_iter += 1

func update_progress():
	progress_updated.emit(float(_consecutive_matches) / float(matches_required))

func _reset_progress():
	_consecutive_matches = 0
	update_progress()

func get_input_bit_range() -> int:
	return input_ports.size()

func get_output_bit_range() -> int:
	return output_ports.size()

func _check_output():
	var _current_output = _get_current_output()
	var _expected_output : int = expected_outputs[input_iter]
	var _outputs_match : bool = _current_output == _expected_output
	if _outputs_match:
		_consecutive_matches += 1
	else:
		_reset_progress()
	output_checked.emit(input_iter, _current_output)
	await get_tree().create_timer(0.1, true).timeout
	update_progress()

func _get_current_output():
	var _current_output : int = 0
	var _wire_iter := 0
	for output_port in output_ports:
		var output_wire = output_port.wire
		var bit_value := pow(2, _wire_iter)
		if round(output_wire.charge) > 0:
			_current_output += bit_value
		_wire_iter += 1
	return _current_output

func _delay_check_output():
	await get_tree().create_timer(output_check_delay).timeout
	_check_output()

func update():
	_update_inputs()
	_delay_check_output()

func _connect_socket_signals(socket : Socket2I1O):
	socket.connect(&"gate_removed", _reset_progress)

func _connect_sockets():
	for child in get_children():
		if child is Socket2I1O:
			_connect_socket_signals(child)

func _on_update_timer_timeout():
	update()

func toggle_tests(toggled_on : bool):
	if toggled_on:
		$UpdateTimer.start(cycle_input_time / cycle_input_modifier)
	else:
		$UpdateTimer.stop()

func update_test_speed(modifier : float = 1.0):
	cycle_input_modifier = modifier
	$UpdateTimer.wait_time = cycle_input_time / cycle_input_modifier

func _ready():
	_connect_sockets()
