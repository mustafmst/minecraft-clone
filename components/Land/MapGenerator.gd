extends Node

var mapSize = null

var map = null

var last_generated_number = 1

func get_random(up,down):
    var option = randi()%99
    if option < 33:
        last_generated_number += 1
    elif option >= 33 && option < 66 :
        last_generated_number -= 1
    if last_generated_number < down:
        last_generated_number = down
    elif last_generated_number > up:
        last_generated_number = up
    return last_generated_number


func generate_map(size, maxHeight, minHeight, windowSize):
    randomize()
    mapSize = size
    var tmpMap = []
    for i in range(size.x):
        var mapLine = []
        for j in range(size.y):
             mapLine.append(get_random(maxHeight, minHeight))
        tmpMap.append(mapLine)
    map = tmpMap
    print(map)
#    filter_map(windowSize)
    pass


func filter_map(windowSize):
    var newMap = []
    for i in range(windowSize, map.size()-windowSize):
        var line = []
        for j in range(windowSize, map[i].size()-windowSize):
            line.append(get_avg(windowSize, i, j))
        newMap.append(line)
    map = newMap
    print(map)     
    pass


func get_avg(windowSize, x, y):
    var sum = 0
    var num = 0
    for i in range(-windowSize, windowSize-1):
        for j in range(-windowSize, windowSize-1):
            num += 1
            sum += map[i][j]
    print(sum, num)
    return int(sum/num)        
    pass


func get_height(point):
    var x = int(point.x)+int(mapSize.x/2)
    var y = int(point.y)+int(mapSize.y/2)
    if x > -1 && x < map.size() && y > -1 && y < map[x].size():
        return map[x][y]
    else:
        return 0
    pass