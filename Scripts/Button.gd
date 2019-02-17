extends TextureButton

signal was_pressed

func _pressed():
	# Calls WorldManager.was_pressed()
	emit_signal("was_pressed")
	
	pass

# Called from WorldManager when creating a button
func connect_me(worldManager, unit_name):
	name = unit_name
	$Label.text = unit_name
	# Connect a signal was_pressedto parent WorldManager method was_pressed()
	connect("was_pressed", worldManager, "was_pressed", [self])
	

func _ready():
	
	pass

func _process(delta):
	
	
	pass