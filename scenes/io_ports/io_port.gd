@tool
class_name IOPort
extends Node2D

@export var wire : Wire :
	set(value):
		wire = value
		_update_wire()

@export var is_output : bool = false:
	set(value):
		var _value_changed = is_output != value
		is_output = value
		if _value_changed:
			$Computing.position.x = -$Computing.position.x
			_update_wire()
			_generate_port_name()

@export var port_id : int = 1 :
	set(value):
		port_id = value
		_generate_port_name()

@export var port_name : String :
	set(value):
		port_name = value
		%PortLabel.text = port_name

func _generate_port_name():
	var _port_name : String
	if is_output:
		_port_name = "Output "
	else:
		_port_name = "Input "
	_port_name += "%d" % port_id
	port_name = _port_name

func _update_wire():
	if wire is Wire:
		if is_output:
			wire.end_global_position = get_io_global_position()
		else:
			wire.start_global_position = get_io_global_position()

func _try_to_connect_signal_to_node(node : Node, signal_name : StringName, callable : Callable):
	if node.has_signal(signal_name) and not node.is_connected(signal_name, callable):
		node.connect(signal_name, callable)

func update():
	pass

func get_io_global_position() -> Vector2:
	return %WireConnection.global_position
