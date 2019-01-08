extends Node

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
var mapGenerator
var PlayerPos = Vector2(0,0)
var ActiveChunk = null
var firstChunk

func _ready():
    mapGenerator = get_node("MapGenerator")
    mapGenerator.generate_map(Vector2(1080,1080),10,5,0)
    
    firstChunk = Chunk.instance().create_new(self, null, null, null, Vector2(0,0))
    self.set_active_chunk(firstChunk)
    pass


func _process(delta):
    if Input.is_action_just_pressed("ui_up"):
        if ActiveChunk == null:
            set_active_chunk(firstChunk)
        else:
            set_unactive_chunk(firstChunk)
    pass


func update_player_position(pos):
    PlayerPos = pos
    pass


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

