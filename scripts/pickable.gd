extends Node


func _on_mouse_entered() -> void:
    var papa : Node3D = get_parent()
    print('entered')
    papa.highlight()

func _on_mouse_exited() -> void:
    var papa : Node3D = get_parent()
    papa.dehighlight()
