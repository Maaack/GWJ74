class_name HauntableGate
extends LogicGate

@export var haunted_inputs : Array[int]
@export var haunting_pattern : Array[bool]

var _haunting_pattern_counter : int = -1
var _haunting_incremented : bool = false

func _get_raw_output() -> int:
	return 0

func _has_input_haunting() -> bool:
	return not haunted_inputs.is_empty()

func _has_pattern_haunting() -> bool:
	return not haunting_pattern.is_empty()

func _reset_haunting_incremented():
	_haunting_incremented = false

func _get_next_pattern_haunting_output(raw_output : int) -> int:
	if not _haunting_incremented:
		_haunting_pattern_counter += 1
		_haunting_incremented = true
		_reset_haunting_incremented.call_deferred()
	if _haunting_pattern_counter >= haunting_pattern.size():
		_haunting_pattern_counter = 0
	if haunting_pattern[_haunting_pattern_counter]:
		return bit_not(raw_output)
	return raw_output

func get_haunted_output() -> int:
	var _raw_output = _get_raw_output()
	if _has_input_haunting():
		var _inputs_value = _get_inputs_value()
		if _inputs_value in haunted_inputs:
			if _has_pattern_haunting():
				return _get_next_pattern_haunting_output(_raw_output)
			else:
				return bit_not(_raw_output)
	elif _has_pattern_haunting():
		return _get_next_pattern_haunting_output(_raw_output)
	return _raw_output

func get_output() -> int:
	return get_haunted_output()
