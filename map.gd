extends Node2D

var size = Vector2i(4000,4000);
var texture: Texture2D = null
var map_texture: Texture2D
var brown = Color(0.305098, 0.130588, 0.0845098, 1)
var dark_brown = Color(0.115098, 0.140588, 0.0845098, 1)
var green = Color(0.0143, 0.222157, 0.0143, 1)

@onready var castle = $Castle;
@onready var camera = $PrimaryCamera;

# Called when the node enters the scene tree for the first time.
func _ready():
	castle.position = Vector2(randf_range(100, 900), randf_range(100, 900))
	camera.limits = size
	generate_map()
	
func generate_map():
	map_texture = NoiseTexture2D.new()
	map_texture.bump_strength = 0.1
	map_texture.width = size.x
	map_texture.height = size.y

	map_texture.color_ramp = Gradient.new()
	
	map_texture.color_ramp.colors = PackedColorArray([brown, dark_brown, green])
	map_texture.color_ramp.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	map_texture.color_ramp.offsets = [0,0.5,0.51]
	var noise = FastNoiseLite.new()
	noise.fractal_type = FastNoiseLite.FRACTAL_FBM
	noise.frequency = 0.001
	map_texture.noise = noise
	map_texture.changed.connect(queue_redraw)

func _draw():
	if map_texture != null:
		draw_texture(map_texture, Vector2())
	
func _process(_delta):
	pass
