class_name Socket2D
extends Area2D

signal gate_inserted(gate : LogicGate2D)
signal gate_removed

var inserted_gate : LogicGate2D

func insert(gate : LogicGate2D):
	inserted_gate = gate
	gate_inserted.emit(inserted_gate)

func remove():
	inserted_gate = null
	gate_removed.emit()
