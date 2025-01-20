extends StaticBody3D
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D

var highlight_material : Material

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
