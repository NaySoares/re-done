extends Node

var trash_on_ground: int = 0   # GAME OVER se >= 7
var penalties: int = 0          # GAME OVER se >= 3
var level: int = 1              # 1 a 3
var time_remaining: float = 180.0
var game_state: String = "PLAYING"  # PLAYING, GAME_OVER, WIN

signal trash_count_changed
signal penalty_added
signal game_over
signal level_won
