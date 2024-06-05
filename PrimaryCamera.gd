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

var zoom_min = Vector2(0.25, 0.25)
var zoom_max = Vector2(4, 4)
var zoom_speed = Vector2(1.03, 1.03)

func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == MOUSE_BUTTON_WHEEL_UP:
				update_zoom(zoom*zoom_speed)

			if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
				update_zoom(zoom/zoom_speed)

func update_zoom(new_zoom: Vector2):
	var viewport_rect = get_viewport_rect().size
	var min_zoom = (viewport_rect/limits).clamp(zoom_min, zoom_max)
	var min_zoom_factor = maxf(min_zoom.x, min_zoom.y)
	new_zoom = new_zoom.clamp(Vector2(min_zoom_factor, min_zoom_factor), zoom_max)
	if new_zoom == zoom:
		return
	var mouse_x = get_viewport().get_mouse_position().x
	var mouse_y = get_viewport().get_mouse_position().y
	var pixels_difference_x = (viewport_rect.x / zoom.x) - (viewport_rect.x / new_zoom.y)
	var pixels_difference_y = (viewport_rect.y / zoom.y) - (viewport_rect.y / new_zoom.y)
	var side_ratio_x = (mouse_x - (viewport_rect.x / 2.0)) / viewport_rect.x
	var side_ratio_y = (mouse_y - (viewport_rect.y / 2.0)) / viewport_rect.y
	position.x += pixels_difference_x * side_ratio_x
	position.y += pixels_difference_y * side_ratio_y
	zoom = new_zoom

func _process(delta):
	var center = get_screen_center_position()
	if position != center:
		position = center
		
	if following != null:
		position = following.position
	else:
		var velocity = Input.get_vector("left", "right", "up", "down")
		position += velocity * camera_speed * delta / zoom
