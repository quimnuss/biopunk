extends Node3D
class_name Spawner

enum Entities { PLANT }

@onready var area_3d: Area3D = $Area3D

@export var spawn_scene : PackedScene

@export var distance : float = 3.0

func _ready() -> void:
    # TODO use eventbus
    await get_parent().ready
    await get_tree().create_timer(1).timeout
    var spawnables : Array = get_tree().get_nodes_in_group('spawnable')
    for spawnable in spawnables:
        spawnable.request_spawn.connect(circle_spawn)

func can_spawn(location : Vector3):
    var direction := Vector3.RIGHT
    for side in range(3):
        area_3d.global_position = location + direction*distance
        if area_3d.has_overlapping_bodies():
            direction.rotated(Vector3.UP, PI/2)
        else:
            return true
    return false


#func circle_spawn(scene_path : Entities, location : Vector3):
func circle_spawn(scene_path : String, location : Vector3):
    prints(scene_path, 'requested spawn')
    if not can_spawn(location):
        return
    var spawn_scene2 : PackedScene = load(scene_path)
    var clone : Node = spawn_scene2.instantiate()
    clone.request_spawn.connect(circle_spawn)
    owner.add_sibling(clone)
    clone.global_position = area_3d.global_position
