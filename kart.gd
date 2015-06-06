
extends VehicleBody

var mesh = get_node("tretauto")

func _ready():
	mesh = get_node("tretauto")
	set_fixed_process(true)

func _fixed_process(delta):
	
	set_engine_force(mesh.speed)

	if (Input.is_action_pressed("steer_left")):
		pass
	if (Input.is_action_pressed("steer_right")):
		pass


