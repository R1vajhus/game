extends CharacterBody3D

var SPEED = 5.0
const JUMP_VELOCITY = 5.0
const cam_move = 5

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

const sens = 0.002


@onready var head = $Head
@onready var cam = $Head/Camera3D
@onready var arms_run = $Head/Camera3D/arms/arms_run
@onready var arms_stay = $Head/Camera3D/arms/arms_stay
@onready var legs_run = $legs/legs_run
@onready var legs_stay = $legs/legs_stay

func _ready():
	if not is_multiplayer_authority(): return
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	cam.current = true
	
func _enter_tree():	
	set_multiplayer_authority(str(name).to_int())
func _unhandled_input(event):
	if not is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * sens)
		cam.rotate_x(-event.relative.y * sens)
		cam.rotation.x = clamp(cam.rotation.x, deg_to_rad(-75), deg_to_rad(80))
		$legs.rotate_y(-event.relative.x * sens)

var sound_played = false

func play_sound_once():
	if is_on_floor() and not sound_played:
		$jump_end.play()
		sound_played = true


func _on_Sound_finished():
	sound_played = false

func _physics_process(delta):
	if not is_multiplayer_authority(): return
	var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	
	if not is_on_floor():
		velocity.y -= gravity * delta
		set_process_input(true)
		_on_Sound_finished()
		arms_run.stop()
		legs_run.stop()
		arms_stay.play("default")
	elif is_on_floor():
		play_sound_once()
	

		
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if $jump_start.playing == false:
			$jump_start.play()
	
		
	if Input.is_action_pressed("run") and is_on_floor():
		SPEED = 10.0
	else:
		SPEED = 5.0

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		if is_on_floor():
			if $steps.playing == false:
				$steps.set_pitch_scale(0.9)
				$steps.play()
			arms_stay.stop()
			arms_run.play('default')
			arms_run.set_speed_scale(0.5)
			legs_run.play('default')
			legs_run.set_speed_scale(1)
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		legs_stay.play('default')
		arms_run.stop()
		legs_run.stop()
		arms_stay.play('default')
		arms_stay.set_speed_scale(0.1)
		$steps.stop()
		velocity.x = 0.0
		velocity.z = 0.0
	if SPEED == 10.0:
		$steps.set_pitch_scale(1.5)
		legs_run.set_speed_scale(2.0)
		arms_run.set_speed_scale(1)
		arms_stay.stop()
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
	if input_dir.x > 0:
		cam.rotation.z = lerp_angle(cam.rotation.z, deg_to_rad(-2), 0.05)
	elif input_dir.x < 0:
		cam.rotation.z = lerp_angle(cam.rotation.z, deg_to_rad(2), 0.05)
	else:
		cam.rotation.z = lerp_angle(cam.rotation.z, deg_to_rad(0), 0.05)

	move_and_slide()
