extends Spatial

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
const ChunkSize = 10
var neighourChunks = [[null, null, null],
                      [null, null, null],
                      [null, null, null]]

# need to implement here chunk generation
func generate_map():
    var map = []
    for i in range(ChunkSize):
        var tmp = []
        for j in range(ChunkSize):
            tmp.push_back(1)
        map.push_back(tmp)
    return map


# Creating new Chunk
static func create_new(landScene, parentChunk, parentX, parentY, pos):
    var newChunk = Chunk.instance()
    newChunk.translate(Vector3(pos.x, 0, pos.y))
    if parentChunk != null:
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
    self.add_neighbour(self,1,1)
    pass


func put_blocks(pos, height):
    var chunkPos = self.translation
    for h in range(height):
        var item = Block.instance()
        item.translate(Vector3((chunkPos.x*ChunkSize)+pos.x, h, (chunkPos.z*ChunkSize)+pos.y))
        add_child(item)
    pass


# Helper methods
func add_neighbour(chunk, x, y):
    neighourChunks[x][y] = chunk
    pass


func set_as_active():
    
    pass

