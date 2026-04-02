# Create Video

三种常见模式：

1. 纯提示词
2. 首尾帧
3. 参考生视频 / 故事板

纯提示词：

```bash
"$AWB_CMD" video-create --modelGroupCode <g> --prompt "雨夜街头，人物缓慢走向镜头，电影感" --quality 720 --generatedTime 5 --ratio 16:9 --dryRun true -f json
```

首尾帧：

```bash
"$AWB_CMD" video-create --modelGroupCode <g> --frameFile ./frame.webp --tailFrameFile ./tail.webp --quality 720 --generatedTime 5 --ratio 16:9 --dryRun true -f json
```

参考生视频：

```bash
"$AWB_CMD" video-create --modelGroupCode <g> --prompt "@角色A 在雨夜奔跑" --refImageFiles "角色A=./char.webp" --quality 720 --generatedTime 5 --ratio 16:9 --dryRun true -f json
```

故事板：

```bash
"$AWB_CMD" video-create --modelGroupCode <g> --storyboardPrompts "镜头1：城市远景||镜头2：人物走近镜头" --quality 720 --generatedTime 5 --ratio 16:9 --dryRun true -f json
```

规则：

- `frame*` 和 `ref*` 不混用
- 支持纯提示词的模型，先查 `model-options`
- 故事板优先用 `--storyboardPrompts`
