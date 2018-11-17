extends Node

func _ready():
	$Song.playing = true
	pass
	
func _process(delta):
	if $Song.playing == false && $SongCredits.playing == false:
		$Song.playing = true
	pass

func _on_ActivadorSonido_body_entered(body):
	if body.name == "Player":
		$Song.playing = false
		$SongCredits.playing = true
	pass # replace with function body
