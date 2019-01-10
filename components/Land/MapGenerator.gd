extends Node

var mapSize = null

var map = null

var last_generated_number = 1

func get_new_height(last_height, down, up):
    var new = last_height + (randi()%3-1)
    if new > up :
        return up
    elif new < down :
        return down
    return new

func new_map_generation(size, down, up):
    var lastXY = 0
    var lastZY = 0
    var new_map = []
    for i in range(size.x):
        randomize()
        lastXY = get_new_height(lastXY, down, up)
        lastZY = lastXY
        var line = [lastXY]
        for j in range(size.y-1):
            var new = get_new_height(lastZY, down, up)
            line.append(new)
        new_map.append(line)
    map = new_map    
    pass


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


func generate_map(size, up, down, mask):
    randomize()
    new_map_generation(size, down, up)
    filter_map(mask)
    pass


func filter_map(mask):
    var mask_sum = get_mask_sum(mask)
    var new_map = []
    for x in range(1,map.size()-1):
        var line = []
        for y in range(1,map[x].size()-1):
            var sum = 0
            for i in range(-1,1):
                for j in range(-1,1):
                    sum = sum + (map[x+i][y+j] * mask[i+1][j+1])
            var h = int(sum/mask_sum)
#            if h < 1 :
#                h = 1
            line.append(h)
        new_map.append(line)
    map = new_map
    pass


func get_mask_sum(mask):
    var res = 0
    for i in range(mask.size()):
        for j in range(mask[i].size()):
            res = res + mask[i][j]
    return res


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
    var x = int(point.x)+int(map.size()/2)
    var y = int(point.y)+int(map[0].size()/2)
    if x > -1 && x < map.size() && y > -1 && y < map[x].size():
        return map[x][y]
    else:
        return 0
    pass