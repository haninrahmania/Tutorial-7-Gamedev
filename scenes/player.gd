extends CharacterBody3D

@export var speed: float = 10.0
@export var sprint_speed: float = 15.0
@export var crouch_speed: float = 3.0
@export var acceleration: float = 5.0
@export var gravity: float = 9.8
@export var jump_power: float = 5.0
@export var mouse_sensitivity: float = 0.3
@export var interact_distance: float = 10.0

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D
@onready var raycast: RayCast3D = $Head/Camera3D/RayCast3D
@onready var inventory: Node = $Inventory

var camera_x_rotation: float = 0.0
var is_crouching: bool = false
var inventory_items: Array = []

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		head.rotate_y(deg_to_rad(-event.relative.x * mouse_sensitivity))

		var x_delta = event.relative.y * mouse_sensitivity
		camera_x_rotation = clamp(camera_x_rotation + x_delta, -90.0, 90.0)
		camera.rotation_degrees.x = -camera_x_rotation

	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	if Input.is_action_just_pressed("interact"):
		print("im interacting")
		try_interact_item()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

func _physics_process(delta):
	var movement_vector = Vector3.ZERO

	if Input.is_action_pressed("movement_forward"):
		movement_vector -= head.basis.z
	if Input.is_action_pressed("movement_backward"):
		movement_vector += head.basis.z
	if Input.is_action_pressed("movement_left"):
		movement_vector -= head.basis.x
	if Input.is_action_pressed("movement_right"):
		movement_vector += head.basis.x

	movement_vector = movement_vector.normalized()

	# Cek apakah player sedang crouch atau sprint
	if Input.is_action_pressed("crouch"):
		is_crouching = true
		camera.position.y = lerp(camera.position.y, -0.5, delta * 10) # Turunkan kamera
		velocity.x = lerp(velocity.x, movement_vector.x * crouch_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, movement_vector.z * crouch_speed, acceleration * delta)
	elif Input.is_action_pressed("sprint") and not is_crouching:
		velocity.x = lerp(velocity.x, movement_vector.x * sprint_speed, acceleration * delta)
		velocity.z = lerp(velocity.z, movement_vector.z * sprint_speed, acceleration * delta)
	else:
		is_crouching = false
		camera.position.y = lerp(camera.position.y, 0.0, delta * 10) # Kembalikan kamera
		velocity.x = lerp(velocity.x, movement_vector.x * speed, acceleration * delta)
		velocity.z = lerp(velocity.z, movement_vector.z * speed, acceleration * delta)

	# Terapkan gravitasi
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Melompat
	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_crouching:
		velocity.y = jump_power

	move_and_slide()
	
func try_interact_item():
	#draw_raycast()  # debug

	if raycast.is_colliding():
		var target = raycast.get_collider()

#		debug
		print("Raycast fired!")
		print("Detected: ", target.name)

		if target.has_method("interact"):
			print("Interacting with: ", target.name)
			target.interact(self)
		else:
			print("Object does not have interact method.")
	else:
		print("No object detected.")

func add_to_inventory(item_name: String):
	inventory_items.append(item_name)
	print("Item diambil: ", item_name, " | Inventory: ", inventory_items)
	
func draw_raycast():
	var from = camera.global_position
	var to = from - camera.basis.z * interact_distance
	get_world_3d().direct_space_state.intersect_ray(PhysicsRayQueryParameters3D.create(from, to))
	# Menggambar garis dari kamera ke arah depan
	var debug_line = ImmediateMesh.new()
	debug_line.surface_begin(Mesh.PRIMITIVE_LINES)
	debug_line.surface_add_vertex(from)
	debug_line.surface_add_vertex(to)
	debug_line.surface_end()

	var mesh_instance = MeshInstance3D.new()
	mesh_instance.mesh = debug_line
	add_child(mesh_instance)
	print("Raycast from: ", from, " to: ", to)
