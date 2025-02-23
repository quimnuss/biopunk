extends Node3D

@onready var marker_3d : Marker3D = $Marker3D

const RAY_LENGTH : float = 1000

var ray_query : PhysicsRayQueryParameters3D

func _ready():
    ray_query = PhysicsRayQueryParameters3D.new()
    ray_query.collide_with_areas = true
    ray_query.collision_mask = 0x00000080

func _physics_process(delta):
    var camera3d : Camera3D = get_viewport().get_camera_3d()
    var mouse_position : Vector2 = get_viewport().get_mouse_position()

    var from : Vector3 = camera3d.project_ray_origin(mouse_position)
    var to : Vector3 = from + camera3d.project_ray_normal(mouse_position) * RAY_LENGTH
    
    var space = get_world_3d().direct_space_state
    ray_query.from = from
    ray_query.to = to
    var raycast_result : Dictionary = space.intersect_ray(ray_query)
    if raycast_result:
        var intersect_point = raycast_result.position
        
        marker_3d.global_position = intersect_point + 0.1*Vector3.UP
            
