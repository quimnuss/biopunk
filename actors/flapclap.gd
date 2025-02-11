extends CharacterBody3D

@onready var sensor: Area3D = $Sensor
@onready var reach_sensor: Area3D = $ReachSensor
@onready var moveset: Moveset = $Moveset

@onready var fsm: StateMachine = $FSM

@export var fsm_state : String #State.StateID

@export var edible_actors : Array

const SPEED = 5.0

signal info(msg : String)

func _physics_process(delta: float) -> void:
    fsm.physics_update(delta)
    fsm_state = fsm.state.name


func _on_sensor_body_entered(body: Node3D) -> void:
    if body is TriAnimal:
        moveset.target = body
        fsm.to_state(State.StateID.TOEAT)
            


func _on_reach_sensor_body_entered(body: Node3D) -> void:
    if body is WorldBounds:
        fsm.to_state(State.StateID.REVERSE)
        pass
