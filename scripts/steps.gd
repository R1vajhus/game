extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
var acceleration = 2.0

func _process(delta):
	# Пример ускорения звука при нажатии на кнопку
	if Input.is_action_pressed("accelerate_sound"):
		pitch_scale += acceleration * delta
