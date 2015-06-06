
extends VehicleBody

var force = 0
var max_force = 100
var anim_player = null
var mesh_lenkrad = null
var steer_max = 0.8
var steer_inc = .02

func _ready():
	set_fixed_process(true)
	anim_player = get_node("AnimationPlayer")
	mesh_lenkrad = get_node("Lenkrad")
	
func _fixed_process(delta):
	set_engine_force(force)
	
	
	if (Input.is_action_pressed("steer_left") and get_steering() > -steer_max):
		set_steering(get_steering()-steer_inc)
		mesh_lenkrad.rotate(Vector3(0,1,0), -steer_inc)
	if (Input.is_action_pressed("steer_right") and get_steering() < steer_max):
		set_steering(get_steering()+steer_inc)
		mesh_lenkrad.rotate(Vector3(0,1,0), steer_inc)
	
	if (Input.is_action_pressed("pedal_down")):
		force = max_force
	
	if (force > 0):
		force-=1
	else:
		force= 0
		
	anim_player.set_speed(force/25)
	
	
	

