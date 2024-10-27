extends Area3D

@export var power_vector : Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	print("test")
	#$Particles.process_material.direction = power_vector.limit_length(2.0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_area_entered():
	pass

func _on_body_entered(body):
	print("triggered")
