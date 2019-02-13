extends StaticBody

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var parent = get_parent()

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass


func do_primary(collition_normal, collition_point):
    parent.queue_free()

func do_secondary(collition_normal, collition_point):
    parent.add_block(collition_normal);
