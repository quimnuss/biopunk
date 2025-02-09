extends State

var elapsed : float = 0

var state_id : StateID = StateID.WANDER

@export var timeout_to : StateID = StateID.WANDER

func enter(previous_state: State, data := {}) -> void:
    elapsed = 0

func physics_update(delta: float) -> void:
    pawn.moveset.patrol(delta)
    pawn.rotation.y = lerp_angle(pawn.rotation.y, atan2(pawn.velocity.x, pawn.velocity.z), 0.1)

    elapsed += delta
    if elapsed >= 3:
        finished.emit(timeout_to, {})
