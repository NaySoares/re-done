extends CharacterBody2D
class_name Player

var _held_item: Item = null
var _last_direction: Vector2 = Vector2.DOWN

@onready var pickup_area: Area2D = get_node_or_null("PickupArea")

@export_category("Variables")
@export var _move_speed: float = 128.0
@export var _border_margin: Vector2 = Vector2(8, 20) # (y, x)

@export_category("Objects")
@onready var _animation: AnimationPlayer = $Animation

func _ready():
	if pickup_area == null:
		push_error("PickupArea nao encontrado no Player.")
		return
	# Garante que o PickupArea esta monitorando
	pickup_area.monitoring = true
	pickup_area.monitorable = true
	print("Player pronto:", name)

func _physics_process(delta: float) -> void:
	if pickup_area == null:
		return
	var direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	_move(direction)
	_animate(direction)

func _input(event):
	if event.is_action_pressed("take_item"):
		_take_item()
	if event.is_action_pressed("throw"):
		_arremessar_item()

func _move(direction: Vector2) -> void:
	velocity = direction * _move_speed
	move_and_slide()
	_clamp_to_viewport()

func _clamp_to_viewport() -> void:
	var view_rect := get_viewport().get_visible_rect()
	var min_x := view_rect.position.x + _border_margin.x
	var max_x := view_rect.position.x + view_rect.size.x - _border_margin.x
	var min_y := view_rect.position.y + _border_margin.y
	var max_y := view_rect.position.y + view_rect.size.y - _border_margin.y
	global_position.x = clamp(global_position.x, min_x, max_x)
	global_position.y = clamp(global_position.y, min_y, max_y)

func _take_item() -> void:
	if pickup_area == null:
		return
	if _held_item != null:
		return

	var overlaps := pickup_area.get_overlapping_areas()
	for area in overlaps:
		if area is Item:
			_held_item = area
			_held_item.pickup()
			return

func _arremessar_item() -> void:
	if _held_item == null:
		return
	var direcao_mouse = (get_global_mouse_position() - global_position).normalized()
	_held_item.global_position = global_position
	_held_item.arremessar(direcao_mouse)
	_held_item = null

func _animate(direction: Vector2) -> void:
	if direction != Vector2.ZERO:
		_last_direction = direction
		var dir_name := _get_direction_name(direction)
		_animation.play("walk_" + dir_name)
	else:
		var dir_name := _get_direction_name(_last_direction)
		_animation.play("idle_" + dir_name)

func _get_direction_name(direction: Vector2) -> String:
	if abs(direction.x) > abs(direction.y):
		return "right" if direction.x > 0 else "left"
	else:
		return "down" if direction.y > 0 else "up"
