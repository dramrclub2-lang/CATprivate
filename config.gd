class_name Config
## 全ゲーム数値の置き場。コードに数値を直書きせず、ここを読む。
## 「仮置き」は試作版を遊んで調整する値(仕様書 v1.4)。

# 画面(仕様書 §3)
const BASE_WIDTH := 480
const BASE_HEIGHT := 270

# HP(仕様書 §10)
const MAX_HP := 9
const DAMAGE_PER_HIT := 1

# 手紙(仕様書 §11・仮置き)
const LETTER_TIME_SEC := 10.0

# ステージ(仕様書 §12)
const CHECKPOINT_COUNT_PER_STAGE := 1

# 強制停止(仕様書 §15・仮置き)
const FORCED_STOP_SEC := 1.0

# 猫の移動(仕様書 §7・仮置き。遊んで調整)
const RUN_SPEED := 120.0       # px/秒
const JUMP_VELOCITY := -280.0  # 上向きが負
const GRAVITY := 900.0         # px/秒^2

# スタミナとダッシュ(仕様書 §8・§9・仮置き。遊んで調整)
const STAMINA_MAX := 100.0
const DASH_SPEED := 200.0              # px/秒
const DASH_DRAIN_PER_SEC := 25.0       # ダッシュ中の減り方
const STAMINA_REGEN_PER_SEC := 10.0    # 時間経過の回復
const DASH_RESUME_RATIO := 0.2         # 0になった後、この割合まで戻るとダッシュ再開
const DASH_JUMP_COST := 20.0           # ダッシュジャンプ1回の消費(追加仕様)

# 回復アイテム(仕様書 §9)
const ITEM_CHICKEN_PERCENT := 10.0
const ITEM_SALMON_PERCENT := 30.0
const ITEM_CATFOOD_PERCENT := 100.0
