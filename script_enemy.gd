extends VehicleBody

var force = 0
var max_force = 100
var anim_player = null
var mesh_lenkrad = null
var steer_max = 0.8
var steer_inc = .02

var strecke = null

var next_checkpoint = null

var pos2d = Vector2(0,0)
var angle_to_next_checkpoint = 0

func _ready():
	set_fixed_process(true)
	anim_player = get_node("AnimationPlayer")
	mesh_lenkrad = get_node("Lenkrad")
	strecke = get_node("/root/World/WorldEnvironment/Terrain/PathStecke")
	
	next_checkpoint = Vector2(strecke.get_curve().get_point_pos(1).x, strecke.get_curve().get_point_pos(1).z)
	
	
func _fixed_process(delta):
	set_engine_force(force)
	
	
	pos2d = Vector2(get_translation().x, get_translation().z)
	#print(str(next_checkpoint))
	print(str(pos2d.angle_to(next_checkpoint)))
	
	angle_to_next_checkpoint = pos2d.angle_to(next_checkpoint)
	
	#print(str(pos2d.distance_to(next_checkpoint)))
	
	if (angle_to_next_checkpoint > 0 and get_steering() > -steer_max):
		set_steering(get_steering()-steer_inc)
		mesh_lenkrad.rotate(Vector3(0,1,0), -steer_inc)
	elif (angle_to_next_checkpoint < 0  and get_steering() < steer_max):
		set_steering(get_steering()+steer_inc)
		mesh_lenkrad.rotate(Vector3(0,1,0), steer_inc)
	else:
		set_steering(0)
	
	force = max_force
	
	if (force > 0):
		force-=1
	else:
		force= 0
		
	anim_player.set_speed(force/25)
	
	
	


