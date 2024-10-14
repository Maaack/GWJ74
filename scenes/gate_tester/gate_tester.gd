class_name Gate2I1OTester
extends Node2D

@export var test_time : float = 0.25
@export var reads_gate_type : bool = false

@onready var gate_type_label : Label = %GateTypeLabel
@onready var output_00_label : Label = %Output00Label
@onready var output_01_label : Label = %Output01Label
@onready var output_10_label : Label = %Output10Label
@onready var output_11_label : Label = %Output11Label

@onready var outputs : Array[Label] = [
	output_00_label,
	output_01_label,
	output_10_label,
	output_11_label,
]

func clear_outputs():
	for output in outputs:
		output.text = ""
	gate_type_label.text = ""

func test_gate(input_1 : int, input_2 : int, gate : Gate2I1O) -> int:
	gate.input_1 = input_1
	gate.input_2 = input_2
	return gate.get_output()

func test_gate_suite(gate : Gate2I1O):
	clear_outputs()
	var iter = 0
	if reads_gate_type:
		gate_type_label.text = gate.gate_name
	for test in range(outputs.size()):
		if iter > outputs.size(): break
		await get_tree().create_timer(test_time, false).timeout
		var _output_label : Label = outputs[iter]
		var test_input_1 : int = int((test & 1) > 0)
		var test_input_2 : int = int((test & 2) > 0)
		var _result : int = test_gate(test_input_1, test_input_2, gate)
		iter += 1
		_output_label.text = "%d" % int(_result)

func _on_socket_2i_1o_gate_inserted(gate):
	test_gate_suite(gate)
