extends VehicleBody

var timer = 0
var force = 0
var max_force = 100
var anim_player = null
var mesh_lenkrad = null
var steer_max = 0.8
var steer_inc = .05

var strecke = null

var next_checkpoint = null
var checkPointIndex = 0;

var current_pos = Vector3(0,0,0)
var angle_to_next_checkpoint = 0

func _ready():
	set_fixed_process(true)
	anim_player = get_node("AnimationPlayer")
	mesh_lenkrad = get_node("Lenkrad")
	strecke = get_node("/root/World/WorldEnvironment/Terrain/Path")
	
	next_checkpoint = Vector3(strecke.get_curve().get_point_pos(checkPointIndex).x, 0.0, strecke.get_curve().get_point_pos(checkPointIndex).z)
	
func _fixed_process(delta):
	set_engine_force(force)
	timer += delta
	
	current_pos = Vector3(get_translation().x, 0.0, get_translation().z)
	#var distance_to_checkpoint = current_pos.distance_to(next_checkpoint)
	var distance_to_checkpoint = Vector2(current_pos.x, current_pos.z).distance_to(Vector2(next_checkpoint.x, next_checkpoint.z))
	
	if (distance_to_checkpoint < 3):
		print("-> Waypoint reached.")
		checkPointIndex = checkPointIndex + 1
		next_checkpoint = Vector3(strecke.get_curve().get_point_pos(checkPointIndex).x, 0.0, strecke.get_curve().get_point_pos(checkPointIndex).z)
		print("--> Next Waypoint: X: " + str(next_checkpoint.x) + " Z: " + str(next_checkpoint.z))
	
	angle_to_next_checkpoint = Vector2(current_pos.x, current_pos.z).angle_to(Vector2(next_checkpoint.x, next_checkpoint.z))
	
	if timer > 1:
		print("Distance to waypoint: " + str(distance_to_checkpoint))
		print("  Angle to waypoint: " + str(angle_to_next_checkpoint))
		print("  My angle: " + str(get_rotation().y))
		timer = 0
	
	#if (abs(get_rotation().y - angle_to_next_checkpoint) > 0.5):
	if (get_rotation().y < angle_to_next_checkpoint and get_steering() > -steer_max):
		set_steering(get_steering()-steer_inc)
		mesh_lenkrad.rotate(Vector3(0,1,0), -steer_inc)
	elif (get_rotation().y > angle_to_next_checkpoint and get_steering() < steer_max):
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
