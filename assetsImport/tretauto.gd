
extends Spatial

var speed = 0
export var acceleration = .1
export var deceleration = 1

var anim_player = null

func _ready():
	anim_player = get_node("AnimationPlayer")
	speed = 0
	set_process(true)
	
	
	
func _process(delta):
	#translate(Vector3(0,0,speed*delta))
	anim_player.set_speed(speed)
	
	if (Input.is_action_pressed("pedal_down")):
		speed-=acceleration
	
		#rotate_y(.1)
		#print("ROTIEREN")

	if (speed > 0):
		speed-=(deceleration*delta)
	else:
		speed = 0
		
	


