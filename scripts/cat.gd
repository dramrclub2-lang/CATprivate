class_name Cat
extends CharacterBody2D
## 猫の移動(走る・止まる・ジャンプ・ダッシュ・ダッシュジャンプ)。

var jump_requested := false
var stamina := Stamina.new()
var _dash_jump_locked := false  # ダッシュジャンプ中は、着地まで速度を保つ

## 入力(-1〜1)から横の速さを決める。離す(0)とすぐ止まり、滑らない。
## キーボードとパッドの合算が2.0になっても、上限を超えない(見直し重点1)。
## on_floor は、氷の床など床ごとのルール用に残してある(今は使わない)。
static func velocity_for(input_dir: float, _on_floor: bool, dashing := false) -> Vector2:
	var speed := Config.DASH_SPEED if dashing else Config.RUN_SPEED
	return Vector2(clampf(input_dir, -1.0, 1.0) * speed, 0.0)

func _physics_process(delta: float) -> void:
	var dir := Input.get_axis("move_left", "move_right")
	jump_requested = Input.is_action_just_pressed("jump")
	# ダッシュは地上だけ。向きを入れていない時は、減らさない
	var dashing := is_on_floor() and dir != 0.0 and Input.is_action_pressed("dash") and stamina.can_dash()
	if is_on_floor():
		_dash_jump_locked = false
		velocity.x = velocity_for(dir, true, dashing).x
		if jump_requested:
			velocity.y = Config.JUMP_VELOCITY
			if dashing:
				_dash_jump_locked = true  # ダッシュ速度のまま着地まで飛ぶ(スタミナは減らさない)
	else:
		velocity.y += Config.GRAVITY * delta
		if not _dash_jump_locked:
			velocity.x = velocity_for(dir, false).x
	# ダッシュジャンプ中は、スタミナを減らさず、回復もさせない(凍結)
	if not _dash_jump_locked:
		stamina.tick(delta, dashing)
	move_and_slide()
