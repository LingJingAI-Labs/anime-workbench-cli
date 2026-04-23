# Billing Module

积分、充值、兑换、发票。AWB 的计费核心在**项目组**层。

## 1. 何时使用

- 查看团队 / 项目组积分余额与上限
- 创作前预估消耗（见 [`modules/image.md`](image.md) / [`modules/video.md`](video.md) 的 `*-fee`）
- 买积分包 / 兑换积分码
- 申请开票
- 排查"团队有积分但创作失败"

## 2. 核心概念

- **团队积分 vs 项目组积分**：团队积分池是总池；项目组额度从 `projectPointMax` 切下来用。
- **上限而非真实余额**：`projectPointMax` 是上限；`projectPointBalance` 才是当前可用余额。上限为 0 表示无限制（跟随团队池）。
- **积分包只发到团队池**：买入 / 兑换都进团队，之后通过 `project-group-update --point N` 把额度分到项目组。
- **发票走飞书表单**：`invoice-apply` 复用本地 Dia / Chrome 飞书登录态，CLI 不负责登录飞书。

## 3. 命令

| 命令 | 用途 | 路由提醒 |
|------|------|----------|
| `points` | 一次看齐团队 + 项目组积分 | 创作失败先跑这个 |
| `point-packages` | 列出可买积分套餐（`packageNo` + 价格） | 充值前用来拿 `packageNo` |
| `point-purchase --packageNo <p>` | 下单并渲染微信二维码 | `--waitSeconds 120` 可阻塞等支付完成 |
| `point-pay-status --rechargeNo <r>` | 查订单支付状态 | 异步 / 多端场景用 |
| `point-records` | 查积分流水 | `--operation 消耗 / 获得 / 全部`；默认最近 10 条 |
| `redeem --code XXXX-XXXX-XXXX-XXXX` | 兑换积分码（进团队池） | 格式严格：16 位四段；只影响团队积分 |
| `invoice-apply` | 提交开票申请 | 需要已在浏览器登过飞书；必填 10+ 字段，用 `--dryRun true` 先过一遍 |

## 4. 常用写法

```bash
# 排查积分
"$AWB_CMD" points -f json
"$AWB_CMD" project-group-current -f json   # 看 projectPointMax vs Balance
"$AWB_CMD" point-records --operation 消耗 -f json

# 提高项目组上限（不改团队池）
"$AWB_CMD" project-group-update --point 2000

# 买积分：选包 → 下单 → 轮询
"$AWB_CMD" point-packages -f json
"$AWB_CMD" point-purchase --packageNo b7ab4b0f3ce1495d860c7bc034f2ab2f --waitSeconds 120
# 或异步
"$AWB_CMD" point-pay-status --rechargeNo dc4cad9604164acc8d0b8a7753c09278 --waitSeconds 60

# 兑换码（16 位四段）
"$AWB_CMD" redeem --code XXXX-XXXX-XXXX-XXXX

# 开票（建议 --dryRun true 先预览一遍参数）
"$AWB_CMD" invoice-apply \
  --amountYuan 98.00 --invoiceType 普通发票 --subjectType 企业 \
  --buyerName "XX 公司" --buyerTaxNo 91310000XXXXXXXXX \
  --remark "2026年4月充值" --proofFile ./payment.png \
  --tradeNo 42000025XXXXXXXX --phone 13800138000 \
  --email finance@x.com --wechatName x-finance \
  --dryRun true -f json
```

## 5. 经验引导

- **"团队够但项目组不够" 是最常见翻车**：先 `points -f json` 对比两个数字；再看 `projectPointMax`——上限低于余额需求也会拒绝创作。用 `project-group-update --point <更大>` 调整。
- **`point-purchase` 渲染的是微信二维码**：终端要能渲染（`--qrSize 28~32` 调大）。如果 SSH 里显示糊，直接把返回 JSON 里的二维码链接在浏览器打开扫。
- **`--waitSeconds 120` 只阻塞本进程**：支付可以在手机上完成；脚本阻塞期间不要打断，或用 `point-pay-status` 异步模式。
- **`redeem` 只进团队池**：个人 / 项目组维度不会变化；兑换后通常还要 `project-group-update --point` 再分配。
- **`invoice-apply` 踩坑多**：
  - 必填 10+ 字段，遗漏会直接报错，先 `--dryRun true` 做一次干跑
  - 需要已有飞书登录态（Dia / Chrome 里登过飞书并打开过开票表单）
  - 专票写 `--invoiceType 专票` 或 `增值税专用发票` 都接受
  - `--remark` 必填；没有备注也要显式 `--remark 无`
- **`point-records --current N --size M`**：翻历史流水时分页；不要不带 size 裸跑，默认只 10 条看不出趋势。
