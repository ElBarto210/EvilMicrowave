extends Area2D


func _on_boton00_body_entered(body):
	$cuerpo/hitbox.disabled = true
	$Sprite.visible = false
	$Sound.playing = true
	pass # replace with function body
