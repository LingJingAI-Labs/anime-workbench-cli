# Task Module

查任务状态、等任务结果。

## 1. 何时使用

- 异步提交后（`image-create` / `video-create` 没加 `--waitSeconds`），拿 `taskId` 等结果
- 想看最近的任务列表（历史 / 同团队协作）
- 解耦创作与等待（并发多任务、脚本分阶段）

## 2. 核心概念

- **taskType**：任务分类，决定 `tasks` / `task-wait` 查哪张表。常见：
  - `IMAGE_CREATE`：生图
  - `VIDEO_CREATE`：单次生视频
  - `VIDEO_GROUP`：视频任务组（多数生视频命令走这个）
  - `IMAGE_EDIT`：图像编辑
- **taskId**：创作命令返回的任务 ID，用来查 / 等结果
- 任务挂在**项目组**下，默认查当前项目组；跨项目组用 `--projectGroupNo`

## 3. 命令

| 命令 | 用途 | 路由提醒 |
|------|------|----------|
| `tasks --taskType <t>` | 列出最近任务 | `--pageSize 20`（默认）；`--minTime <ms>` 查某时间点之前 |
| `task-wait --taskId <id> --taskType <t>` | 阻塞等单个任务完成 | `--waitSeconds 300`（默认）；完成后返回 `firstResultUrl` / `resultFileList` |

## 4. 常用写法

```bash
# 1) 异步提交：只拿 taskId
TASK_ID=$("$AWB_CMD" image-create --modelGroupCode <g> --prompt "..." -f json | jq -r '.taskId')

# 2) 单独等结果
"$AWB_CMD" task-wait --taskId "$TASK_ID" --taskType IMAGE_CREATE --waitSeconds 180 -f json

# 看最近的生图任务
"$AWB_CMD" tasks --taskType IMAGE_CREATE --pageSize 20 -f json

# 看最近的生视频任务组
"$AWB_CMD" tasks --taskType VIDEO_GROUP --pageSize 20 -f json

# 跨项目组查
"$AWB_CMD" tasks --taskType IMAGE_CREATE --projectGroupNo <other> -f json

# 查某个时间点之前
"$AWB_CMD" tasks --taskType IMAGE_CREATE --minTime 1735689600000 -f json
```

## 5. 经验引导

- **什么时候同步 vs 异步**：
  - 单任务、一次性脚本 → 直接 `image-create/video-create --waitSeconds 120/180`，简单
  - 并发多任务 / agent 驱动 → 拆两步，`image-create` / `video-create` 不等结果 → 并发拿多个 `taskId` → 再逐个 / 并发 `task-wait`
  - 长任务（视频 / Token 计费 / 高复杂度） → 异步更稳
- **`taskType` 选对了没？** 大部分生视频命令完成后会回到 `VIDEO_GROUP`，不是 `VIDEO_CREATE`；查错类型会看不到任务。`image-create` / `image-edit` 分开。
- **结果字段**：
  - `firstResultUrl`：首张 / 首段 URL，适合直接消费
  - `resultFileList`：全部结果 URL 数组
  - `resultFileDisplayList`：含展示名
- **超时不等于失败**：`task-wait --waitSeconds 180` 超时只是本次轮询结束；任务仍在排队 / 执行。重新 `task-wait` 或看 `tasks` 里的 `任务状态`。
- **`--minTime` 是毫秒时间戳上界**：表示"这个时间之前"；想看最近 N 条直接默认即可，不需要算时间戳。
- **别让 `task-wait` 把整段 JSON 回显给用户**：结果 URL 列表可能很长；只回首个结果 + 数量。
