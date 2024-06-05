extends Camera2D

var camera_speed: float = 200.0

# Called when the node enters the scene tree for the first time.
func _ready():
	var map = get_parent()
	if map.size is Vector2:
		limit_top = 0
		limit_left = 0
		limit_bottom = map.size.y
		limit_right = map.size.x

