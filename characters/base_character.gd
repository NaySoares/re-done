extends CharacterBody2D
class_name BaseCharacter

var _has_item: bool = false
@export_category("Variables")
@export var _move_speed: float = 128.0

@export_category("Objects")
@export var _animation: AnimationPlayer


func _physics_process(delta: float) -> void:
	_move()
	_take_item()
	_animated()
	
func _move() -> void:
	var _direction: Vector2 = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	velocity = _direction * _move_speed
	move_and_slide()

func _take_item() -> void:
	if Input.is_action_just_pressed("take_item") and !_has_item:
		_has_item = true
		pass

func _animated() -> void:
	if velocity:
		_animation.play("run")
		return
	
	_animation.play("idle")
