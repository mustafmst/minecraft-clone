extends Node

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
var neighourChunks = [[null, null, null],
                      [null, null, null],
                      [null, null, null]]

# need to implement here chunk generation
func generate_map():
    var map = []
    for i in range(10):
        var tmp = []
        for j in range(10):
            tmp.push_back(1)
        map.push_back(tmp)
    return map


# Creating new Chunk
static func create_new(landScene, parentChunk, parentX, parentY):
    var newChunk = Chunk.instance()
    newChunk.add_neighbour(parentChunk, parentX, parentY)
    landScene.add_child(newChunk)
    return newChunk


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


# Helper methods
func add_neighbour(chunk, x, y):
    if(chunk != self && x != 1 && y != 1):
        neighourChunks[x][y] = chunk
    pass


