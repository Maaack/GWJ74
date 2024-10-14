class_name Wire
extends Line2D

signal charge_changed(new_charge : float)

var charge : float = 0 :
	set(value):
		charge = value
		charge_changed.emit(charge)
