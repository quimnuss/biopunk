extends Node3D
class_name Spawner

@onready var spawn_timer: Timer = $SpawnTimer
@onready var area_3d: Area3D = $Area3D
@onready var debug_info: MeshInstance3D = $DebugInfo

@export var pawn : Node3D

const PLANT_CARRYING_CAPACITY : int = 20

func _ready():
    pawn = owner


func stop():
    spawn_timer.stop()


func play():
    spawn_timer.start(spawn_timer.wait_time)


func can_spawn():
    if get_tree().get_node_count_in_group('plants') > PLANT_CARRYING_CAPACITY:
        return false
    for side in range(3):
        if area_3d.has_overlapping_bodies():
            debug_info.material_override = preload("res://materials/M_red.tres")
            self.rotate_y(PI/2)# + PI/5)
        else:
            debug_info.material_override = preload("res://materials/M_yellow.tres")
            return true
    return false

func _physics_process(delta: float) -> void:
    if area_3d.has_overlapping_bodies():
        debug_info.material_override = preload("res://materials/M_red.tres")
    else:
        debug_info.material_override = preload("res://materials/M_yellow.tres")


func circle_spawn():
    if not can_spawn():
        return
    var clone : Node3D = pawn.Instantiate(pawn)
    owner.add_sibling(clone)
    clone.rotate_y(randf_range(0, 2 * PI))
    clone.global_position = area_3d.global_position
    clone.global_position.y = 0


func _on_spawn_timer_timeout() -> void:
    circle_spawn()
