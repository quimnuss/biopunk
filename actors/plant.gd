extends StaticBody3D
class_name BallPlant
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var age_timer : Timer = $AgeTimer

var highlight_material : Material

enum Ages { YOUNG, ADULT, OLD, ANCIENT, DEAD}

var age : Ages = Ages.YOUNG

signal picked_up(actor : Node3D)

func _ready():
    highlight_material = mesh_instance_3d.material_overlay
    self.scale = 0.5*Vector3.ONE


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

func to_young():
    var tween : Tween = create_tween()
    var new_scale := 0.5*Vector3.ONE
    tween.tween_property(self, "scale", new_scale, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.play()
    age = Ages.YOUNG
    
func to_ancient():
    var tween : Tween = create_tween()
    var new_scale := 2*Vector3.ONE
    tween.tween_property(self, "scale", new_scale, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.play()
    age = Ages.ANCIENT

func to_adult():
    var tween : Tween = create_tween()
    var new_scale := Vector3.ONE
    tween.tween_property(self, "scale", new_scale, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
    tween.play()
    age = Ages.ADULT


func _on_age_timer_timeout():
    match age:
        Ages.YOUNG:
            to_adult()
        Ages.ADULT:
            to_ancient()
        Ages.ANCIENT:
            to_young()
        _:
            pass
            
        
        
