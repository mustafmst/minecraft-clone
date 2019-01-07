extends Spatial

export(int) var maxBlockHeight = 1

# Scenes and Objects
const Block = preload("res://components/Block/Block.tscn")
const Chunk = preload("res://components/Land/Chunk.tscn")

# Variables
const ChunkSize = 16
var neighourChunks = [[null, null, null],
                      [null, null, null],
                      [null, null, null]]

# need to implement here chunk generation
func generate_map():
    var map = []
    for i in range(ChunkSize):
        var tmp = []
        for j in range(ChunkSize):
            tmp.push_back(randi()%(maxBlockHeight)+1)
        map.push_back(tmp)
    return map


# Creating new Chunk
static func create_new(landScene, parentChunk, parentX, parentY, pos):
    var newChunk = Chunk.instance()
    newChunk.translate(Vector3(pos.x, 0, pos.y))
    newChunk.create_map()
    if parentChunk != null:
        newChunk.add_neighbour(parentChunk, parentX, parentY)
    landScene.add_child(newChunk)
    return newChunk


func _init():
    pass


func _ready():
    self.add_neighbour(self,1,1)
    pass


func put_blocks(pos, height):
    var chunkPos = self.get_2d_pos()
    for h in range(height):
        var item = Block.instance()
        item.translate(Vector3(chunkPos.x+pos.x-ChunkSize/2, h, chunkPos.y+pos.y-ChunkSize/2))
        add_child(item)
    pass


# Helper methods
func get_2d_pos():
    return Vector2(self.translation.x, self.translation.z)


func add_neighbour(chunk, x, y):
    neighourChunks[x][y] = chunk
    pass


func create_neighbours():
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            self.check_if_chunk_exist_and_create(i,j)
    pass


func update_relations():
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            if neighourChunks[i][j] != self:
                self.update_relations_for_chunk(neighourChunks[i][j], Vector2(1,1)-Vector2(i,j))
    pass


func update_relations_for_chunk(chunk, relationVec):
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            if neighourChunks[i][j] != self && neighourChunks[i][j] != chunk:
                var relation = Vector2(i,j)+relationVec
                if relation.x > -1 && relation.x < 3  && relation.y > -1 && relation.y < 3:
                    chunk.add_neighbour(neighourChunks[i][j], relation.x, relation.y)
    pass


func check_if_chunk_exist_and_create(nX, nY):
    var chunkPos = self.get_2d_pos()
    if(neighourChunks[nX][nY] == null):
        neighourChunks[nX][nY] = self.create_new(get_parent(), self, 2-nX, 2-nY, Vector2(chunkPos.x+((nX-1)*ChunkSize/2),chunkPos.y+((nY-1)*ChunkSize/2)))
    pass
    
    
func second():
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            neighourChunks[i][j].create_neighbours()
            neighourChunks[i][j].update_relations()
    pass


func create_map():
    var map = generate_map()
    for x in range(map.size()):
        for y in range(map[x].size()):
            put_blocks(Vector2(x,y), map[x][y])
    pass


func activate():
    self.set_process(true)
    self.show()
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            if neighourChunks[i][j] != null:
                neighourChunks[i][j].set_process(true)
                neighourChunks[i][j].show()
    pass


func deactivate():
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            if neighourChunks[i][j] != null:
                neighourChunks[i][j].set_process(false)
                neighourChunks[i][j].hide()
    self.set_process(false)
    self.hide()
    pass

