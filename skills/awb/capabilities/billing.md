# Billing

常用命令：

```bash
"$AWB_CMD" points -f json
"$AWB_CMD" point-packages -f json
"$AWB_CMD" point-records -f json
"$AWB_CMD" redeem --code XXXX-XXXX-XXXX-XXXX -f json
```

预算优先：

```bash
"$AWB_CMD" image-fee --modelGroupCode <g> --prompt "一只小狗" --quality 1K --ratio 16:9 --generateNum 1 -f json
"$AWB_CMD" video-fee --modelGroupCode <g> --prompt "镜头推进" --quality 720 --generatedTime 5 --ratio 16:9 -f json
```

规则：

- 不要只看团队积分，要看当前项目组积分
- 批量前先跑 fee 或 batch dry-run
