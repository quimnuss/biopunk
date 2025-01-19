extends CharacterBody3D
@onready var patrol_movement: Node = $PatrolMovement

func _physics_process(delta: float) -> void:
    patrol_movement.patrol(delta)
    rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), 0.1)
