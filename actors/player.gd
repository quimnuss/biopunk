extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
@onready var human_explorer: Node3D = $human_explorer

var last_mouse_position : Vector3

func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity += get_gravity() * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
    if direction:
        velocity.x = direction.x * SPEED
        velocity.z = direction.z * SPEED
        #human_explorer.rotation.y = Vector2(input_dir.x, -input_dir.y).angle() + PI/2
        human_explorer.run()
    else:
        velocity.x = move_toward(velocity.x, 0, SPEED)
        velocity.z = move_toward(velocity.z, 0, SPEED)
        human_explorer.idle()


    move_and_slide()


func _on_mouse_3d_mouse_position_changed(intersect_point: Vector3) -> void:
    last_mouse_position = intersect_point
    var last_mouse_position_on_plane : Vector3 = Vector3(last_mouse_position.x, human_explorer.global_position.y, last_mouse_position.z)
    human_explorer.look_at(last_mouse_position_on_plane, Vector3.UP, true)
