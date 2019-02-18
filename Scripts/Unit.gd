extends KinematicBody2D

export var selected = false
onready var box = $Box 
onready var label = $Name
onready var bar = $Bar 

export var speed = 100
var move_p = false
var to_move = Vector2()
var path = PoolVector2Array()
var initialPosition = Vector2()

signal was_selected
signal was_deselected

func _ready():
	# Connect a signal was_selected to parent (WorldManager) method (Select_Unit) 
	# as soon as the unit is spawned on the map, only creates connection and doesnt 
	# instantly call said method WorldManager.Select_Unit()
	connect("was_selected", get_parent(), "Select_Unit")
	connect("was_deselected", get_parent(), "Deselect_Unit")
	# Run it once to set the children visibilities
	set_selected(selected)
	# name is the node name the scene inspector
	label.text = name
	bar.value = randi() % 90 + 10
	
	pass

func set_selected(value):
	print("set_selected to: " + str(value))
	selected = value
	box.visible = value
	label.visible = value
	bar.visible = value
	
	# Emit the signals hence call the the WorlManager.Select_Unit() 
	# method with the parameter self 
	if selected:
		emit_signal("was_selected", self)
	else:
		emit_signal("was_deselected", self)

func _process(delta):	
	if move_p:
		path = get_viewport().get_node("World/nav").get_simple_path(position, to_move + Vector2(randi()%100, randi()%100))
		initialPosition = position
		move_p = false
	if path.size() > 0:
		move_towards(initialPosition, path[0], delta)
	pass
	
func move_towards(pos, point, delta):
	var v = (point - pos).normalized()
	v *= delta * speed
	position += v
	if position.distance_squared_to(point) < 9:
		path.remove(0)
		initialPosition = position

func move_unit(point):
	to_move = point
	move_p = true


func _on_Unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				set_selected(!selected)
	pass
