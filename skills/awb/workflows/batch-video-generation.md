# Batch Video Generation

批量生视频：

```bash
"$AWB_CMD" auth-status -f json
"$AWB_CMD" video-models
"$AWB_CMD" model-options --modelGroupCode <g>
"$AWB_CMD" video-create-batch --inputFile ./video-batch.json --modelGroupCode <g> --dryRun true -f json
"$AWB_CMD" video-create-batch --inputFile ./video-batch.json --modelGroupCode <g> -f json
```

规则：

- 先 `--dryRun true`
- 输入文件优先 JSON / JSONL
- 通用默认参数放命令行，单条差异写进输入文件
