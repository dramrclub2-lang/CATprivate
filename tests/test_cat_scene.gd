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
	for a in ["move_left", "move_right", "jump"]:
		Input.action_release(a)

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
