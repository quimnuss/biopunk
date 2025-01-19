extends Node

@export var target : Node3D

@export var SPEED : float = 2.0

func _ready() -> void:
    pass

func _physics_process(_delta):
    var papa : CharacterBody3D = get_parent()
    if not target:
        papa.move_and_slide()    
        return
    papa.look_at(target.global_position, Vector3.UP)
    papa.rotate_y(-PI/2)
    papa.velocity = Vector3.FORWARD * SPEED
    papa.velocity = papa.velocity.rotated(Vector3.UP, papa.rotation.y)
    papa.move_and_slide()
    
