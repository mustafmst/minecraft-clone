extends Position3D

var speed = 0.001388889 # 1h in game world = 1 minute in real
#var speed = 0.2 # test speed

onready var sun = get_node("sun")
onready var w_env = get_node("WorldEnvironment")

func _ready():
    w_env.environment.background_energy = 0.75

func _physics_process(delta):
    var new_sun_rotation = get_rotation()
    new_sun_rotation.z -= (PI * speed) * delta

    if (new_sun_rotation.z > 2 * PI):
        new_sun_rotation.z -= 2 * PI
    elif (new_sun_rotation.z < 0):
        new_sun_rotation.z += 2 * PI

    if ((new_sun_rotation.z > 0) && (new_sun_rotation.z < PI)):
        sun.visible = false
    else:
        sun.visible = true

    if ((new_sun_rotation.z < 2 * PI) && (new_sun_rotation.z > 3 * PI / 2)):
        w_env.environment.background_energy += (speed * 2 * delta)
    elif ((new_sun_rotation.z < 3 * PI / 2) && (new_sun_rotation.z > PI)):
        w_env.environment.background_energy -= (speed * 2 * delta)
    elif ((new_sun_rotation.z < PI) && (new_sun_rotation.z > 5 * PI / 6)):
        w_env.environment.background_energy -= (speed * 2.5 * delta)
    elif ((new_sun_rotation.z < PI / 6) && (new_sun_rotation.z > 0)):
        w_env.environment.background_energy += (speed * 2.5 * delta)
    else:
        pass

    set_rotation(new_sun_rotation)
