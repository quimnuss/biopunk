extends Node
class_name MoveTo

@export var target : Node3D

signal info(text : String)
signal reached

func move_to(delta : float):
    
    var papa : CharacterBody3D = get_parent()
    var target_relative_position : Vector3 = (target.global_position - papa.global_position)
    if target_relative_position.length() < 1:
        reached.emit()
        return
    papa.velocity = target_relative_position.normalized() * papa.SPEED
    papa.move_and_slide()
