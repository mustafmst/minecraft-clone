extends Node

func _ready():
    set_process(true)

#TO-DO
func _process(delta):
    if Input.is_action_pressed("ui_cancel"):
        get_tree().quit()
    #on escape - back to running game if exists. if none - quit

#img source: https://pixabay.com/pl/minecraft-wsch%C3%B3d-s%C5%82o%C5%84ca-g%C3%B3ra-wody-655163/

#font source: https://www.fontspace.com/heaven-castro/pixel-miners
