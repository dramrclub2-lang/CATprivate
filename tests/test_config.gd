extends GutTest
# タスク1: Config(全数値の入れ物)が正しい値を持つことを守るテスト

func test_config_has_letter_time():
	assert_eq(Config.LETTER_TIME_SEC, 10.0)

func test_max_hp_is_9():
	assert_eq(Config.MAX_HP, 9)
