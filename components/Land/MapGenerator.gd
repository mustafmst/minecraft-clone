extends Node

var mapSize = null

var map = null

func generate_map(size, maxHeight, minHeight, windowSize):
    randomize()
    mapSize = size
    var tmpMap = []
    for i in range(size.x):
        var mapLine = []
        for j in range(size.y):
             mapLine.append(randi()%(maxHeight-minHeight)+minHeight)
        tmpMap.append(mapLine)
    map = tmpMap
    pass


func get_height(point):
    var x = int(point.x)+int(mapSize.x/2)
    var y = int(point.y)+int(mapSize.y/2)
    if x > -1 && x < mapSize.x && y > -1 && y < mapSize.y:
        return map[x][y]
    else:
        return 0
    pass