# Model Discovery

先查模型，再查参数：

```bash
"$AWB_CMD" image-models
"$AWB_CMD" video-models
"$AWB_CMD" image-models --model "Nano Banana"
"$AWB_CMD" video-models --model "可灵 3.0"
"$AWB_CMD" model-options --modelGroupCode <modelGroupCode>
```

原则：

- 模型选择优先复制 `modelGroupCode`
- 不要猜比例、分辨率、时长，先查 `model-options`
- 看到 `参考模式`、`帧模式`、`特色能力` 后再决定命令写法

常见判断：

- 生图参考图：看 `参考图`
- 生视频首尾帧：看 `帧模式`
- 多参考：看 `参考模式`
- 故事板：看 `generated_mode` 是否有 `multi_prompt`
