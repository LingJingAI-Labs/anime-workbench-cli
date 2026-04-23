# Upload Module

两种素材：**普通素材**（一次性引用）与 **主体素材**（可复用的角色 / 人物，仅内部员工）。

## 1. 何时使用

- 本地有图 / 视频 / 音频，要作为参考素材喂给创作命令
- 已经上传过、有 `素材路径` / `backendPath`，想复用
- 注册一个可复用主体（多视频共享同一角色 / 人物），仅内部员工

## 2. 核心概念

- **普通素材**（`upload-files`）：把本地文件登记到素材桶，返回 `素材路径`（= backendPath）。适合一次性引用。
- **主体素材**（`subject-upload`，仅内部）：多张参考图一起注册为一个"主体"，拿到 `subjectId`（格式 `asset-xxx`），后续靠 `@角色名` + `--refSubjects "角色=asset-..."` 稳定引用。
- **Files 后缀 vs 无 Files**：创作命令里
  - `--irefFiles` / `--crefFiles` / `--srefFiles`：本地文件，CLI **自动上传**后引用
  - `--iref` / `--cref` / `--sref`：已经在素材桶里的 backendPath，直接复用
- **`upload-files.sceneType`**：决定素材归类（`material-image-draw` 生图池 / `material-video-create` 生视频池）。默认 `material-image-draw`。

## 3. 命令

| 命令 | 用途 | 路由提醒 |
|------|------|----------|
| `upload-files --files a.png,b.png` | 通用文件上传（图 / 视频 / 音频） | 输出列 `素材路径` 就是 backendPath；要传给生视频池，加 `--sceneType material-video-create` |
| `subject-upload`（**仅内部员工**） | 把角色 / 人物注册成可复用主体 | 必读 [`../references/subject-upload.md`](../references/subject-upload.md)；返回"引用写法"列可直接粘到 `--refSubjects` |

## 4. 常用写法

```bash
# 通用上传（生图池）
"$AWB_CMD" upload-files --files ./ref.webp -f json
# 生视频池：场景字段不同，上传后可用作视频参考
"$AWB_CMD" upload-files --files ./motion.mp4 --sceneType material-video-create -f json

# 创作命令里复用已上传的 backendPath
"$AWB_CMD" image-create --modelGroupCode <g> --prompt "..." \
  --iref "/material/20260423/xxx.webp" -f json

# 主体素材：四角度一次性注册（仅内部）
"$AWB_CMD" subject-upload --name 小莉 \
  --primaryFile ./three-view.png \
  --faceFile ./front.png --sideFile ./side.png --backFile ./back.png \
  --projectName demo -f json
# 下一步：直接从输出的"引用写法"列粘到 --refSubjects
"$AWB_CMD" video-create --modelGroupCode <g> --prompt "@小莉 对镜说话" \
  --refSubjects "小莉=asset-xxxxxxxx" --refAudioFiles "小莉=./voice.mp3" \
  --quality 720 --generatedTime 5 --ratio 9:16 -f json
```

## 5. 经验引导

- **不要手工拼接主体引用**：`subject-upload` 输出有一列"引用写法"（`nextRefSubject`），已经是 `角色=asset-xxx` 的现成字符串——直接粘到 `--refSubjects`，不要用"主体ID"列再手拼一次（容易错）。
- **普通用户用 `upload-files`，不要绕 `subject-upload`**：后者只对内部员工开放，会直接抛"仅对内部员工开放"。
- **`*Files` 是一次性上传快捷方式**：创作命令里 `--irefFiles ./a.webp` 会自动上传再引用；已经有 backendPath 的 → 用 `--iref "<backendPath>"`，省一次上传。
- **同一组素材别重复上传**：`subject-upload` 支持 `--primaryUrl` / `--faceUrl` / `--sideUrl` / `--backUrl` 直接传已在 COS 的 URL。
- **素材组命名**：`subject-upload` 默认按 `projectName + name + stateKey` 拼素材组名；同项目同角色再次上传会复用，换 `stateKey` 产生新版本；想完全自定义用 `--groupName`。
- **`primaryFile` 不必是三视图**：名字是历史兼容（`--threeViewFile` 是它的别名）；一张稳定正面照也 OK，有正 / 侧 / 背再一起补齐。
- **`refImagesJson` / `refSubjectsJson` 是"我就是想手写 JSON"的逃生口**：一般不用；常规写 `--refImageFiles "名=./a.webp"` / `--refSubjects "名=asset-..."` 更清晰。
