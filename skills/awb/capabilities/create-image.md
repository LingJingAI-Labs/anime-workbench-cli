# Create Image

标准流程：

```bash
"$AWB_CMD" model-options --modelGroupCode <g>
"$AWB_CMD" image-create --modelGroupCode <g> --prompt "一只小狗" --quality 1K --ratio 16:9 --generateNum 1 --dryRun true -f json
"$AWB_CMD" image-create --modelGroupCode <g> --prompt "一只小狗" --quality 1K --ratio 16:9 --generateNum 1 --waitSeconds 120 -f json
```

参考图：

```bash
"$AWB_CMD" image-create --modelGroupCode <g> --prompt "参考图里的角色在雨夜奔跑" --quality 1K --ratio 16:9 --generateNum 1 --irefFiles "./a.webp,./b.webp" --dryRun true -f json
```

批量：

```bash
"$AWB_CMD" image-create-batch --inputFile ./image-batch.json --modelGroupCode <g> --dryRun true -f json
```

规则：

- 先 `dryRun`
- 参考图能力以模型定义为准
- 默认把 `generateNum` 当最终返回张数
