extends Camera2D

export var SPEED = 10.0
export var ZOOM_SPEED = 10.0
export var ZOOM_MARGIN = 0.1
export var ZOOM_MIN = 0.25
export var ZOOM_MAX = 3.0
export var PAN_SPEED = 15.0
#Distance for mouse movement to work
export var MARGIN_X = 200.0
export var MARGIN_Y = 200.0

var mousePos = Vector2()

var zoomFactor = 1.0
var zoomPos = Vector2()
var zooming = false

# Rectangle selection
var mousePosGlobal = Vector2()
var start = Vector2()
var startV = Vector2()
var end = Vector2()
var endV = Vector2()
var isDragging = false
onready var rectangle = $'../UI/Base/Rect'
signal area_selected

var move_to_point = Vector2()
signal start_move_selection

func _ready():
	connect("area_selected", get_parent(), "area_selected", [self])
	connect("start_move_selection", get_parent(), "start_move_selection", [self])
	pass

func _process(delta):
	#smooth movement
	var inputX = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var inputY = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	position.x = lerp(position.x, position.x + inputX * SPEED * zoom.x, SPEED * delta)
	position.y = lerp(position.y, position.y + inputY * SPEED * zoom.y, SPEED * delta)
	
	if Input.is_key_pressed(KEY_CONTROL):
		if mousePos.x < MARGIN_X:
			position.x = lerp(position.x, position.x - abs(mousePos.x - MARGIN_X)/MARGIN_X * PAN_SPEED * zoom.x, PAN_SPEED * delta)
		elif mousePos.x > OS.window_size.x - MARGIN_X:
			position.x = lerp(position.x, position.x + abs(mousePos.x - OS.window_size.x + MARGIN_X)/MARGIN_X * PAN_SPEED * zoom.x, PAN_SPEED * delta)
		if mousePos.y < MARGIN_Y:
			position.y = lerp(position.y, position.y - abs(mousePos.y - MARGIN_Y)/MARGIN_Y * PAN_SPEED * zoom.y, PAN_SPEED * delta)
		elif mousePos.y > OS.window_size.y - MARGIN_Y:
			position.y = lerp(position.y, position.y + abs(mousePos.y - OS.window_size.y + MARGIN_Y)/MARGIN_Y * PAN_SPEED * zoom.y, PAN_SPEED * delta)
				
			
	#zoom in
	zoom.x = lerp(zoom.x, zoom.x * zoomFactor, ZOOM_SPEED * delta)
	zoom.y = lerp(zoom.y, zoom.y * zoomFactor, ZOOM_SPEED * delta)
	
	zoom.x = clamp(zoom.x, ZOOM_MIN, ZOOM_MAX)
	zoom.y = clamp(zoom.y, ZOOM_MIN, ZOOM_MAX)
	
	if not zooming:
		zoomFactor = 1.0
	
	# Selection rectangle
	if Input.is_action_just_pressed("ui_left_mouse_button"):
		start = mousePosGlobal
		startV = mousePos
		isDragging = true
	
	if isDragging:
		end = mousePosGlobal
		endV = mousePos
		draw_area()
	
	# When left mouse is released call WorldManager.area_selected()
	if Input.is_action_just_released("ui_left_mouse_button"):
		if startV.distance_to(mousePos) >= 0:
			end = mousePosGlobal
			endV = mousePos
			isDragging = false
			draw_area(false)
			emit_signal("area_selected")
		else:
			end = start
			isDragging = false
			draw_area(false)
	
	if Input.is_action_just_released("ui_right_mouse_button"):
		print("Start moving!")
		move_to_point = mousePosGlobal
		emit_signal("start_move_selection")
	
	pass

func _input(event):
	
	if abs(zoomPos.x - get_global_mouse_position().x) > ZOOM_MARGIN:
		zoomFactor = 1.0
		
	if abs(zoomPos.y - get_global_mouse_position().y) > ZOOM_MARGIN:
		zoomFactor = 1.0
	
	if event is InputEventMouseButton:
		if event.is_pressed():
			zooming = true
			if event.button_index == BUTTON_WHEEL_UP:
				zoomFactor -= 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
				
			elif event.button_index == BUTTON_WHEEL_DOWN:
				zoomFactor += 0.01 * ZOOM_SPEED
				zoomPos = get_global_mouse_position()
		else:
			zooming = false
	
	if event is InputEventMouse:
		mousePos = event.position
		mousePosGlobal = get_global_mouse_position()
			
	pass
	
func draw_area(s=true):
	rectangle.rect_size = Vector2(abs(startV.x - endV.x), abs(startV.y - endV.y))
	var pos = Vector2()
	pos.x = min(startV.x, endV.x)
	pos.y = min(startV.y, endV.y)
	pos.y -= OS.window_size.y
	rectangle.rect_position = pos
	rectangle.rect_size *= int(s) #true or false
	
	
	
	
	
	
	
	
	
	
	
	
	
	