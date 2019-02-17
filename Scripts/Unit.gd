extends KinematicBody2D

export var selected = false
onready var box = $Box 
onready var label = $Name
onready var bar = $Bar 

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
	pass


func _on_Unit_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.is_pressed():
			if event.button_index == BUTTON_LEFT:
				set_selected(!selected)
	pass
