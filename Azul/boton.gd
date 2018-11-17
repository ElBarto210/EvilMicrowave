extends Sprite


func _on_boon00_body_entered(body):
	if visible == true:
		$Sound.playing = true
	visible = false
	pass # replace with function body
