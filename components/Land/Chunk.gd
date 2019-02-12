extends Spatial

export(int) var maxBlockHeight = 1
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
const ChunkSize = 16


var tab_pos = null
var is_boarder = false

# Creating new Chunk
static func create_new(landScene, pos, tab_pos):
    var newChunk = Chunk.instance()
    newChunk.tab_pos = tab_pos
    landScene.add_child(newChunk)
    newChunk.translate(Vector3(pos.x, 0, pos.y))
    newChunk.create_map()
    landScene.add_chunk_to_tab(newChunk)
    return newChunk


func _init():
    pass


func put_blocks(pos):
    var chunkPos = self.translation
    var blockPos = Vector2(chunkPos.x+pos.x-ChunkSize/2, chunkPos.z+pos.y-ChunkSize/2)
    for h in range(get_parent().mapGenerator.get_height(blockPos)):
        var item = get_parent().Block.instance()
        item.translate(Vector3(blockPos.x,h,blockPos.y))
        add_child(item)
    pass


# Helper methods
func get_2d_pos():
    return Vector2(self.translation.x*2, self.translation.z*2)


func create_map():
    for x in range(ChunkSize):
        for y in range(ChunkSize):
            put_blocks(Vector2(x,y))
    pass


func set_as_boarder():
    self.is_boarder = true


func activate():
    self.set_process(true)
    self.show()
    var parent = get_parent()
    for i in range(tab_pos.x-1,tab_pos.x+2):
        for j in range(tab_pos.y-1,tab_pos.y+2):
            if parent.chunks_table[i][j] == null:
                if not is_boarder:
                    self.create_new(parent, Vector2(self.translation.x + ((i - tab_pos.x)* ChunkSize/2),self.translation.z + ((j - tab_pos.y)*ChunkSize/2)), Vector2(i,j))
                    parent.chunks_table[i][j].set_process(true)
                    parent.chunks_table[i][j].show()
            else :
                parent.chunks_table[i][j].set_process(true)
                parent.chunks_table[i][j].show()
    pass


func deactivate():
    var parent = get_parent()
    for i in range(tab_pos.x-1,tab_pos.x+2):
        for j in range(tab_pos.y-1,tab_pos.y+2):
            if parent.chunks_table[i][j] != null:
                parent.chunks_table[i][j].set_process(false)
                parent.chunks_table[i][j].hide()
    self.set_process(false)
    self.hide()
    pass

