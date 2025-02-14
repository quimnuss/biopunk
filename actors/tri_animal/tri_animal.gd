extends CharacterBody3D
class_name TriAnimal

@onready var moveset: Moveset = $Moveset
@onready var fsm: StateMachine = $FSM

@onready var sensor : Area3D = $Sensor
@onready var reach_sensor : Area3D = $ReachSensor

const SPEED = 2
const HUNGER_SPEED = 5

@export var fsm_state : String #State.StateID


signal info(msg : String)

var hunger : float = 100

func _ready():
    sensor.body_entered.connect(_on_sensor_body_entered)
    reach_sensor.body_entered.connect(_on_reach_sensor_body_entered)


func _physics_process(delta: float) -> void:
    hunger += HUNGER_SPEED * delta
    fsm.physics_update(delta)
    fsm_state = fsm.state.name
    

func _on_sensor_body_entered(body: Node3D) -> void:
    if body is BallPlant and hunger > 100:
        moveset.target = body
        fsm.to_state(State.StateID.TOEAT)


func _on_reach_sensor_body_entered(body: Node3D) -> void:
    if body is WorldBounds:
        fsm.state.id = State.StateID.REVERSE
    elif body is BallPlant and hunger > 100:
        if fsm.state.id == State.StateID.TOEAT:
            fsm.to_state(State.StateID.EAT)
            # food hurtbox
            body.hurt()
