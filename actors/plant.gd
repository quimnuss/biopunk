extends StaticBody3D
class_name BallPlant
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var highlight_material : Material

signal picked_up(actor : Node3D)

func _ready():
    highlight_material = mesh_instance_3d.material_overlay

func hurt():
    var tween : Tween = get_tree().create_tween()
    tween.tween_property(self, 'scale', Vector3(0.1,0.1,0.1), 1.5)
    tween.tween_callback(queue_free)
    
func highlight():
    self.mesh_instance_3d.material_overlay = highlight_material

func dehighlight():
    self.mesh_instance_3d.material_overlay = null

func pickup():
    var actor : Node3D = self.duplicate()
    picked_up.emit(actor)

func release():
    # TODO set collision mask on release only
    pass
