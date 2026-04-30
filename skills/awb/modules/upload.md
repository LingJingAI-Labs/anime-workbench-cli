# Upload Module

素材上传只解决“本地文件如何变成 AWB 可引用素材”。普通素材、Seedance 主体资产、创作命令里的 `*Files` 快捷上传不要混淆。

## 1. 三类入口

| 场景 | 用法 | 提醒 |
|------|------|------|
| 一次性本地参考 | 创作命令里的 `*Files` 字段 | CLI 会自动上传并引用；本地图片会自动转 webp 缓存，不覆盖原图 |
| 可复用普通素材 | `upload-files` | 返回 backendPath，后续用 URL/backendPath 字段复用 |
| Seedance 主体资产 | `subject-publish` / `subject-upload` | 只针对 Seedance 2.0 主体参考链路，需权限账号 |

做生视频参考素材时，普通上传要放到生视频素材池；具体 `sceneType` 看 `upload-files --help`。

## 2. 普通素材经验

- 已有 backendPath / URL 时直接复用，避免重复上传。
- **复用前序任务结果链接**：`image-create` / `video-create` / `tasks` / `task-wait` 返回的结果 COS 链接（公网可访问）可以直接作为后续命令的 `--refImageUrls` / `--refVideoUrls` / `--refAudioUrls` / `--frameUrl` / `--tailFrameUrl` / `--framesJson` 等 URL 字段输入，不需要先下载再 `upload-files`。仅在链接已过期、要长期归档、或目标命令明确要求原始平台链接（如 `seedance-subtitle-remove` 必须用火山 / Seedance 原始结果链接，不是 AWB 转存）时才重新上传。
- 本地图片上传前 CLI 会默认转 webp 并尽量压到 10MB 内；最终格式和大小限制仍以 `model-options` 为准。
- 视频、音频素材不要假设所有模型都能吃；先看目标模型参考模式和参数白名单。
- 对用户沟通时说“参考图片 / 场景参考 / 音频参考”，内部字段只在写命令时使用。

## 3. 主体素材经验

- 用户说真人短剧、同一角色多段复用，并且目标是 Seedance 2.0 / Fast 时，优先考虑主体资产链路。
- 场景图不是主体；通常作为普通命名参考素材传入。
- 返回结果里优先拿 `nextRefSubject`，它已经是完整引用写法，不要手拼 `asset-xxx`。
- 无主体权限、一次性试片、或非 Seedance 主体参考模型，退回普通 `refImageFiles` / `refImageUrls`。
- 敏感人设词容易卡审核时，素材组名和描述用中性代码名。

## 4. 批量与恢复

- 多个主体注册用 `subject-publish-batch`，先 dry-run，再保存返回的引用写法。
- 普通素材批量上传后，把 backendPath 写入后续批量生成文件，别只留在终端输出里。
- 沙箱可能关闭时，任何要跨步骤复用的素材 ID / backendPath / 主体引用都应落到项目文件或任务台账。
