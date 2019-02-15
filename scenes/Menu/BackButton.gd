extends MenuButton

func _ready():
    connect("pressed", self, "on_pressed")

#TO-DO
func on_pressed():
    #back to running game if in progress. else - load the last save
    pass
