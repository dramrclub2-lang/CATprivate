class_name Cat
extends CharacterBody2D
## 猫の移動(走る・止まる・ジャンプ)。ダッシュはタスク3で追加する。

var jump_requested := false

## 入力(-1〜1)から横の速さを決める。離す(0)とすぐ止まり、滑らない。
## キーボードとパッドの合算が2.0になっても、上限を超えない(見直し重点1)。
## on_floor は、氷の床など床ごとのルール用に残してある(今は使わない)。
static func velocity_for(input_dir: float, _on_floor: bool) -> Vector2:
	return Vector2(clampf(input_dir, -1.0, 1.0) * Config.RUN_SPEED, 0.0)

func _physics_process(delta: float) -> void:
	jump_requested = Input.is_action_just_pressed("jump")
	velocity.x = velocity_for(Input.get_axis("move_left", "move_right"), is_on_floor()).x
	if not is_on_floor():
		velocity.y += Config.GRAVITY * delta
	elif jump_requested:
		velocity.y = Config.JUMP_VELOCITY
	move_and_slide()
