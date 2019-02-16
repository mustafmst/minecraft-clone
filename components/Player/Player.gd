extends KinematicBody

# The 3D model is from https://clara.io/view/1edd3bc9-ebaf-4bc2-b994-4393ed3ce6d8/image

# https://minecraft.gamepedia.com/Transportation
# There is no 'real' physisc in minecraft
# https://www.minecraftforum.net/forums/minecraft-java-edition/discussion/132990-rebuttal-acceleration-of-gravity-in-minecraft
# We do not even try to reimplement it...
# The constants regarding the acceleration and gravity are experimental 
const GRAVITY = -20
var vel = Vector3()
const MAX_SPEED = 4.317
const JUMP_SPEED = 7
const ACCEL= 4
const MAX_SPRINT_SPEED =  5.612
const SPRINT_ACCEL = 6
var is_sprinting = false

var dir = Vector3()

const DEACCEL= 16
const MAX_SLOPE_ANGLE = 40

enum ANIM_STATES { IDLE, WALKING }
var anim_state = IDLE

onready var camera = $RotationHelper/Camera
onready var rotation_helper = $RotationHelper
onready var animation_player = $RotationHelper/Model/AnimationPlayer

var MOUSE_SENSITIVITY = 0.05

# https://minecraft.gamepedia.com/Player
# The player is 1.8 blocks tall, 1.65 blocks tall when sneaking,
# 0.6 blocks tall when gliding/sprint-swimming and 0.6 blocks wide.

func _ready():
    # Cature the mouse cursor in game window 
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
    animation_player.connect("animation_finished", self, "on_anim_finished")
    anim_state = ANIM_STATES.IDLE

func _physics_process(delta):
    process_input(delta)
    process_movement(delta)

func process_input(delta):

    # ----------------------------------
    # Walking
    dir = Vector3()
    var cam_xform = camera.get_global_transform()

    var input_movement_vector = Vector2()

    if Input.is_action_pressed("movement_forward"):
        input_movement_vector.y += 1
    if Input.is_action_pressed("movement_backward"):
        input_movement_vector.y -= 1
    if Input.is_action_pressed("movement_left"):
        input_movement_vector.x -= 1
    if Input.is_action_pressed("movement_right"):
        input_movement_vector.x = 1

    input_movement_vector = input_movement_vector.normalized()

    dir += -cam_xform.basis.z.normalized() * input_movement_vector.y
    dir += cam_xform.basis.x.normalized() * input_movement_vector.x
    # ----------------------------------

    # ----------------------------------
    # Jumping
    if is_on_floor():
        if Input.is_action_just_pressed("movement_jump"):
            vel.y = JUMP_SPEED
    # ----------------------------------

    # ----------------------------------
    # Sprinting
    if Input.is_action_pressed("movement_sprint"):
        is_sprinting = true
    else:
        is_sprinting = false

func process_movement(delta):
    dir.y = 0
    dir = dir.normalized()

    vel.y += delta*GRAVITY

    var hvel = vel # horizontal velocity
    hvel.y = 0

    var target = dir
    if is_sprinting:
        target *= MAX_SPRINT_SPEED
    else:
        target *= MAX_SPEED

    var accel
    if dir.dot(hvel) > 0:
        if is_sprinting:
            accel = SPRINT_ACCEL
        else:
            accel = ACCEL
    else:
        accel = DEACCEL

    hvel = hvel.linear_interpolate(target, accel*delta)
    vel.x = hvel.x
    vel.z = hvel.z
    vel = move_and_slide(vel,Vector3(0,1,0), 0.05, 4, deg2rad(MAX_SLOPE_ANGLE))
    if anim_state != ANIM_STATES.WALKING and vel.length_squared() > 0:
        anim_state = ANIM_STATES.WALKING
        animation_player.queue("Walking")

func _input(event):
    if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
        rotation_helper.rotate_x(deg2rad(event.relative.y * MOUSE_SENSITIVITY))
        self.rotate_y(deg2rad(event.relative.x * MOUSE_SENSITIVITY * -1))

        var camera_rot = rotation_helper.rotation_degrees
        camera_rot.x = clamp(camera_rot.x, -70, 70)
        rotation_helper.rotation_degrees = camera_rot

func on_anim_finished(anim_name):
    if vel.length_squared() > 0:
        animation_player.play("Walking")
    else:
        anim_state = ANIM_STATES.IDLE
