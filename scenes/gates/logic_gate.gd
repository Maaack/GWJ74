class_name LogicGate2D
extends Node2D

signal gate_held
signal gate_dropped

var hovering : bool = false
var selected : bool = false
var holding : bool = false

@onready var holding_timer := $HoldingTimer

func _on_area_2d_mouse_entered():
	hovering = true

func _on_area_2d_mouse_exited():
	hovering = false

func _unhandled_input(event):
	if event.is_action_pressed(&"select"):
		if hovering == true:
			if selected:
				selected = false
				gate_dropped.emit()
			else:
				selected = true
				holding_timer.start()
				gate_held.emit()
	elif event.is_action_released(&"select"):
		holding_timer.stop()
		if selected and holding:
			holding = false
			selected = false
			gate_dropped.emit()
	elif event.is_action_pressed(&"drop"):
		if selected:
			selected = false
			gate_dropped.emit()
	elif selected and event is InputEventMouseMotion:
		global_position = get_global_mouse_position()

func _on_holding_timer_timeout():
	holding = true
