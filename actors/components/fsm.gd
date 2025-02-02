extends Node
class_name FSM

@export var moveset : Moveset
@export var forced_state : State = State.NONE

enum State {NONE, PATROL, EAT, TOEAT, EVADE, REVERSE}
var state_names : Dictionary = {State.NONE : 'none', State.PATROL : 'patrol', State.EAT : 'eat', State.TOEAT : 'toeat', State.EVADE : 'evade', State.REVERSE : 'reverse'}

var state : State = State.PATROL : 
    set = set_state

var elapsed : float = 0
var papa : CharacterBody3D

signal info(msg : String)
signal state_changed(state_name : String)


func _ready():
    papa = get_parent()


func set_state(new_state: State) -> void:
    var previous_state := state
    state = new_state
    
    match previous_state:
        State.EAT:
            elapsed = 0
            papa.hunger = 0
        State.EVADE:
            elapsed = 0
        State.REVERSE:
            elapsed = 0
        State.PATROL:
            moveset.patroled_distance = 0
    
    match new_state:
        State.EAT:
            info.emit('eat started')
            elapsed = 0
        State.REVERSE:
            elapsed = 0
            papa.velocity = -papa.velocity

    state_changed.emit(state_names[state])


func papa_physics_process(delta: float) -> void:
    if forced_state != State.NONE:
        state = forced_state
        forced_state = State.NONE
        
    match state:
        State.PATROL:
            moveset.patrol(delta)
            papa.rotation.y = lerp_angle(papa.rotation.y, atan2(papa.velocity.x, papa.velocity.z), 0.1)
        State.TOEAT:
            info.emit('to eat')
            moveset.move_to(delta)
            papa.rotation.y = lerp_angle(papa.rotation.y, atan2(papa.velocity.x, papa.velocity.z), 0.1)
        State.EAT:
            info.emit('eat started')
            eat(delta)
        State.EVADE:
            moveset.evade(delta)
            elapsed += delta
            if elapsed >= 3:
                state = State.PATROL
        State.REVERSE:
            elapsed += delta
            if elapsed >= 1.5:
                state = State.PATROL
            moveset.keep_going(delta)
            papa.rotation.y = lerp_angle(papa.rotation.y, atan2(papa.velocity.x, papa.velocity.z), 0.1)
        State.NONE:
            info.emit('No state')
            pass


func eat(delta : float):
    elapsed += delta
    if elapsed >= 3:
        info.emit('eat done')
        state = State.PATROL
