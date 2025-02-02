extends Node
class_name Moveset

var patroled_distance : float = 0
var patrol_direction : Vector3 = Vector3.FORWARD

@export var target : Node3D

signal info(text : String)
signal reached

var papa : CharacterBody3D

func _ready():
    papa = get_parent()
    

func move_to(delta : float):
    if not is_instance_valid(target):
        reached.emit()
        return
    var target_relative_position : Vector3 = (target.global_position - papa.global_position)
    if target_relative_position.length() < 1:
        reached.emit()
        return
    papa.velocity = target_relative_position.normalized() * papa.SPEED
    papa.move_and_slide()


func follow(delta : float):
    if not is_instance_valid(target):
        papa.move_and_slide()
        return
    var target_relative_position : Vector3 = (target.global_position - papa.global_position)
    if target_relative_position.length() < 1:
        reached.emit()
        return
    papa.velocity = target_relative_position.normalized() * papa.SPEED
    papa.move_and_slide()


func patrol(delta : float):
    if patroled_distance <= 0:
        var patrol_direction_v2 = Vector2.from_angle(randf()*2*PI)
        patrol_direction = Vector3(patrol_direction_v2.x, 0, patrol_direction_v2.y).normalized()
        patroled_distance = randf()*20 + 10
    
    papa.velocity = papa.SPEED * patrol_direction
    patroled_distance -= delta * papa.SPEED
    papa.move_and_slide()
    
    info.emit(str(int(patroled_distance)))

func circle(delta: float):
    if not target:
        papa.move_and_slide()    
        return
    papa.look_at(target.global_position, Vector3.UP)
    papa.rotate_y(-PI/2)
    papa.velocity = Vector3.FORWARD * papa.SPEED
    papa.velocity = papa.velocity.rotated(Vector3.UP, papa.rotation.y)
    papa.move_and_slide()
    

func evade(delta : float):    
    var target_relative_position : Vector3 = (target.global_position - papa.global_position)
    papa.velocity = -target_relative_position.normalized() * papa.SPEED
    papa.move_and_slide()

func keep_going(delta : float):
    papa.move_and_slide()
