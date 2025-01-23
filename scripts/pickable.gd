extends Node

var papa : Node3D

func _ready():
    papa = get_parent()
    

func _on_mouse_entered() -> void:
    print('entered')
    papa.highlight()

func _on_mouse_exited() -> void:
    papa.dehighlight()



func _on_collision_area_input_event(_camera: Node, event: InputEvent, event_position: Vector3, normal: Vector3, shape_idx: int):
    if event.is_action_pressed("select"):
        get_viewport().set_input_as_handled()
        papa.pickup()
    elif event.is_action_released("select"):
        get_viewport().set_input_as_handled()
        papa.release()
