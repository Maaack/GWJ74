@tool
class_name Socket2D
extends Area2D

signal gate_inserted(gate : LogicGate)
signal gate_removed

@export var inserted_gate : LogicGate :
	set = insert

func insert(gate : LogicGate):
	var _value_changed = inserted_gate != gate
	inserted_gate = gate
	if _value_changed and inserted_gate is LogicGate:
		inserted_gate.global_position = global_position
		inserted_gate.connected_socket = self
		gate_inserted.emit(inserted_gate)

func remove():
	inserted_gate = null
	gate_removed.emit()

func update():
	pass
