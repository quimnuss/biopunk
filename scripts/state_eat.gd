extends State

var elapsed : float = 0

func enter(_previous_state: State, data := {}) -> void:
    elapsed = 0

func exit():
    pawn.hunger = 0

func physics_update(delta: float) -> void:
    elapsed += delta
    if elapsed >= 3:
        finished.emit(State.StateID.WANDER)
