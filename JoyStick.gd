#Author: Rodrigo Torres
#Version: 1.0
#For Godot 3.0
extends Node2D

onready var bigCircle = get_node("BigCircle")
onready var smallCircle = get_node("SmallCircle")
onready var Player = get_node("../").get_node("Player")

var playerVel = 250

var resetPosCircle
var pressed = 0
var bigCircleSize
var isDrag

var smallCirclePos

func _ready():
	bigCircleSize = 128
	resetPosCircle = smallCircle.get_global_position()

func _input(event):
	
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
		if smallCirDist > bigCircleSize/2:
			smallCircle.set_position(dirBigCir_dirEnvt.normalized() * 65)
		else:
			smallCircle.set_global_position(event.position)
			
	if isReleased:
		pressed = 0
		smallCircle.set_global_position(resetPosCircle)


func _process(delta):
		var playerPosG = Player.get_global_position()
		#normalized() reduz o valor do modulo(magnitude) do vetor para 1 mantendo a direcao e sentido
		Player.set_global_position(playerPosG + smallCirclePos.normalized() * playerVel * delta)

#=========== Return event input states ===========

func _on_Drag(event):
	if event is InputEventMouseMotion:
		return true
	elif event is InputEventScreenDrag:
		return true

func _on_Pressed(event):
	if event is InputEventMouseButton:
		pressed = 1
	elif event is InputEventScreenTouch:
		pressed = 1

func _on_Released(event):
	if event is InputEventScreenTouch:
		return !event.pressed
	elif event is InputEventMouseButton:
		return !event.pressed
