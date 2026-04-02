# Task Management

查询任务：

```bash
"$AWB_CMD" tasks --taskType IMAGE_CREATE -f json
"$AWB_CMD" tasks --taskType VIDEO_GROUP -f json
```

等待任务：

```bash
"$AWB_CMD" task-wait --taskId <taskId> --taskType IMAGE_CREATE -f json
"$AWB_CMD" task-wait --taskId <taskId> --taskType VIDEO_GROUP -f json
```

规则：

- `image-create` / `video-create` 可直接带 `--waitSeconds`
- 需要解耦流程时，先拿 `taskId`，后续单独 `task-wait`
