extends Camera2D

var following: Node2D = null

var camera_speed = 500

var limits: Vector2 = Vector2(0, 0):
	set(value):
		limit_top = 0
		limit_left = 0
		limit_bottom = int(value.y)
		limit_right = int(value.x)
		limits = value
	get:
		return limits

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func follow(node: Node2D):
	following = node

var zoom_min = Vector2(1, 1)
var zoom_max = Vector2(2, 2)

var zoom_speed = Vector2(1.01, 1.01)

var screen_width = 1920
var screen_height = 1080

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				update_zoom(zoom*zoom_speed)

			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				update_zoom(zoom/zoom_speed)

func update_zoom(new_zoom: Vector2):
	var mouse_x = get_viewport().get_mouse_position().x
	var mouse_y = get_viewport().get_mouse_position().y
	var pixels_difference_x = (screen_width / zoom.x) - (screen_width / new_zoom.y)
	var pixels_difference_y = (screen_height / zoom.y) - (screen_height / new_zoom.y)
	var side_ratio_x = (mouse_x - (screen_width / 2.0)) / screen_width
	var side_ratio_y = (mouse_y - (screen_height / 2.0)) / screen_height
	position.x += pixels_difference_x * side_ratio_x
	position.y += pixels_difference_y * side_ratio_y
	zoom = new_zoom

func _process(delta):
	if following != null:
		position = following.position
	else:
		var velocity = Input.get_vector("left", "right", "up", "down")
		position += velocity * camera_speed * delta
		
	var center = get_screen_center_position()
	if position != center:
		position = center
