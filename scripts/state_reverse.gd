extends State

var elapsed : float = 0

func enter(_previous_state: State, data := {}) -> void:
    elapsed = 0
    pawn.velocity = -pawn.velocity

func physics_update(_delta : float):
    elapsed += _delta
    if elapsed >= 1.5:
        finished.emit(State.StateID.WANDER)
    pawn.moveset.keep_going(_delta)
    pawn.rotation.y = lerp_angle(pawn.rotation.y, atan2(pawn.velocity.x, pawn.velocity.z), 0.1)
