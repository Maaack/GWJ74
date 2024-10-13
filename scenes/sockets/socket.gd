class_name Socket2D
extends Area2D

signal gate_inserted(gate : LogicGate)
signal gate_removed

var inserted_gate : LogicGate

func insert(gate : LogicGate):
	inserted_gate = gate
	gate_inserted.emit(inserted_gate)

func remove():
	inserted_gate = null
	gate_removed.emit()

func update():
	pass

func _on_update_timer_timeout():
	update()
