extends Node2D

@export var npc_scene: PackedScene
@export var spawn_interval: float = 2.0
@export var vertical_margin: float = 50.0

var _timer: Timer

func _ready() -> void:
	_timer = Timer.new()
	add_child(_timer)
	_timer.wait_time = spawn_interval
	_timer.autostart = true
	_timer.timeout.connect(_spawn)

func _spawn() -> void:
	if npc_scene == null:
		return

	var npc = npc_scene.instantiate()
	var screen = get_viewport_rect().size
	npc.global_position = Vector2(-50.0, randf_range(vertical_margin, screen.y - vertical_margin))
	get_parent().add_child(npc)
