# Model Discovery

先查模型，再查参数：

```bash
"$AWB_CMD" image-models --model "Nano Banana"
"$AWB_CMD" video-models --model "可灵 3.0"
"$AWB_CMD" model-options --modelGroupCode <modelGroupCode>
```

只想快速缩小范围时：

```bash
"$AWB_CMD" image-models | rg "Nano Banana|即梦 4.0"
"$AWB_CMD" video-models | rg "Grok|可灵 3.0|即梦 3.0"
```

原则：

- 模型选择优先复制 `modelGroupCode`
- 不要猜比例、分辨率、时长，先查 `model-options`
- 看到 `参考模式`、`帧模式`、`特色能力` 后再决定命令写法
- 已经知道模型名或模型族时，不要先跑全量模型列表
- 如果命令必须用 `-f json`，后面优先接 `jq` 摘必要字段，不要直接展开整段 JSON

常见判断：

- 生图参考图：看 `参考图`
- 生视频首尾帧：看 `帧模式`
- 多参考：看 `参考模式`
- 故事板：看 `generated_mode` 是否有 `multi_prompt`
