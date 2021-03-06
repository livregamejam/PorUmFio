extends KinematicBody2D

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

const GRAVITY = 250.0
const MOVESPEED = 150.0
const JUMPSPEED = 100.0
const PULL_FORCE = 1000.0
var vel = Vector2()
var grounded = false
export var p_number = 0

onready var corda = get_node("../Corda")

func _ready():
	set_process(true)
	set_fixed_process(true)
	set_process_input(true)
	# Called every time the node is added to the scene.
	# Initialization here
	pass
	
func _input(event):
	if event.is_action_pressed(str("jump_joy_p",p_number)) && grounded == true:
		vel.y = -JUMPSPEED*(1+get_scale().x)
		grounded = false
		
	if event.is_action_pressed(str("pull_joy_p",p_number)):
		corda.pull(p_number)
	
func _fixed_process(delta):
	
	vel.y += delta * GRAVITY

	if Input.is_action_pressed(str("left_joy_p",p_number)): 
		vel.x = -MOVESPEED
	elif Input.is_action_pressed(str("right_joy_p",p_number)): 
		vel.x = MOVESPEED
	else:
		vel.x /= 1.3
	
		
	
	var motion = vel * delta
	move(motion)
	
	if (is_colliding()):
        var n = get_collision_normal()
        motion = n.slide(motion)
        vel = n.slide(vel)
        move(motion)

	motion = corda.getDistance(p_number)
	move(motion)
	
	#if motion.y < 0:
	#	if motion.x == 0:
	#		vel.y = 0
	#	else:
	#		vel.y -= delta * GRAVITY
	

func _on_Area2D_body_enter( body ):
	grounded = true


func _on_Area2D_body_exit( body ):
	grounded = false
	
func moveToPlayer(var pos):
	var force
	
	print("PULL")
	
	force = (pos - get_pos())
	force = force.normalized()
	
	vel += force*PULL_FORCE
	vel.x *= 1.5
