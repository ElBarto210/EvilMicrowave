extends StaticBody2D



func _on_boon00_body_entered(body):
	$puerta.visible = false
	$hitbox.disabled = true
	pass # replace with function body


func _on_dead07_body_entered(body):
	$puerta.visible = true
	$hitbox.disabled = false
	pass # replace with function body


func _on_dead05_body_entered(body):
	$puerta.visible = true
	$hitbox.disabled = false
	pass # replace with function body
