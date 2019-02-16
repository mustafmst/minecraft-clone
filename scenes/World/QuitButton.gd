extends MenuButton

func _ready():
    connect("pressed", self, "on_pressed")

func on_pressed():
    if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
        Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    else:
        Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
    get_tree().change_scene("res://scenes/Menu/Menu.tscn")
    