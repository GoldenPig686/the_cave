extends Sprite2D


func _process(_delta: float) -> void:
	# Press the left mouse button to switch the flashlight on or off.
	if Input.is_action_just_pressed("shoot"):
		var light: Node2D = $PointLight2D
		light.visible = not light.visible
