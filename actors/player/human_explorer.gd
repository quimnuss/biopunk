extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func idle():
    animation_player.play('idle')

func run():
    animation_player.play('run')
