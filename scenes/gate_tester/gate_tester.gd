@tool
class_name Gate2I1OTester
extends Node2D

@export var test_delay : float = 0.25
@export var reads_gate_type : bool = false
@export var repeat_delay : float = 0.5
@export var show_repeat_button : bool = false :
	set(value):
		show_repeat_button = value
		%RepeatButton.visible = show_repeat_button

@onready var gate_type_label : Label = %GateTypeLabel
@onready var output_00_label : Label = %Output00Label
@onready var output_01_label : Label = %Output01Label
@onready var output_10_label : Label = %Output10Label
@onready var output_11_label : Label = %Output11Label
@onready var socket : Socket2I1O = %Socket2I1O

@onready var outputs : Array[Label] = [
	output_00_label,
	output_01_label,
	output_10_label,
	output_11_label,
]

var power_mode : bool = true :
	set(value):
		power_mode = value
		if power_mode:
			test_gate_suite()
		else:
			clear_outputs()

var repeat_mode : bool = false :
	set(value):
		repeat_mode = value
		if repeat_mode:
			test_gate_suite()

func clear_outputs():
	for output in outputs:
		output.text = ""
	gate_type_label.text = ""

func get_gate():
	if socket.inserted_gate is Gate2I1O:
		return socket.inserted_gate

func test_gate(input_1 : int, input_2 : int, gate : Gate2I1O) -> int:
	gate.input_1 = input_1
	gate.input_2 = input_2
	return gate.get_output()

func test_gate_suite():
	clear_outputs()
	if reads_gate_type:
		gate_type_label.text = get_gate().gate_name
	while power_mode and get_gate():
		var iter = 0
		for test in range(outputs.size()):
			if iter > outputs.size(): break
			var _output_label : Label = outputs[iter]
			_output_label.text = ""
			await get_tree().create_timer(test_delay, false).timeout
			var gate = get_gate()
			if gate is not Gate2I1O: return
			var test_input_1 : int = int((test & 1) > 0)
			var test_input_2 : int = int((test & 2) > 0)
			var _result : int = test_gate(test_input_1, test_input_2, gate)
			iter += 1
			_output_label.text = "%d" % int(_result)
		if not repeat_mode: break
		await get_tree().create_timer(repeat_delay, false).timeout

func _on_socket_2i_1o_gate_inserted(gate):
	test_gate_suite()

func _on_power_button_toggled(toggled_on):
	power_mode = toggled_on

func _on_repeat_button_toggled(toggled_on):
	repeat_mode = toggled_on
