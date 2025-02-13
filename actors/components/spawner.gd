extends Node3D
@onready var area_3d: Area3D = $Area3D

func spawn():
    self.rotate(Vector3.UP, PI/2)
    var clone : Node = owner.duplicate()
    clone.global_position = area_3d.global_position
    owner.add_sibling(clone)


func _on_timer_timeout() -> void:
    spawn()
