# Workspace Module

管理账号、团队、项目组。AWB 的积分、任务、作品都挂在**项目组**层；团队只是一层分组。

## 1. 何时使用

- 查看当前账号 / 团队 / 项目组
- 切团队 / 切项目组
- 新建项目组、修改项目组名称 / 积分上限
- 把团队成员加进项目组
- 创作失败、疑似权限或积分问题，先来这里定位是哪个项目组

## 2. 核心概念

- **团队（team / group）**：账号加入的上层组织，用 `groupId` 标识。一个账号可能在多个团队。
- **项目组（project group）**：团队内部的真正计费 / 权限单位，用 `projectGroupNo` 标识。积分余额、上限、作品任务都在这一层。
- **当前团队 / 当前项目组**：切换后会被 CLI 写进本地，后续所有命令默认用它们。
- `me` 能一口气看齐：用户名 / 权限 / 当前团队 / 当前项目组 / 团队积分 / 项目组积分 / 登录有效期。

## 3. 命令

| 命令 | 用途 | 路由提醒 |
|------|------|----------|
| `me` | 一页看齐当前账号 / 团队 / 项目组 / 积分 | 路由前做快速 sanity check 优先用这个 |
| `teams` | 列出可用团队 | 输出 `团队ID / 团队名称 / 关系类型 / 当前选中` |
| `team-select --groupId <id>` | 切换当前团队 | 切完通常得重确认 `project-group-current` |
| `project-groups` | 列出当前团队下的项目组 | 输出含"当前选中 / 最近使用" |
| `project-group-current` | 查看当前项目组详情（含积分） | 创作失败先来这里看 |
| `project-group-select --projectGroupNo <no>` | 切换项目组 | 所有后续创作 / `points` / `tasks` 都走它 |
| `project-group-create --name <x> --point <N>` | 新建项目组并切过去 | `--point` 是积分上限；`--userIds id1,id2` 直接加成员 |
| `project-group-update` | 改项目组名称或积分上限 | 不传 `--projectGroupNo` 默认改当前 |
| `project-group-users` | 列出可加入当前项目组的团队成员 | 列出来的才是可用 `--userIds` |

## 4. 常用写法

```bash
# 快速 sanity check
"$AWB_CMD" me -f json

# 切团队 → 切项目组（两步走）
"$AWB_CMD" teams -f json
"$AWB_CMD" team-select --groupId <groupId>
"$AWB_CMD" project-groups -f json
"$AWB_CMD" project-group-select --projectGroupNo <projectGroupNo>

# 建新项目组并放 1000 积分上限
"$AWB_CMD" project-group-create --name "CLI 项目组" --point 1000 --userIds id1,id2

# 加人：先看谁能加
"$AWB_CMD" project-group-users -f json
# 再 update 或 create 时带上 --userIds

# 单次操作覆盖项目组（不切换）
"$AWB_CMD" image-create --modelGroupCode <g> --prompt "..." --projectGroupNo <projectGroupNo> -f json
```

## 5. 经验引导

- **创作失败 90% 的情况不是团队积分，是项目组**：`points` 能同时显示团队与项目组余额，重点看项目组；项目组余额够但 `projectPointMax` 过低也会挡创作。
- **`project-group-current` 是定位神器**：team 切换、agent 并发、多账号共机时，先跑这个，不要假设。
- **`--projectGroupNo` 是覆盖参数**：几乎所有创作 / 查询命令都支持，临时跑到另一个项目组不用真切换。
- **新建项目组默认 `--point 0`**：等于无上限 / 跟随团队；想限额就显式传 `--point N`。
- **`--userIds` 只能从 `project-group-users` 的结果里选**：直接塞其他 userId 会失败。
- **切团队后项目组不会跟着走**：切完团队 CLI 会自动挑一个"最近使用"做项目组，但**必须** `project-group-current` 再核对一下。
- **`me` 是对话开头的经济操作**：一次请求顶 `teams` + `project-group-current` + `points` 三次能看到的主信息。
