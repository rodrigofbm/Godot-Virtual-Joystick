#Author: Rodrigo Torres
#Version: 1.2
#For Godot 3.0
extends Node2D

onready var bigCircle = get_node("BigCircle")
onready var smallCircle = get_node("SmallCircle")
onready var Player = get_node("../").get_node("Player")

var playerVel = 250

var resetPosCircle
var pressed = 0
var halfBigCircleSize
var isDrag
var thereIsEventInput = false

var smallCirclePos

func _ready():
	halfBigCircleSize = 181/2
	resetPosCircle = smallCircle.get_global_position()

func _input(event):
	
	if event:
		thereIsEventInput = true
	
	var isReleased = _on_Released(event) #hold the return
	_on_Pressed(event) #verify every time
	isDrag = _on_Drag(event) #hold the return
	
		
	var eventPosx = event.position.x
	var eventPosy = event.position.y
	
	
	smallCirclePos = smallCircle.get_position()
		
	var smallCirclex = smallCirclePos.x
	var smallCircley = smallCirclePos.y
	
	var smallCirDist = sqrt( pow(smallCirclex, 2) + pow(smallCircley, 2) )
	var dirBigCir_dirEnvt = event.position - bigCircle.get_global_position()
	
	if isDrag and pressed == 1:
		smallCircle.set_global_position(event.position)
		if smallCirDist > halfBigCircleSize:
			smallCircle.set_position(dirBigCir_dirEnvt.normalized() * 64)
		else:
			smallCircle.set_global_position(event.position)
			
	if isReleased:
		pressed = 0
		smallCircle.set_global_position(resetPosCircle)


func _process(delta):
		var playerPosG = Player.get_global_position()
		#normalized() reduz o valor do módulo(magnitude) do vetor para 1 mantendo a direcao e sentido
		#normalized() reduces the magnitude of the vector to 1 while maintaining the direction
		if thereIsEventInput:
			Player.set_global_position(playerPosG + smallCirclePos.normalized() * playerVel * delta)

#=========== Return event input states ===========
func _on_Drag(event):
	if event is InputEventMouseMotion:
		return true
	elif event is InputEventScreenDrag:
		return true

func _on_Pressed(event):
	var bigCircPosx =  bigCircle.get_global_position().x
	var bigCircPosy =  bigCircle.get_global_position().y
	var eventPosx = event.position.x
	var eventPosy = event.position.y
	
	#calculating distance between (two points) event and bigCircle
	var distCirc_eventPos = sqrt( pow((eventPosx - bigCircPosx), 2) + pow((bigCircPosy - eventPosy), 2) )
	
	if event is InputEventMouseButton:
		if distCirc_eventPos <= halfBigCircleSize:
			pressed = 1
	elif event is InputEventScreenTouch:
		if distCirc_eventPos <= halfBigCircleSize:
			pressed = 1

func _on_Released(event):
	if event is InputEventScreenTouch:
		return !event.pressed
	elif event is InputEventMouseButton:
		return !event.pressed
