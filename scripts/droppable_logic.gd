extends Node3D

var picked_actor : Node3D

const RAY_LENGTH : float = 100

@export var dropped_parent_anchor : Node

func _physics_process(delta):
    if is_instance_valid(picked_actor):
        if Input.is_action_just_released("select"):
            picked_actor.release()
            picked_actor = null
        else:
            var camera3d : Camera3D = get_viewport().get_camera_3d()
            var mouse_position : Vector2 = get_viewport().get_mouse_position()

            var from : Vector3= camera3d.project_ray_origin(mouse_position)
            var to : Vector3 = from + camera3d.project_ray_normal(mouse_position) * RAY_LENGTH
            picked_actor.global_position = to
            

func _on_plant_picked_up(actor):
    picked_actor = actor
    dropped_parent_anchor.add_child(actor)
