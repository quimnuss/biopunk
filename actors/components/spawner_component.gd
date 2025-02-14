extends Node3D
class_name Spawner

@onready var spawn_timer: Timer = $SpawnTimer
@onready var area_3d: Area3D = $Area3D
@onready var debug_info: MeshInstance3D = $DebugInfo

@export var pawn : Node3D

@export var neighbours : Array[Node3D]

func _ready():
    pawn = owner


func stop():
    spawn_timer.stop()


func play():
    spawn_timer.start(spawn_timer.wait_time)


func can_spawn():
    for side in range(3):
        neighbours = area_3d.get_overlapping_bodies()
        if owner.name == "Plant":
            print(neighbours)
        if area_3d.has_overlapping_bodies():
            debug_info.material_override = preload("res://materials/M_red.tres")
            #self.rotate_y(PI/2)# + PI/5)
        else:
            debug_info.material_override = preload("res://materials/M_yellow.tres")
            return true
    return false

func _physics_process(delta: float) -> void:
    if area_3d.has_overlapping_bodies():
        #prints(owner.name, Time.get_time_string_from_system(), area_3d.get_overlapping_bodies())
        debug_info.material_override = preload("res://materials/M_red.tres")
    else:
        #prints(owner.name, Time.get_time_string_from_system(), ' nobodies')
        debug_info.material_override = preload("res://materials/M_yellow.tres")

var has_spawned : bool = false

func circle_spawn():
    if has_spawned:
        return
    #if not can_spawn():
        #return
    has_spawned = true
    var clone : Node3D = pawn.Instantiate(false, pawn)
    owner.add_sibling(clone)
    #clone.rotate_y(randf_range(0, 2 * PI))
    clone.global_position = area_3d.global_position + Vector3(0.3, 0, 0)
    clone.initial_position = clone.global_position


func _on_spawn_timer_timeout() -> void:
    circle_spawn()
