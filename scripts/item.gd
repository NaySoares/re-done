extends Area2D
class_name Item

@export var velocidade_inicial: float = 500.0
@export var grupo_lixeira: StringName = "lixeira"
@export var possible_textures: Array[Texture2D] = []
@export var randomize_texture: bool = true

var _velocidade_atual: float = 0.0
var direcao: Vector2 = Vector2.ZERO
var foi_arremessado: bool = false

@onready var sprite: Sprite2D = $Texture
var _rng := RandomNumberGenerator.new()

func _ready():
	_rng.randomize()
	if randomize_texture and possible_textures.size() > 0 and sprite:
		sprite.texture = possible_textures[_rng.randi_range(0, possible_textures.size() - 1)]

	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)   # colisão com lixeira (StaticBody2D)
	if not area_entered.is_connected(_on_area_entered):
		area_entered.connect(_on_area_entered)   # colisão com lixeira (Area2D)

func _physics_process(delta):
	if foi_arremessado:
		global_position += direcao * _velocidade_atual * delta
		_velocidade_atual = lerp(_velocidade_atual, 0.0, 5.0 * delta)

func pickup() -> void:
	foi_arremessado = false
	hide()
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)

func arremessar(dir: Vector2) -> void:
	direcao = dir.normalized()
	_velocidade_atual = velocidade_inicial
	foi_arremessado = true
	show()
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)

func _on_body_entered(body):
	if not foi_arremessado:
		return
	if body.is_in_group(grupo_lixeira):
		queue_free()

func _on_area_entered(area):
	if not foi_arremessado:
		return
	if area.is_in_group(grupo_lixeira):
		queue_free()
