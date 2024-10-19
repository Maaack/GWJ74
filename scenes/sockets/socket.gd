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
				_animate_gate_insert()
				gate_inserted.emit(inserted_gate)
			else:
				gate_removed.emit()

@onready var particle_2ds : Array[GPUParticles2D] = [
	$GPUParticles2D,
	$GPUParticles2D2,
	$GPUParticles2D3,
	$GPUParticles2D4
]

func _animate_gate_insert():
	if $GateInsertedStreamPlayer2D.is_inside_tree():
		$GateInsertedStreamPlayer2D.play()
	for particle_2d in particle_2ds:
		if particle_2d.is_inside_tree():
			particle_2d.emitting = true

func insert(gate : LogicGate):
	inserted_gate = gate

func remove():
	inserted_gate = null
	gate_removed.emit()

func update():
	pass
