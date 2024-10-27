class_name Player
extends CharacterBody3D

signal toggle_inventory()

@onready var armature = $Armature
@onready var spring_arm_pivot = $SpringArmPivot
@onready var spring_arm = $SpringArmPivot/SpringArm3D
@onready var animation_tree = $AnimationTree
@onready var interact_ray: RayCast3D = $Armature/InteractRay
@onready var crosshairs: ColorRect = $Crosshairs

@export var CROSSHAIRS: bool = false
@export var SPEED:  = 1.5
@export var JUMP_VELOCITY: = 4.5
@export var LERP_VALUE: = .15
# Higher the number the more sensitive.
@export var CAMERA_SENSITIVITY = .005

@export var inventory_data: InventoryData

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	animation_tree.active = true		
	crosshairs.visible = CROSSHAIRS
	print("Player ready")
	

#func _process(delta):
#	update_animation_parameters()

func _unhandled_input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

	if event is InputEventMouseMotion:
		spring_arm_pivot.rotate_y(-event.relative.x * CAMERA_SENSITIVITY)
		spring_arm.rotate_x(-event.relative.y * CAMERA_SENSITIVITY)
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/4, PI/4)

	#Inventory
	if Input.is_action_just_pressed("inventory"):
		toggle_inventory.emit()
	
	if Input.is_action_just_pressed("Interact"):
		interact()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	direction = direction.rotated(Vector3.UP, spring_arm_pivot.rotation.y)
	if direction:
		velocity.x = lerp(velocity.x, direction.x * SPEED, LERP_VALUE)
		velocity.z = lerp(velocity.z, direction.z * SPEED, LERP_VALUE)
		armature.rotation.y = lerp_angle(armature.rotation.y, atan2(-velocity.x, -velocity.z), LERP_VALUE)
		animation_tree["parameters/conditions/is_idle"] = false
		animation_tree["parameters/conditions/is_walk"] = true
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VALUE)
		velocity.z = lerp(velocity.z, 0.0, LERP_VALUE)
		animation_tree["parameters/conditions/is_idle"] = true
		animation_tree["parameters/conditions/is_walk"] = false

	animation_tree.set("parameters/BlendSpace1D/blend_position", velocity.length() /SPEED)

	move_and_slide()

# 40:08
func interact() -> void:
	interact_ray.visible = true
	if interact_ray.is_colliding():
		print("interact with ", interact_ray.get_collider())
		interact_ray.get_collider().player_interact()
