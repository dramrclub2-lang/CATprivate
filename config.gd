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
