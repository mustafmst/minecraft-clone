extends Node

# Scenes and Objects
var Chunk = preload("res://components/Land/Chunk.tscn").instance()

# Variables
var PlayerPos = Vector2(0,0)
var ActiveChunk = null


func _ready():
    var firstChunk = Chunk.create_new(self, null, null, null, Vector2(2,-3))
    add_child(firstChunk)
    self.set_active_chunk(firstChunk)
    pass


func update_player_position(pos):
    PlayerPos = pos
    pass


func set_active_chunk(chunk):
    ActiveChunk = chunk
    chunk.set_as_active()
    pass

