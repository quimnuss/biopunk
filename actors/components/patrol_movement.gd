extends Node

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var patroled_distance : float = 0

var patrol_direction : Vector3 = Vector3.FORWARD

signal info(text : String)

func patrol(delta : float):
    var papa : CharacterBody3D = get_parent()
    if patroled_distance <= 0:
        var patrol_direction_v2 = Vector2.from_angle(randf()*2*PI)
        patrol_direction = Vector3(patrol_direction_v2.x, 0, patrol_direction_v2.y)
        patroled_distance = randf()*20 + 10
    
    papa.velocity = SPEED * patrol_direction
    patroled_distance -= delta * SPEED
    papa.move_and_slide()
    
    info.emit(str(int(patroled_distance)))
