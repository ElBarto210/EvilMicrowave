extends Sprite

var id = 0

#func _ready():
#
#	if self.has_node("id1"):
#		id = 1
#	elif self.has_node("id2"):
#		id = 2
#	elif self.has_node("id3"):
#		id = 3
#
#	pass

func _on_activador00_body_entered(body):
	visible = false
	id = 1
	body.activate(id)
	pass # replace with function body


func _on_activador01_body_entered(body):
	visible = false
	id = 2
	body.activate(id)
	pass # replace with function body


func _on_activador02_body_entered(body):
	visible = false
	id = 3
	body.activate(id)
	pass # replace with function body
