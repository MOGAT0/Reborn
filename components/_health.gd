extends Node3D
class_name HP

@export var HP_ammount: float
@export var HP_Bar: Control

func _process(delta: float) -> void:
	HP_ammount = clamp(HP_ammount, 0 , HP_ammount)
	HP_Bar.value = HP_ammount
	

func _take_damage(ammount:float):
	HP_ammount -= ammount

func _heal(ammount:float):
	HP_ammount += ammount
