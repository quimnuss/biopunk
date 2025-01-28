extends Node

@export var godcamera : Camera3D
@export var playercamera : Camera3D


func _on_god_button_toggled(toggled_on : bool):
    if godcamera and toggled_on:
        godcamera.make_current()
    elif playercamera and not toggled_on:
        playercamera.make_current()
