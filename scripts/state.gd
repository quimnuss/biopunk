extends Node
class_name State

enum StateID {
    NONE,
    # States
    CALM, THREAT, CURIOUS, EVADE, HIDE, SPECIAL,
    # SubStates
    IDLE, WANDER, EAT, TOEAT, SLEEP, REVERSE
}

static func state_names(key : StateID):
    return StateID.keys()[key]

var id : StateID = StateID.NONE

@export var pawn : Node3D
    

signal finished(next_state_path: StateID, data: Dictionary)

func handle_input(_event:InputEvent) -> void:
    pass
    
func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func enter(previous_state: State, data := {}) -> void:
    pass

func exit() -> void:
    pass
