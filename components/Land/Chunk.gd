extends Node

var Block = preload("res://components/Block/Block.tscn")

func generate_map():
    var map = []
    for i in range(10):
        var tmp = []
        for j in range(10):
            tmp.push_back(1)
        map.push_back(tmp)
    return map

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _init():
    var map = generate_map()
    for x in range(map.size()):
        for y in range(map[x].size()):
            put_blocks(Vector2(x,y), map[x][y])
    pass

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func put_blocks(pos, height):
    for h in range(height):
        var item = Block.instance()
        item.translate(Vector3(pos.x, h, pos.y))
        add_child(item)
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
