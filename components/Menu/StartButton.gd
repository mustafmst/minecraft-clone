extends MenuButton

func _ready():
    connect("pressed", self, "on_pressed")

#TO-DO
func on_pressed():
    #run correct scene on game start
    get_tree().change_scene("res://components/Sky/Sky.tscn")
