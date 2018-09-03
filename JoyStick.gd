extends Node2D

signal move

onready var bigCircle = $BigCircle
onready var smallCircle = $SmallCircle

var resetPosCircle
var pressed = 0
var halfBigCircleSize
var thereIsEventInput = false
var vectorToEmit
var bigCircPos
var distance

func _ready():
	halfBigCircleSize = bigCircle.texture.get_size().x / 2
	updateCachedCirclesPositions()

func _input(event):
	if event is InputEventKey:
		return
	
	_on_Pressed(event)
	
	if event is InputEventScreenTouch:
		toggleVisible(event.pressed)
		setSelfPosition(event.position)
		updateCachedCirclesPositions()
		if not event.pressed:
			emit_signal_move(Vector2(0, 0))
			return

	if getIsDrag(event) and pressed == 1:
		var dirBigCir_dirEnvt = event.position - bigCircle.get_global_position()
		distance = getDistance(dirBigCir_dirEnvt.x, 0, dirBigCir_dirEnvt.y, 0)
		if distance > halfBigCircleSize:
			smallCircle.set_position(dirBigCir_dirEnvt.normalized() * halfBigCircleSize)
		else:
			smallCircle.set_global_position(event.position)
			
	if isReleased(event):
		pressed = 0
		smallCircle.set_global_position(resetPosCircle)

	vectorToEmit = smallCircle.get_position()
	thereIsEventInput = true if event else false

func _process(delta):
		#normalized() reduces the magnitude of the vector to 1 while maintaining the direction
		if thereIsEventInput and vectorToEmit:
			emit_signal_move(vectorToEmit / halfBigCircleSize)

func toggleVisible(value):
	self.visible = value

func setSelfPosition(position):
	self.position = position
	smallCircle.set_global_position(position)

func updateCachedCirclesPositions():
	resetPosCircle = smallCircle.get_global_position()
	bigCircPos = bigCircle.get_global_position()

func easing(t):
	return t*t*t

func emit_signal_move(value):
	emit_signal('move', easing(value))

func getIsDrag(event):
	if event is InputEventMouseMotion or event is InputEventScreenDrag:
		return true

func _on_Pressed(event):
	var eventPos = event.get_position()

	if not eventPos or not eventPos.x or not eventPos.y:
		return
	
	var distCirc_eventPos = getDistance(eventPos.x, bigCircPos.x, bigCircPos.y, eventPos.y)
	
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if distCirc_eventPos <= halfBigCircleSize:
			pressed = 1

func isReleased(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		return !event.pressed

func getDistance(x1, x2, y1, y2):
	return sqrt(pow(x1 - x2, 2) + pow(y1 - y2, 2))