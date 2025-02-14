extends StaticBody3D
class_name BallPlant
@onready var mesh_instance_3d: MeshInstance3D = $MeshInstance3D
@onready var age_timer : Timer = $AgeTimer
@onready var spawner: Spawner = $Spawner

var highlight_material : Material

enum Ages { YOUNG, ADULT, OLD, ANCIENT, DEAD}

var age : Ages = Ages.YOUNG

var can_spawn : bool = true
var creator : Node3D

signal picked_up(actor : Node3D)

static func Instantiate(can_spawn : bool = true, creator : Node3D = null) -> BallPlant:
    var plant : BallPlant = preload('res://actors/plant.tscn').instantiate()
    plant.can_spawn = can_spawn
    plant.creator = creator
    return plant
    

func _ready():
    if not can_spawn:
        spawner.spawn_timer.stop()
    highlight_material = mesh_instance_3d.material_overlay
    
    if age == Ages.YOUNG:
        self.scale = 0.5*Vector3.ONE
    
    if  not is_instance_valid(get_viewport().get_camera_3d()):
        print('no camera detected, adding camera and light')
        var cam_light = preload("res://environment/default_setup.tscn").instantiate()
        get_node("/root").add_child.call_deferred(cam_light)

var sign : int = -1
var elapsed : float = 1
var initial_position : Vector3

func _physics_process(delta: float) -> void:
    if name == 'Plant':
        var direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
        if direction != Vector2.ZERO:
            self.global_position += 0.01*Vector3(direction.x, 0, direction.y)
    return
    #self.scale = Vector3.ONE*(1 + sign*0.1)
    elapsed -= delta
    if elapsed <= 0:
        elapsed = 3
        self.global_position = initial_position + sign*0.01*Vector3.RIGHT
        sign = -sign
    
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
            #spawner.play()
            to_adult()
        Ages.ADULT:
            to_ancient()
        Ages.ANCIENT:
            to_young()
            #spawner.stop()
        _:
            pass
        
#signal request_spawn(entity_id : Spawner.Entities, location : Vector3)

signal request_spawn(entity_id : String, location : Vector3)

func _on_spawn_timer_timeout() -> void:
    request_spawn.emit(self.scene_file_path, self.global_position)
