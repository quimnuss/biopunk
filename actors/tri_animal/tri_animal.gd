extends CharacterBody3D

@onready var moveset: Moveset = $Moveset
@onready var fsm: Node = $FSM

@onready var sensor : Area3D = $Sensor
@onready var reach_sensor : Area3D = $ReachSensor

const SPEED = 7
const HUNGER_SPEED = 10

signal info(msg : String)

var hunger : float = 100

func _ready():
    sensor.body_entered.connect(_on_sensor_body_entered)
    reach_sensor.body_entered.connect(_on_reach_sensor_body_entered)


func _physics_process(delta: float) -> void:
    hunger += HUNGER_SPEED * delta
    fsm.papa_physics_process(delta)
    

func _on_sensor_body_entered(body: Node3D) -> void:
    if body is BallPlant and hunger > 100:
        moveset.target = body
        fsm.state = fsm.State.TOEAT


func _on_reach_sensor_body_entered(body: Node3D) -> void:
    if body is WorldBounds:
        fsm.state = fsm.State.REVERSE
    elif body is BallPlant and hunger > 100:
        if fsm.state == fsm.State.TOEAT:
            fsm.state = fsm.State.EAT
            # food hurtbox
            body.hurt()
