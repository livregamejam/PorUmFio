extends RigidBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"
const MOVESPEED = 150.0
const JUMPSPEED = 100.0
const PULLFORCE = 1000.0
export var p_number = 0
var speed = Vector2()
var grounded = false

onready var corda = get_node("../Corda")

func _ready():
	# Called every time the node is added to the scene.
	# Initialization here
	set_fixed_process(true)
	set_process_input(true)
	pass
		
func _input(event):
	if event.is_action_pressed(str("jump_joy_p",p_number)) and grounded == true:
		var jump = JUMPSPEED*(1+get_scale().x)
		set_linear_velocity(Vector2(get_linear_velocity().x, -jump ))
		grounded = false
		
	if event.is_action_pressed(str("pull_joy_p",p_number)):
		corda.pull(p_number)
		
func _fixed_process(delta):
	set_rot(0)
	
	if Input.is_action_pressed(str("left_joy_p",p_number)):
		set_linear_velocity(Vector2(-MOVESPEED, get_linear_velocity().y))	
	elif Input.is_action_pressed(str("right_joy_p",p_number)):
		set_linear_velocity(Vector2(MOVESPEED, get_linear_velocity().y))
	#else:
		#if(grounded == false):
		#	set_linear_velocity(Vector2(0, get_linear_velocity().y))
	
	apply_impulse(Vector2(), corda.getDistance(p_number))

func _on_Area2D_body_enter( body ):
	grounded = true


func _on_Area2D_body_exit( body ):
	grounded = false
	
func moveToPlayer(var pos):
	var force
	
	force = (pos - get_pos())
	force = force.normalized()
	
	apply_impulse(Vector2(), force*PULLFORCE) 