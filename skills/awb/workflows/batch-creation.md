# Batch Creation

图片批量：

```bash
"$AWB_CMD" image-create-batch --inputFile ./image-batch.json --modelGroupCode <g> --dryRun true -f json
"$AWB_CMD" image-create-batch --inputFile ./image-batch.json --modelGroupCode <g> -f json
```

视频批量：

```bash
"$AWB_CMD" video-create-batch --inputFile ./video-batch.json --modelGroupCode <g> --dryRun true -f json
"$AWB_CMD" video-create-batch --inputFile ./video-batch.json --modelGroupCode <g> -f json
```

规则：

- 批量先 `--dryRun true`
- 批量文件优先 JSON 或 JSONL
- 统一默认参数放命令行，单条差异放输入文件
