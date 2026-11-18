extends GutTest
# タスク2: 実際の物理で、走る・止まる・ジャンプが動くことを確かめる

var _stage: Node2D
var _cat: Cat

func before_each():
	_stage = load("res://scenes/main.tscn").instantiate()
	add_child_autofree(_stage)
	_cat = _stage.get_node("Cat")
	await wait_physics_frames(60)  # 着地するまで待つ

func after_each():
	_release_all()

func test_runs_right_then_stops_when_released():
	Input.action_press("move_right")
	await wait_physics_frames(20)
	assert_gt(_cat.velocity.x, 0.0, "押している間は右へ進む")
	Input.action_release("move_right")
	await wait_physics_frames(2)
	assert_eq(_cat.velocity.x, 0.0, "離すとすぐ止まる(滑らない)")

func test_runs_left():
	Input.action_press("move_left")
	await wait_physics_frames(20)
	assert_lt(_cat.velocity.x, 0.0)

func test_jump_leaves_floor():
	assert_true(_cat.is_on_floor(), "前提: 着地している")
	Input.action_press("jump")
	await wait_physics_frames(3)
	assert_lt(_cat.velocity.y, 0.0, "上向きの速度になる")
	assert_false(_cat.is_on_floor())

# ---- ダッシュとダッシュジャンプ ----

func _release_all():
	for a in ["move_left", "move_right", "jump", "dash"]:
		Input.action_release(a)

func _land():
	await wait_physics_frames(3)
	await wait_until(func(): return _cat.is_on_floor(), 3.0)

# 右へ走り、ジャンプして着地するまでの横移動量を返す
func _jump_distance(dash: bool) -> float:
	Input.action_press("move_right")
	if dash:
		Input.action_press("dash")
	await wait_physics_frames(5)
	var x0 := _cat.global_position.x
	Input.action_press("jump")
	await wait_physics_frames(2)
	Input.action_release("jump")
	await _land()
	return _cat.global_position.x - x0

func test_dash_on_floor_uses_dash_speed():
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(5)
	assert_eq(_cat.velocity.x, Config.DASH_SPEED)

func test_dash_without_direction_does_not_drain():
	Input.action_press("dash")
	await wait_physics_frames(20)
	assert_eq(_cat.stamina.value, Config.STAMINA_MAX)

func test_dash_jump_goes_farther_than_normal_jump():
	var normal := await _jump_distance(false)
	_release_all()
	_cat.global_position = Vector2(100, 100)
	_cat.velocity = Vector2.ZERO
	_cat.stamina = Stamina.new()
	await wait_physics_frames(60)
	var dashed := await _jump_distance(true)
	assert_gt(dashed, normal * 1.3, "ダッシュジャンプは通常ジャンプより明らかに遠い")

func test_dash_jump_keeps_speed_after_releasing_dash_in_air():
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(5)
	Input.action_press("jump")
	await wait_physics_frames(3)
	Input.action_release("jump")
	Input.action_release("dash")
	await wait_physics_frames(3)
	assert_false(_cat.is_on_floor(), "前提: 空中")
	assert_eq(_cat.velocity.x, Config.DASH_SPEED, "着地までダッシュ速度を保つ")

func test_dash_jump_does_not_cost_stamina():
	# ダッシュ中の減りだけ。ジャンプ自体では減らない(仕様書 §8)
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(5)
	Input.action_press("jump")
	await wait_physics_frames(2)
	assert_gt(_cat.stamina.value, Config.STAMINA_MAX - 10.0, "ダッシュ数フレーム分の減りだけで、ジャンプ分は減らない")

func test_no_dash_jump_when_stamina_exhausted():
	_cat.stamina.tick(1000.0, true)  # 使い切る
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(3)
	Input.action_press("jump")
	await wait_physics_frames(3)
	assert_lt(_cat.velocity.y, 0.0, "ジャンプ自体はできる")
	assert_false(_cat.is_on_floor())
	assert_eq(_cat.velocity.x, Config.RUN_SPEED, "スタミナ切れなら、空中は通常の走り速度")

func test_speed_returns_to_normal_after_dash_jump_lands():
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(5)
	Input.action_press("jump")
	await wait_physics_frames(2)
	Input.action_release("jump")
	Input.action_release("dash")
	await _land()
	await wait_physics_frames(3)
	assert_eq(_cat.velocity.x, Config.RUN_SPEED, "着地後は通常の走り")

func test_stamina_frozen_during_dash_jump():
	# ダッシュジャンプ中は、減りも回復もしない。着地したら通常に戻る
	Input.action_press("move_right")
	Input.action_press("dash")
	await wait_physics_frames(5)
	Input.action_press("jump")
	await wait_physics_frames(3)
	Input.action_release("jump")
	Input.action_release("dash")
	assert_false(_cat.is_on_floor(), "前提: 空中")
	var frozen: float = _cat.stamina.value
	await wait_physics_frames(5)
	assert_false(_cat.is_on_floor(), "前提: まだ空中")
	assert_eq(_cat.stamina.value, frozen, "飛んでいる間は、減りも回復もしない")
	await _land()
	await wait_physics_frames(30)
	assert_gt(_cat.stamina.value, frozen, "着地後は、時間経過で回復する")
