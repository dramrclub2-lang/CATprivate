extends GutTest
# タスク3: スタミナの計算(画面から切り離したテスト)

var _s: Stamina

func before_each():
	_s = Stamina.new()

func test_starts_full():
	assert_eq(_s.value, Config.STAMINA_MAX)

func test_dash_drains():
	_s.tick(1.0, true)
	assert_almost_eq(_s.value, Config.STAMINA_MAX - Config.DASH_DRAIN_PER_SEC, 0.001)

func test_regenerates_when_not_dashing():
	_s.value = 50.0
	_s.tick(1.0, false)
	assert_almost_eq(_s.value, 50.0 + Config.STAMINA_REGEN_PER_SEC, 0.001)

func test_zero_blocks_dash():
	_s.tick(1000.0, true)  # 使い切る
	assert_eq(_s.value, 0.0)
	assert_false(_s.can_dash())
	_s.tick(0.01, true)    # 0でダッシュを押し続けても
	assert_false(_s.can_dash())

func test_held_dash_after_empty_resumes_only_after_threshold():
	# 見直し重点3: 0で押し続けても、ちらつかず、回復したら戻る
	_s.tick(1000.0, true)
	_s.tick(1.0, true)
	assert_false(_s.can_dash(), "しきい値(20%)未満はまだ不可")
	assert_gt(_s.value, 0.0, "押し続けても回復は進む")
	_s.tick(1.5, true)
	assert_true(_s.can_dash(), "しきい値を超えたら再びダッシュできる")

func test_item_restores_30_percent():
	_s.value = 10.0
	_s.restore(Config.ITEM_SALMON_PERCENT)
	assert_almost_eq(_s.value, 10.0 + Config.STAMINA_MAX * 0.3, 0.001)

func test_restore_caps_at_100():
	_s.value = 90.0
	_s.restore(Config.ITEM_CATFOOD_PERCENT)
	assert_eq(_s.value, Config.STAMINA_MAX)

func test_item_restore_clears_exhaustion():
	_s.tick(1000.0, true)
	_s.restore(Config.ITEM_SALMON_PERCENT)
	assert_true(_s.can_dash())
