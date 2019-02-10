extends Node

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
var Chunk = preload("res://components/Land/Chunk.tscn").instance()
const MAP_SIZE = Vector2(300,300)
const MASK = [
    [1,1,1],
    [1,3,1],
    [1,1,1]
]

# Variables
var mapGenerator
var ActiveChunk = null
var firstChunk
var chunks_table = []

func _ready():
    mapGenerator = get_node("MapGenerator")
    mapGenerator.generate_map(MAP_SIZE,6,2,MASK)
    self.create_chunks_table()
    firstChunk = Chunk.create_new(self, Vector2(0,0), get_tab_pos_for_zero())
    self.set_active_chunk(firstChunk)
    pass


func _process(delta):
    var playerPos = get_parent().get_node("Player").translation
    var nearestChunk = get_nearest_chunk(Vector2(playerPos.x, playerPos.z))
    if nearestChunk != ActiveChunk:
        var lastChunk = ActiveChunk
        ActiveChunk = null
        change_chunk([nearestChunk,lastChunk])
    pass
    
    
func create_chunks_table():
    var x = int(MAP_SIZE.x / Chunk.ChunkSize)
    var y = int(MAP_SIZE.y / Chunk.ChunkSize)
    chunks_table = []
    for i in range(x+2):
        var tab = []
        for j in range(y+2):
            tab.append(null)
        chunks_table.append(tab)
    pass

    
func change_chunk(chunks):
    set_unactive_chunk(chunks[1])
    set_active_chunk(chunks[0])
    pass
    

func get_tab_pos_for_zero():
    var x = int(chunks_table.size()/2)
    var y = int(chunks_table[0].size()/2)
    return Vector2(x,y);
    

func add_chunk_to_tab(chunk):
    if chunk.tab_pos.x <= 1 || chunk.tab_pos.x >= chunks_table.size()-2 || chunk.tab_pos.y <= 1 || chunk.tab_pos.y >= chunks_table[0].size()-2:
        chunk.set_as_boarder()
    chunks_table[chunk.tab_pos.x][chunk.tab_pos.y] = chunk
    

func get_nearest_chunk(pos):
    var nearestChunk = ActiveChunk
    var distance = pos.distance_to(nearestChunk.get_2d_pos())
    for i in range(ActiveChunk.tab_pos.x-1,ActiveChunk.tab_pos.x+2):
        for j in range(ActiveChunk.tab_pos.y-1,ActiveChunk.tab_pos.y+2):
            var c = chunks_table[i][j]
            if c != null:
                var newDistance = pos.distance_to(c.get_2d_pos())
                if  newDistance < distance :
                    nearestChunk = c
                    distance = newDistance
    return nearestChunk


func set_unactive_chunk(chunk):
    chunk.deactivate()
    pass


func set_active_chunk(chunk):
    ActiveChunk = chunk
    chunk.activate()
    pass

