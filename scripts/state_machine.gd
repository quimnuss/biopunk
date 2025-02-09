extends Node
class_name StateMachine

@export var initial_state: State = null

@onready var state: State = get_initial_state()

@export var pawn : Node3D

var states : Dictionary

func get_initial_state() -> State:
    return initial_state if initial_state != null else get_child(0)

func _ready() -> void:
    assert(is_instance_valid(pawn))
    
    for state_node: State in find_children("*", "State"):
        state_node.setup(pawn)
        state_node.finished.connect(to_state)
        states[state_node.id] = state_node

    await pawn.ready
    state.enter(null)


func _unhandled_input(event: InputEvent) -> void:
    state.handle_input(event)


func _process(delta: float) -> void:
    state.update(delta)


func physics_update(delta: float) -> void:
    state.physics_update(delta)


func to_state(to_state_id: State.StateID, data: Dictionary = {}) -> void:
    if to_state_id not in states:
        printerr(pawn.name + ": Trying to transition to state " + State.state_names(to_state_id) + " but it does not exist.")
        return

    var previous_state := state
    state.exit()
    state = states[to_state_id]
    state.enter(previous_state, data)
