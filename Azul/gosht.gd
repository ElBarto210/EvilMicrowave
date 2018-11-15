extends Node2D

onready var player = get_node("../../Mundo_00/Player")

func _ready():
	position = player.position
	pass

func _process(delta):
	if (player.timer3 == 0):
		get_parent().remove_child(self)
	pass
