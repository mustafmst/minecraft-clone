extends Spatial

func _ready():
    pass

func _process(delta):
    # Called every frame. Delta is time since last frame.
    # Update game logic here.
    var player = get_parent().get_node("Player").translation
    if player != null:
        translation = Vector3(player.x, 0, player.z)
