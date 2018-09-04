extends Node2D

var joystickVector
var screensize
export var speed = 400

func _ready():
	get_parent().get_node('JoyStick').connect('move', self, '_on_JoystickMove')
	screensize = get_viewport_rect().size

func _process(delta):
	move(delta)

func move(delta):
	var velocity = Vector2()
	var nextPosition = position

	if joystickVector and joystickVector.length() != 0:
		velocity += joystickVector
	if velocity.length() > 0:
		velocity = velocity * speed
	
	nextPosition += velocity * delta
	nextPosition.x = clamp(nextPosition.x, 0, screensize.x)
	nextPosition.y = clamp(nextPosition.y, 0, screensize.y)

	position = nextPosition

func _on_JoystickMove(vector):
	joystickVector = vector