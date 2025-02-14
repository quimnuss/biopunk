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

static func statename_to_id(state_name : String):
    return StateID.keys().find(state_name) as StateID

@export var id : StateID = StateID.NONE

@export var pawn : Node3D
    

signal finished(next_state_path: StateID, data: Dictionary)

func setup(fsm_pawn : Node3D):
    pawn = fsm_pawn
    if id == StateID.NONE:
        id = statename_to_id(self.name)

func handle_input(_event:InputEvent) -> void:
    pass
    
func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func enter(_previous_state: State, _data := {}) -> void:
    pass

func exit() -> void:
    pass
