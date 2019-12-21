#Author: Rodrigo Torres
#Version: 1.1.0
#For Godot 3.x
# Module used to control a joystick made of two circles.
# The position of the joystick is fixed if controlled by the mouse.
# It's under the finger if controlled by touch
extends Node2D
signal move

onready var big_circle = get_node("BigCircle")
onready var small_circle = get_node("SmallCircle")
onready var big_circle_radius = big_circle.texture.get_size().x / 2	
var input_ongoing = false
	
func ready():
	# need to test
	if OS.has_touchscreen_ui_hint():
		self.visible=false
func _input(event):
	# If it's a touch event (pressed, released)
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		if not event.pressed:
			# Stop moving.
			emit_signal('move', Vector2())
			# Reset joystick position
			small_circle.global_position = big_circle.global_position
			# Stop tracking position 
			input_ongoing = false
			# If touch screen, hide the control
			if event is InputEventScreenTouch:
				self.visible = false
			return
		else:
			# Start tracking position
			input_ongoing = true
			# If touch screen, show control under the finger
			if event is InputEventScreenTouch:
				self.visible = true
				self.position = event.position
			return
	# Move event: set joystick position
	if (event is InputEventMouseMotion or event is InputEventScreenDrag) and input_ongoing:
		var motion_vector = event.position - big_circle.get_global_position()
		if motion_vector.length() > big_circle_radius:
			small_circle.set_position(motion_vector.normalized() * big_circle_radius)
		else:
			small_circle.set_global_position(event.position)

func _process(delta):
	if input_ongoing:
		var vector = small_circle.position / big_circle_radius
		emit_signal("move", vector*vector*vector)
