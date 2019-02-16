extends MenuButton

func _ready():
    connect("pressed", self, "on_pressed")

func on_pressed():
    get_tree().change_scene("res://scenes/World/World.tscn")
