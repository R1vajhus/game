extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	var transform = $".".transform

# Устанавливаем новую точку вращения (например, на 1 единицу вверх по оси Y)
	var new_pivot = Vector3(0, 1, 0)
	transform.origin = new_pivot

	# Применяем новый Transform объекту Node3D
	$".".transform = transform
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
