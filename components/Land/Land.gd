extends Node

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
var mapGenerator
var ActiveChunk = null
var firstChunk

func _ready():
    mapGenerator = get_node("MapGenerator")
    mapGenerator.generate_map(Vector2(1080,1080),2,1,0)
    
    firstChunk = Chunk.instance().create_new(self, null, null, null, Vector2(0,0))
    self.set_active_chunk(firstChunk)
    #Debug
    print(ActiveChunk.get_2d_pos())
    for i in range(ActiveChunk.neighourChunks.size()):
        for j in range(ActiveChunk.neighourChunks[i].size()):
            var c = ActiveChunk.neighourChunks[i][j]
            print(c.get_2d_pos())
    pass


func _process(delta):
    var playerPos = get_parent().get_node("Player").translation
    var nearestChunk = get_nearest_chunk(Vector2(playerPos.x, playerPos.z))
    if nearestChunk != ActiveChunk:
        print("Player", Vector2(playerPos.x, playerPos.z))
        print("Chunk", nearestChunk.get_2d_pos())
        set_unactive_chunk(ActiveChunk)
        set_active_chunk(nearestChunk)
    pass


func get_nearest_chunk(pos):
    var nearestChunk = ActiveChunk
    var distance = pos.distance_to(nearestChunk.get_2d_pos())
    for i in range(ActiveChunk.neighourChunks.size()):
        for j in range(ActiveChunk.neighourChunks[i].size()):
            var c = ActiveChunk.neighourChunks[i][j]
            var newDistance = pos.distance_to(c.get_2d_pos())
            if  newDistance < distance :
                nearestChunk = c
                distance = newDistance
    return nearestChunk


func set_unactive_chunk(chunk):
    ActiveChunk = null
    chunk.create_neighbours()
    chunk.update_relations()
    chunk.deactivate()
    pass


func set_active_chunk(chunk):
    ActiveChunk = chunk
    chunk.activate()
    chunk.create_neighbours()
    chunk.update_relations()
    pass

