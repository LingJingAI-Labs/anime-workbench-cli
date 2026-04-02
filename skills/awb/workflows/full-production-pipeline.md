# Full Production Pipeline

推荐顺序：

1. 先生图
2. 再用图做视频首帧或参考
3. 需要多镜头时再切故事板

示例：

```bash
"$AWB_CMD" image-create --modelGroupCode <imageGroup> --prompt "动漫角色立绘" --quality 1K --ratio 9:16 --generateNum 1 --waitSeconds 120 -f json
"$AWB_CMD" video-create --modelGroupCode <videoGroup> --prompt "@角色A 在雨夜奔跑" --refImageFiles "角色A=./char.webp" --quality 720 --generatedTime 5 --ratio 9:16 --dryRun true -f json
"$AWB_CMD" video-create --modelGroupCode <storyboardGroup> --storyboardPrompts "镜头1：城市远景||镜头2：角色走近镜头" --quality 720 --generatedTime 5 --ratio 16:9 --dryRun true -f json
```
