extends VehicleBody

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
	
	# Get global Player Position and rotation
	var player_position = get_global_transform().origin
	var player_direction = (get_global_transform().basis * Vector3(0,0,1)).normalized()
	player_direction.y = 0
	# Get vector pointing to next checkpoint
	var direction_to_cp = (next_checkpoint - player_position).normalized()
	direction_to_cp.y = 0
	# Get Matrices rotating to rotate that vector
	var rotation_matrix = Matrix3()
	var rotation_matrix_left = rotation_matrix.rotated(Vector3(0, 1, 0), deg2rad(5))
	var rotation_matrix_right = rotation_matrix.rotated(Vector3(0, 1, 0), deg2rad(-5))
	# Get vectors pointing a bit left and right to calculate where you need to steer
	var dir_to_cp_left = rotation_matrix_left * direction_to_cp
	var dir_to_cp_right = rotation_matrix_right * direction_to_cp
	# dots = 1 if facing at cp, dots = 0 if perpendicular to cp, dots = -1 if cp straight behind
	var vector_dot = player_direction.dot(direction_to_cp)
	var vector_dot_left = player_direction.dot(dir_to_cp_left)
	var vector_dot_right = player_direction.dot(dir_to_cp_right)
	
	# Check if a checkpoint has been reached
	if (player_position.distance_to(next_checkpoint) < 5):
		# Are there checkpoints left?
		if checkPointIndex < strecke.get_curve().get_point_count()-1:
			checkPointIndex += 1
		# Else: Next round!
		else:
			checkPointIndex = 0
		next_checkpoint = Vector3(strecke.get_curve().get_point_pos(checkPointIndex).x, 0.0, strecke.get_curve().get_point_pos(checkPointIndex).z)
	
	# Check if you are not facing somewhere near the checkpoint
	if (vector_dot < 0.9):
		# Check in what direction you need to steer
		if (vector_dot_left > vector_dot_right and get_steering() > -steer_max):
			set_steering(get_steering()-steer_inc)
			mesh_lenkrad.rotate(Vector3(0,1,0), -steer_inc)
		elif (vector_dot_right > vector_dot_left and get_steering() < steer_max):
			set_steering(get_steering()+steer_inc)
			mesh_lenkrad.rotate(Vector3(0,1,0), steer_inc)
	# Were driving towards the checkpoint, stay that way!
	else:
		set_steering(0)
	
	force = max_force
	
	if (force > 0):
		force-=1
	else:
		force= 0
		
	anim_player.set_speed(force/25)
