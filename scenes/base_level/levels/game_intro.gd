extends Control

signal level_skipped

var _skip_offer_visible : bool = false

func level_complete():
	level_skipped.emit()

func _is_event_skip_input(event : InputEvent):
	return (event is InputEventMouseButton \
		or event is InputEventKey \
		or event is InputEventJoypadButton) \
		and event.is_pressed()

func _gui_input(event):
	if _is_event_skip_input(event):
		if _skip_offer_visible and %SkipTimer.is_stopped():
			level_skipped.emit()
		else:
			_skip_offer_visible = true
			%SkipLabel.show()
			%SkipTimer.start()
