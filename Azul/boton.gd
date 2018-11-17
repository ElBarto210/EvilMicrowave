extends Sprite


func _on_boon00_body_entered(body):
	if visible == true:
		$Sound.playing = true
	visible = false
	pass # replace with function body


func _on_dead05_body_entered(body):
	visible = true
	pass # replace with function body


func _on_dead07_body_entered(body):
	visible = true
	pass # replace with function body
