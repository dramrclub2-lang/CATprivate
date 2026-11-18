class_name Stamina
extends RefCounted
## スタミナの計算。画面から切り離してある(テストで守るため)。

var value: float = Config.STAMINA_MAX
var _exhausted := false  # 0になった後、しきい値まで回復するまで true

func can_dash() -> bool:
	return not _exhausted and value > 0.0

## dashing=true でも、ダッシュできない時は回復側に回る(0で押し続けても止まらない)。
func tick(delta: float, dashing: bool) -> void:
	if dashing and can_dash():
		value = maxf(value - Config.DASH_DRAIN_PER_SEC * delta, 0.0)
		if value <= 0.0:
			_exhausted = true
	else:
		value = minf(value + Config.STAMINA_REGEN_PER_SEC * delta, Config.STAMINA_MAX)
		_update_exhausted()

func restore(percent: float) -> void:
	value = minf(value + Config.STAMINA_MAX * percent / 100.0, Config.STAMINA_MAX)
	_update_exhausted()

func _update_exhausted() -> void:
	if _exhausted and value >= Config.STAMINA_MAX * Config.DASH_RESUME_RATIO:
		_exhausted = false
