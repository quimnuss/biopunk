class_name StateMachine extends Node

@export var initial_state: State = null

@onready var state: State = get_initial_state()

@export var pawn : Node3D

var states : Dictionary

func get_initial_state() -> State:
    return initial_state if initial_state != null else get_child(0)


func _ready() -> void:
    for state_node: State in find_children("*", "State"):
        state_node.papa = pawn
        state_node.finished.connect(_transition_to_next_state)
        states[state_node.id] = state_node

    await pawn.ready
    state.enter(null)


func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)


func _process(delta: float) -> void:
    state.update(delta)


func _physics_process(delta: float) -> void:
    state.physics_update(delta)


func _transition_to_next_state(to_state_id: State.StateID, data: Dictionary = {}) -> void:
    if to_state_id not in states:
        printerr(pawn.name + ": Trying to transition to state " + State.state_names(to_state_id) + " but it does not exist.")
        return

    var previous_state := state
    state.exit()
    state = states[to_state_id]
    state.enter(previous_state, data)
