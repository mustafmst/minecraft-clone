extends Position3D

const _2_PI = 2 * PI
const _3_PI_2 = 3 * PI / 2

export var speed = 0.001388889 # 1h in game world = 1 minute in real / 0.2 - decent test speed
export var start_sky_energy = 0.75
export var dusk_angle = PI / 6
export var day_brightness_speed_factor = 2
export var night_brightness_speed_factor = 2.5

onready var sun = get_node("sun")
onready var moon = get_node("moon")
onready var sky_env = get_node("WorldEnvironment")


func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    sky_env.environment.background_energy = start_sky_energy


func rotate(rotation, delta):
    rotation.z -= (PI * speed * delta)
    return rotation


func _adjust_sun_visibility(rotation):
    if ((rotation.z > 0) && (rotation.z < PI)):
        sun.visible = false
    else:
        sun.visible = true


func _adjust_rotation_to_2_pi(rotation):
    if (rotation.z > _2_PI):
        rotation.z -= _2_PI
    elif (rotation.z < 0):
        rotation.z += _2_PI
    return rotation


func _set_visibility(sun_rotation, moon_rotation, sun, moon):
    if ((sun_rotation.z > 0) && (sun_rotation.z < PI)):
        sun.visible = false
    else:
        sun.visible = true

    if ((moon_rotation.z > 0) && (moon_rotation.z < PI)):
        moon.visible = true
    else:
        moon.visible = false


func _adjust_sky_brightness(sun_rotation, delta):
    if ((sun_rotation.z < _2_PI) && (sun_rotation.z > _3_PI_2)):
        sky_env.environment.background_energy += (speed * day_brightness_speed_factor * delta)
    elif ((sun_rotation.z < _3_PI_2) && (sun_rotation.z > PI)):
        sky_env.environment.background_energy -= (speed * day_brightness_speed_factor * delta)
    elif ((sun_rotation.z < PI) && (sun_rotation.z > PI - dusk_angle)):
        sky_env.environment.background_energy -= (speed * night_brightness_speed_factor * delta)
    elif ((sun_rotation.z < dusk_angle) && (sun_rotation.z > 0)):
        sky_env.environment.background_energy += (speed * night_brightness_speed_factor * delta)
    else:
        pass


func _physics_process(delta):

    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    var sun_rotation = get_rotation()
    var moon_rotation = get_rotation()

    var new_sun_rotation = rotate(sun_rotation, delta)
    var new_moon_rotation = rotate(moon_rotation, delta)

    new_sun_rotation = _adjust_rotation_to_2_pi(new_sun_rotation)
    new_moon_rotation = _adjust_rotation_to_2_pi(new_moon_rotation)

    _set_visibility(new_sun_rotation, new_moon_rotation, sun, moon)
    _adjust_sky_brightness(new_sun_rotation, delta)

    set_rotation(new_moon_rotation)
    set_rotation(new_sun_rotation)
