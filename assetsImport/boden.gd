
extends Spatial

var treecount = 220
var pl_baum = preload("res://assetsImport/baum.scn")

func _ready():
	for i in range(0,treecount):
		print(i)
		print("erzeuge Baum Nr [")
		var neuer_baum = pl_baum.instance()
		print("]Baum erzeugt")
		neuer_baum.translate(Vector3(rand_range(-200,200),rand_range(0.95,1.1),rand_range(-200,200)))
		neuer_baum.rotate_y(rand_range(0,1))
		
		neuer_baum.set_scale(Vector3(rand_range(0.9,1.2),rand_range(0.9,1.2),rand_range(0.9,1.2)))
		get_node(".").add_child(neuer_baum)
		


