@tool
class_name Socket2D
extends Area2D

signal gate_inserted(gate : LogicGate)
signal gate_removed

@export var inserted_gate : LogicGate :
	set(value):
		var _value_changed = inserted_gate != value
		inserted_gate = value
		if _value_changed:
			if inserted_gate is LogicGate:
				inserted_gate.global_position = global_position
				inserted_gate.connected_socket = self
				if $GateInsertedStreamPlayer2D.is_inside_tree():
					$GateInsertedStreamPlayer2D.play()
				gate_inserted.emit(inserted_gate)
			else:
				gate_removed.emit()

func insert(gate : LogicGate):
	inserted_gate = gate

func remove():
	inserted_gate = null
	gate_removed.emit()

func update():
	pass
