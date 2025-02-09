extends State

var elapsed : float = 0

var state_id : StateID = StateID.WANDER

@export var timeout_to : StateID = StateID.WANDER

@export var target : Node3D

var moveset : Moveset

func _ready():
    pass

func enter(_previous_state: State, data := {}) -> void:
    elapsed = 0
    #assert(data.has("target"))
    #pawn.moveset.target = data['target']

func physics_update(delta: float) -> void:    
    pawn.moveset.move_to(delta)
    pawn.rotation.y = lerp_angle(pawn.rotation.y, atan2(pawn.velocity.x, pawn.velocity.z), 0.1)
