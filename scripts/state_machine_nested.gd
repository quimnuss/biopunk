extends State
class_name StateMachineNested

@export var initial_state: State = null

@onready var state: State = get_initial_state()

@export var pawn : Node3D

func get_initial_state() -> State:
    return initial_state if initial_state != null else get_child(0)


func _ready() -> void:
    for state_node: State in find_children("*", "State", false):
        state_node.papa = pawn
        state_node.finished.connect(_transition_to_next_state)

    await owner.ready
    state.enter("")


func handle_input(_event:InputEvent) -> void:
    state.handle_input(_event)
    
    
func update(_delta: float) -> void:
    state.update(_delta)


func physics_update(_delta: float) -> void:
    state.physics_update(_delta)


func enter(previous_state_path: String, data := {}) -> void:
    state.enter(previous_state_path, data)


func exit() -> void:
    state.exit()


func _transition_to_next_state(target_state_path: String, data: Dictionary = {}) -> void:
    if not has_node(target_state_path):
        printerr(pawn.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
        return

    var previous_state_path := state.name
    state.exit()
    state = get_node(target_state_path)
    state.enter(previous_state_path, data)
