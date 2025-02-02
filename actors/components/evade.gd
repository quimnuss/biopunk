extends Node
class_name Evade

@export var target : Node3D

signal info(text : String)

func evade(delta : float):
    
    var papa : CharacterBody3D = get_parent()
    var target_relative_position : Vector3 = (target.global_position - papa.global_position)
    papa.velocity = -target_relative_position.normalized() * papa.SPEED
    papa.move_and_slide()
