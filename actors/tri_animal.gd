extends CharacterBody3D
@onready var patrol_movement: Node = $PatrolMovement
@onready var move_to: Node = $MoveTo

const SPEED = 7

enum State {NONE, PATROL, EAT, TOEAT}

var current_state : State = State.PATROL

@export var forced_state : State = State.NONE

signal info(msg : String)

func _physics_process(delta: float) -> void:
    if forced_state != State.NONE:
        current_state = forced_state
        forced_state = State.NONE
        
    match current_state:
        State.PATROL:
            patrol_movement.patrol(delta)
            rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), 0.1)
        State.TOEAT:
            info.emit('to eat')
            move_to.move_to(delta)
        State.EAT:
            info.emit('eat started')
            await get_tree().create_timer(2).timeout
            info.emit('eat done')
            current_state = State.PATROL
        State.NONE:
            pass


func _on_sensor_body_entered(body: Node3D) -> void:
    move_to.target = body
    current_state = State.TOEAT


func _on_reach_sensor_body_entered(body: Node3D) -> void:
    if current_state == State.TOEAT:
        current_state = State.EAT
        # food hurtbox
        body.hurt()
