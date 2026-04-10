extends CharacterBody2D

@export var speed: float = 80.0
@export var edge_margin: float = 16.0
@export var drop_scene: PackedScene = preload("res://scenes/item.tscn")
@export var drop_interval_min: float = 1.0
@export var drop_interval_max: float = 5.0

@onready var animation: AnimationPlayer = $Animation
var _move_dir: Vector2 = Vector2.LEFT
var _rng := RandomNumberGenerator.new()
var _drop_elapsed: float = 0.0
var _next_drop_time: float = 1.0

func _ready() -> void:
	_rng.randomize()
	_next_drop_time = _rng.randf_range(drop_interval_min, drop_interval_max)
	var view_rect := get_viewport().get_visible_rect()
	var view_center_x := view_rect.position.x + (view_rect.size.x * 0.5)
	
	if global_position.x <= view_center_x:
		_move_dir = Vector2.RIGHT
		if animation:
			animation.play("walk_right")
	else:
		_move_dir = Vector2.LEFT
		if animation:
			animation.play("walk_left")

func _physics_process(delta: float) -> void:
	velocity = _move_dir * speed
	move_and_slide()
	_drop_elapsed += delta
	if _drop_elapsed >= _next_drop_time and _is_on_screen():
		_drop_item()
		_drop_elapsed = 0.0
		_next_drop_time = _rng.randf_range(drop_interval_min, drop_interval_max)
	var view_rect := get_viewport().get_visible_rect()
	if _move_dir == Vector2.LEFT and global_position.x < view_rect.position.x - edge_margin:
		queue_free()
		return
	if _move_dir == Vector2.RIGHT and global_position.x > view_rect.position.x + view_rect.size.x + edge_margin:
		queue_free()

func _is_on_screen() -> bool:
	var view_rect := get_viewport().get_visible_rect()
	return view_rect.has_point(global_position)

func _drop_item() -> void:
	if drop_scene == null:
		return
	var item = drop_scene.instantiate()
	item.global_position = global_position
	get_tree().current_scene.add_child(item)
