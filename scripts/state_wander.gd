extends State

var elapsed : float = 0

var state_id : StateID = StateID.WANDER

@export var timeout_to : StateID = StateID.WANDER

@export var wander_type : Moveset.MovementType = Moveset.MovementType.KEEP_GOING

func enter(previous_state: State, data := {}) -> void:
    elapsed = 0

func physics_update(delta: float) -> void:

    match wander_type:
        Moveset.MovementType.PATROL:
            pawn.moveset.patrol(delta)
        _:
            pawn.moveset.patrol(delta)
    pawn.rotation.y = lerp_angle(pawn.rotation.y, atan2(pawn.velocity.x, pawn.velocity.z), 0.1)
