extends Spatial

export(int) var maxBlockHeight = 1


# Variables
const ChunkSize = 16
var neighourChunks = [[null, null, null],
                      [null, null, null],
                      [null, null, null]]


# Creating new Chunk
static func create_new(landScene, parentChunk, parentX, parentY, pos):
    var newChunk = landScene.Chunk.instance()
    landScene.add_child(newChunk)
    newChunk.translate(Vector3(pos.x, 0, pos.y))
    newChunk.create_map()
    if parentChunk != null:
        newChunk.add_neighbour(parentChunk, parentX, parentY)
    return newChunk


func _init():
    pass


func _ready():
    self.add_neighbour(self,1,1)
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
        neighourChunks[nX][nY] = self.create_new(get_parent(), self, 2-nX, 2-nY, Vector2(chunkPos.x/2+((nX-1)*ChunkSize/2),chunkPos.y/2+((nY-1)*ChunkSize/2)))
    pass
    
    
func second():
    for i in range(neighourChunks.size()):
        for j in range(neighourChunks[i].size()):
            neighourChunks[i][j].create_neighbours()
            neighourChunks[i][j].update_relations()
    pass


func create_map():
    for x in range(ChunkSize):
        for y in range(ChunkSize):
            put_blocks(Vector2(x,y))
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

