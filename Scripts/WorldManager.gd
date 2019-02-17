extends Node2D

var selected_units = []
#runs before ready()
onready var ButtonScene = preload("res://Scenes/Button.tscn")
var buttons = []
var units = []

func Select_Unit(unit):
	if not selected_units.has(unit):
		selected_units.append(unit)
	print(selected_units.size())	
	create_buttons()
	
func Deselect_Unit(unit):
	if selected_units.has(unit):
		selected_units.erase(unit)
	print(selected_units.size())	
	create_buttons()

func deselect_all():
	while selected_units.size() > 0:
		selected_units[0].set_selected(false)
	
func create_buttons():
	delete_buttons()
	for unit in selected_units:
		if not buttons.has(unit.name):
			var but = ButtonScene.instance()
			but.connect_me(self, unit.name)
			but.rect_position = Vector2(buttons.size() * 64 + 32, -64)
			$"UI/Base".add_child(but)
			buttons.append(but.name)
			
	
func delete_buttons():
	for but in buttons:
		if $"UI/Base".has_node(but):
			var b = $"UI/Base".get_node(but)
			b.queue_free()
			$"UI/Base".remove_child(b)
	buttons.clear()
	
func was_pressed(obj):
	for unit in selected_units:
		if unit.name == obj.name:
			unit.set_selected(false)
			break
			
func get_units_in_area(area):
	var u = []
	print(units)
	print(area)
	for unit in units:
		if unit.position.x > area[0].x and unit.position.x < area[1].x:
			if unit.position.y > area[0].y and unit.position.y < area[1].y:
				u.append(unit)
	return u

func area_selected(obj):
	var start = obj.start
	var end = obj.end
	var area = []
	area.append(Vector2(min(start.x, end.x), min(start.y, end.y)))
	area.append(Vector2(max(start.x, end.x), max(start.y, end.y)))
	var ut = get_units_in_area(area)
	if not Input.is_key_pressed(KEY_SHIFT):
		deselect_all()
	for u in ut:
		u.set_selected(!u.selected)
	
	
func _ready():
	units = get_tree().get_nodes_in_group("units")
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass
