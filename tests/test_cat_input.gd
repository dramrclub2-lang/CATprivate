extends GutTest
# タスク2: 入力から速度を決める計算。見直し重点1(キーボードとパッドの同時押し)も守る

func test_release_stops_immediately():
	assert_eq(Cat.velocity_for(0.0, true).x, 0.0)

func test_left_move_allowed():
	assert_lt(Cat.velocity_for(-1.0, true).x, 0.0)

func test_right_move_is_run_speed():
	assert_eq(Cat.velocity_for(1.0, true).x, Config.RUN_SPEED)

func test_double_input_is_not_doubled():
	# キーボード+パッドの合算で 2.0 が来ても、速さは上限を超えない
	assert_eq(Cat.velocity_for(2.0, true).x, Config.RUN_SPEED)

func test_dash_uses_dash_speed():
	assert_eq(Cat.velocity_for(1.0, true, true).x, Config.DASH_SPEED)

func test_dash_left_is_negative_dash_speed():
	assert_eq(Cat.velocity_for(-1.0, true, true).x, -Config.DASH_SPEED)

func test_dash_input_also_clamped():
	assert_eq(Cat.velocity_for(2.0, true, true).x, Config.DASH_SPEED)

func test_dash_is_faster_than_run():
	assert_gt(Config.DASH_SPEED, Config.RUN_SPEED)
