extends CharacterBody3D
@onready var patrol_movement: Node = $PatrolMovement
@onready var move_to: Node = $MoveTo

const SPEED = 7

enum State {NONE, PATROL, EAT, TOEAT}

var state : State = State.PATROL : 
    set = set_state

@export var forced_state : State = State.NONE

signal info(msg : String)

func set_state(new_state: State) -> void:
    var previous_state := state
    state = new_state
    
    match previous_state:
        State.EAT:
            elapsed = 0
        State.PATROL:
            patrol_movement.patroled_distance = 0
    
    match new_state:
        State.EAT:
            info.emit('eat started')
            elapsed = 0


var elapsed : float = 0

func _physics_process(delta: float) -> void:
    if forced_state != State.NONE:
        state = forced_state
        forced_state = State.NONE
        
    match state:
        State.PATROL:
            patrol_movement.patrol(delta)
            rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), 0.1)
        State.TOEAT:
            info.emit('to eat')
            move_to.move_to(delta)
        State.EAT:
            info.emit('eat started')
            eat(delta)
        State.NONE:
            info.emit('No state')
            pass

func eat(delta : float):
    elapsed += delta
    if elapsed >= 3:
        info.emit('eat done')
        elapsed = 0
        state = State.PATROL
    

func _on_sensor_body_entered(body: Node3D) -> void:
    move_to.target = body
    state = State.TOEAT


func _on_reach_sensor_body_entered(body: Node3D) -> void:
    if state == State.TOEAT:
        state = State.EAT
        # food hurtbox
        body.hurt()
