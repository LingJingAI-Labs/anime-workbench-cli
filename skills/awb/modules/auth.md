# Auth Module

管理本地登录态与账号登录方式。**所有自动化流程都应先确认 `auth-status`**，再进下一步。

## 1. 何时使用

- 开始任何 AWB 流程前做状态检查
- CLI 报"未登录 / token 过期"
- 换账号 / 换设备 / 脚本 agent 首次初始化
- 官网账号刚刚绑微信，需要让 CLI 拿 token

## 2. 登录前提

- 先在官网完成注册并绑定微信：`https://animeworkbench.lingjingai.cn/home`
- 没绑微信 → CLI 的 `login-qr` 会回 `needBind`，得先回官网绑定
- 其他登录方式（`send-code` / `phone-login`）需要网页端生成的 `captchaVerifyParam`，不适合脚本；除非账号本身没绑微信才考虑

## 3. 命令

| 命令 | 用途 | 路由提醒 |
|------|------|----------|
| `auth-status` | 查看登录状态 / token 是否过期 / 过期时间 | 默认第一步，用 `-f json` 方便 agent 判断 |
| `login-qr` | 微信扫码登录（推荐） | 终端直接渲染二维码；`--waitSeconds 180` 阻塞等扫码；`--qrSize 32` 放大 |
| `login-qr-status` | 异步轮询某次扫码会话 | 用 `login-qr --waitSeconds 0 -f json` 拿到 `sceneStr` 后配合使用；适合脚本 / agent |
| `send-code` | 发送手机验证码 | 需要网页端 `captchaVerifyParam`；脚本不适合裸用，建议走网页 |
| `phone-login` | 手机号 + 验证码登录 | 搭配 `send-code`；实操基本只在账号未绑微信时用 |
| `bind-phone` | 绑定手机号 | `login-qr` 返回 `needBind` 时走；不传 `--tempToken` 会自动用上次扫码留下的 |
| `auth-clear` | 清空本地 token | 破坏性；下次要重新登录，操作前确认用户意图 |

## 4. 常用写法

```bash
# 入口状态检查
"$AWB_CMD" auth-status -f json

# 同步扫码登录
"$AWB_CMD" login-qr

# 异步扫码（agent 适用）：先拿 sceneStr，再独立轮询
"$AWB_CMD" login-qr --waitSeconds 0 -f json          # 取 sceneStr
"$AWB_CMD" login-qr-status --sceneStr <sceneStr> --waitSeconds 180 -f json

# 扫码后若 needBind
"$AWB_CMD" bind-phone --phone 13800138000 --code 123456

# 清本地 token（谨慎）
"$AWB_CMD" auth-clear
```

## 5. 经验引导

- **第一步永远是 `auth-status -f json`**：即使用户刚登过，token 也可能半小时内过期。别假设登录态。
- **扫码强烈优先**：手机验证码路径需要网页端阿里云 captcha，CLI 不负责，脚本里走不通。
- **needBind 是独立状态**：`login-qr` 成功但返回 `needBind=true` 时说明官网账号还没绑微信；此时把用户引去官网绑定，比裸跑 `bind-phone` 更稳。
- **`login-qr-status` 是 agent 友好模式**：在长驻 agent 里，不要占着 `login-qr` 阻塞终端；改成"取 sceneStr → 轮询 status"两步，期间可以干别的。
- **`--waitSeconds 0`**：在任何 `login-qr*` / `task-wait` 上都意味"只拿一次结果，不阻塞"。
- **`auth-clear` 不等于登出会话**：只清本地 token，服务端会话仍存在；重新扫码即可恢复。
