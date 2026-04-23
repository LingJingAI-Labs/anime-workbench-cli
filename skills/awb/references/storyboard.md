# 故事板（storyboard）

把多个镜头的文字描述一次性塞给视频模型，生成带镜头切换的连续视频。

## 1. 适用模型

`paramKeys` 里含 `multi_prompt` 的视频模型才支持。当前常见：

- 可灵 3.0（`KeLing3_VideoCreate_Group`）
- 可灵 3.0-Omni（`KeLing3_Omni_VideoCreate_Group`）

判断方法：

```bash
"$AWB_CMD" video-models --model "可灵 3" -f json | \
  jq '.[] | {模型, 模型组: .modelGroupCode, paramKeys}'
```

看 `paramKeys` 末尾是否有 `multi_prompt`。

## 2. 语法

### 2.1 `||` 分隔字符串（推荐）

```bash
"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "镜头1：城市远景||镜头2：人物走近镜头||镜头3：特写面部" \
  --quality 720 --generatedTime 5 --ratio 16:9 --waitSeconds 180 -f json
```

### 2.2 JSON 数组

```bash
"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts '["镜头1：城市远景","镜头2：人物走近镜头","镜头3：特写面部"]' \
  --quality 720 --generatedTime 5 --ratio 16:9 --waitSeconds 180 -f json
```

两种写法等价；字符串里含引号 / 特殊字符时 JSON 数组更稳。

## 3. 与其他模式的关系

- **和 `--prompt` 的关系**：`--storyboardPrompts` 通常取代 `--prompt`；单独的 `--prompt` 可选填，当作全局风格 / 总指示。
- **和 `frame*` 的关系**：故事板模式不需要 `--frameFile` 等；生成器自行安排各镜头过渡。
- **和 `ref*` 的关系**：可以叠加参考图 / 主体（`--refImageFiles "角色A=..."` 或 `--refSubjects "角色A=asset-..."`），`@角色A` 可以出现在任一分镜里。
- **`--generatedMode multi_prompt`**：CLI 会自动判断，**通常不用手传**。

## 4. 时长规则

`--generatedTime` 作用于**整段视频**，不是单镜头。模型会把时长切给各个镜头。写 5 秒 + 3 个镜头 → 每镜头约 1.6 秒。想要长故事板 → 加大 `--generatedTime`（但要看模型支持的最大值）。

## 5. 典型写法

### 5.1 纯故事板

```bash
"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "城市远景||人物走近||对话特写" \
  --quality 720 --generatedTime 10 --ratio 16:9 --waitSeconds 240 -f json
```

### 5.2 故事板 + 参考图

```bash
"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "@角色A 从远处走来||@角色A 转头看向镜头||特写@角色A 的表情" \
  --refImageFiles "角色A=./char.webp" \
  --quality 720 --generatedTime 10 --ratio 16:9 --waitSeconds 240 -f json
```

### 5.3 故事板 + 主体引用

```bash
"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "@小莉 在街头行走||@小莉 停下转头||@小莉 微笑" \
  --refSubjects "小莉=asset-xxxxxxxx" \
  --quality 720 --generatedTime 10 --ratio 16:9 --waitSeconds 240 -f json
```

### 5.4 预估 + 干跑

```bash
"$AWB_CMD" video-fee --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "镜头1||镜头2||镜头3" \
  --quality 720 --generatedTime 10 --ratio 16:9 -f json

"$AWB_CMD" video-create --modelGroupCode KeLing3_VideoCreate_Group \
  --storyboardPrompts "镜头1||镜头2||镜头3" \
  --quality 720 --generatedTime 10 --ratio 16:9 --dryRun true -f json
```

## 6. 经验引导

- **先确认模型支持**：没有 `multi_prompt` 的模型收到 `--storyboardPrompts` 要么忽略要么报错。用 `video-models --model` 看能力列。
- **每个镜头一个自然小节**：一句话 + 可选镜头描述，比塞一堆修饰词更好。镜头间语义差别越大切换越自然。
- **`@角色A` 可跨镜头**：只要一次 `--refImageFiles` / `--refSubjects` 声明，多镜头里都能 `@` 引用。
- **`||` 分隔符不要两边带空格**：`"a || b"` 会把空格带进段落；`"a||b"` 更干净。
- **总时长别过短**：镜头数 × 1~2 秒是常识；3~4 个镜头起 `--generatedTime 8~12`，否则每镜头就 1 秒不到。
- **积分是按整段视频算**：故事板不会按镜头数叠加计费，但复杂度会推高 Token 计费模型的成本，记得 `video-fee`。
- **JSON 数组语法适合构造复杂分镜**：让脚本 / agent 生成 JSON，再塞 `'...'`，避免 `||` 遇到特殊字符转义麻烦。
