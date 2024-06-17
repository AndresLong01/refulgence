extends Node2D
class_name WaterBody

# Spring factor for Hooke's Law
# These are passed down to the function defined in the WaterSpring Class
@export var stiffness: float = 0.015
@export var dampening: float = 0.03
@export var spread: float = 0.2

# Distance in pixels between springs
@export var distance_between: int = 16
@export var spring_number: int = 10
@export var spring_scene: PackedScene

# Water Render
@export var depth: int = 64
@onready var water_polygon: Polygon2D = $WaterPolygon

# Edge Smoothing
@onready var smooth_path = $SmoothPath
@export var border_thickness = 1.1

# Collision Detection
@onready var collision_shape_2d = $Area2D/CollisionShape2D
@onready var area_2d = $Area2D

var target_height: float = global_position.y
var bottom: float

# How many Springs you have per body of water
var springs: Array[WaterSpring] = []
# How fast the wave spreads through the springs
var passes: int = 8
# Length of body of water
var water_length: int

func _ready():
	spread = spread/1000
	bottom = target_height + depth
	# Makes sure to initialize all springs on a ready state.
	for i in range(spring_number):
		var x_position = distance_between * i
		var spring_instance: WaterSpring = spring_scene.instantiate()
		
		add_child(spring_instance)
		springs.append(spring_instance)
		spring_instance.initialize(x_position, i)
		spring_instance.set_collision_width(distance_between)
		spring_instance.connect("splash", splash)
	
	var total_length = distance_between * (spring_number - 1)
	var rectangle = RectangleShape2D.new().duplicate()
	
	var rect_position = Vector2(total_length/ 2, depth/ 2)
	var rect_size = Vector2(total_length, depth)
	
	area_2d.position = rect_position
	rectangle.size = rect_size
	collision_shape_2d.set_shape(rectangle)

func _physics_process(delta):
	for i in springs:
		i.water_update(stiffness, dampening)
	
	var left_deltas: Array = []
	var right_deltas: Array = []
	
	for i in range(springs.size()):
		left_deltas.append(0)
		right_deltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0:
				left_deltas[i] = spread * (springs[i].height - springs[i-1].height)
				springs[i-1].velocity += left_deltas[i]
			if i < springs.size() -1:
				left_deltas[i] = spread * (springs[i].height - springs[i+1].height)
				springs[i+1].velocity += left_deltas[i]
	
	new_border()
	draw_water_body()

func draw_water_body():
	var curve: Curve2D = smooth_path.curve
	var points: Array = Array(curve.get_baked_points())
	
	var water_polygon_points: Array = points
	
	var first_index: int = 0
	var last_index: int = water_polygon_points.size() - 1
	
	water_polygon_points.append(Vector2(water_polygon_points[last_index].x, bottom))
	water_polygon_points.append(Vector2(water_polygon_points[first_index].x, bottom))
	
	water_polygon_points = PackedVector2Array(water_polygon_points)
	
	water_polygon.set_polygon(water_polygon_points)

func new_border():
	var curve: Curve2D = Curve2D.new().duplicate()
	
	var surface_points: Array = []
	for i in range(springs.size()):
		surface_points.append(springs[i].position)
	
	for i in range(surface_points.size()):
		curve.add_point(surface_points[i])
	
	smooth_path.curve = curve
	smooth_path.smooth(true)
	smooth_path.queue_redraw()

func splash(index, speed):
	if index >= 0 and index < springs.size():
		springs[index].velocity += speed

func _on_area_2d_body_entered(body):
	pass # Replace with function body.
