extends State

var elapsed : float = 0

@export var timeout_to : StateID = StateID.WANDER

func enter(previous_state: State, data := {}) -> void:
    elapsed = 0

func physics_update(delta: float) -> void:
    elapsed += delta
    if elapsed >= 3:
        finished.emit(timeout_to, {})
