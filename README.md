# opencli-plugin-awb

灵境AI Anime Workbench 平台 CLI 插件。  
CLI plugin for the LingJing AI Anime Workbench platform.

这个插件把 `animeworkbench.lingjingai.cn` 的常用能力带到终端里，适合在 shell、脚本和 agent 流程里直接调用。  
This plugin brings common Anime Workbench workflows into the terminal for shell, scripting, and agent use.

## 安装 / Install

前置依赖 / Prerequisite:

```bash
npm install -g @jackwener/opencli
```

从 GitHub 安装 / Install from GitHub:

```bash
npm install -g github:LingJingAI-Labs/opencli-plugin-awb
```

或 / Or:

```bash
npm install -g git+https://github.com/LingJingAI-Labs/opencli-plugin-awb.git
```

安装完成后，`postinstall` 会自动把插件放到 `~/.opencli/plugins/awb`。  
After installation, `postinstall` will place the plugin under `~/.opencli/plugins/awb`.

验证安装 / Verify:

```bash
opencli awb --help
```

## 本地开发 / Local Development

```bash
cd /Users/zheyong/Developer/opencli-plugin-awb
npm install -g .
```

或直接刷新本地插件安装 / Or refresh the local plugin install directly:

```bash
node /Users/zheyong/Developer/opencli-plugin-awb/install.mjs
```

## 登录 / Login

终端微信扫码登录 / WeChat QR login in terminal:

```bash
opencli awb login-qr
```

只返回二维码链接，不等待 / Only print the QR URL without waiting:

```bash
opencli awb login-qr --waitSeconds 0 -f json
```

手机验证码登录 / Phone login:

```bash
opencli awb send-code --phone 13800138000 --captchaVerifyParam '<aliyun-captcha>'
opencli awb phone-login --phone 13800138000 --code 123456
```

## 团队与项目组 / Teams And Project Groups

查看当前账号、团队和项目组 / Inspect current account, team, and project group:

```bash
opencli awb me -f json
opencli awb points -f json
```

切换团队 / Switch team:

```bash
opencli awb teams -f json
opencli awb team-select --groupId <groupId> -f json
```

管理项目组 / Manage project groups:

```bash
opencli awb project-groups -f json
opencli awb project-group-current -f json
opencli awb project-group-users -f json
opencli awb project-group-create --name "CLI Project" -f json
opencli awb project-group-select --projectGroupNo <projectGroupNo> -f json
```

## 模型发现 / Model Discovery

列出图片模型 / List image models:

```bash
opencli awb image-models
```

列出视频模型 / List video models:

```bash
opencli awb video-models
```

按名称过滤 / Filter by name:

```bash
opencli awb image-models --model "Nano Banana"
opencli awb video-models --model "可灵 3.0"
```

查看某个模型的参数、约束和推荐命令 / Inspect model parameters, constraints, and recommended CLI usage:

```bash
opencli awb model-options --modelGroupCode <modelGroupCode>
```

## 素材上传 / Uploads

上传本地文件到素材桶 / Upload local files to the media bucket:

```bash
opencli awb upload-files --files ./ref.webp -f json
opencli awb upload-files --files ./frame.webp --sceneType material-video-create -f json
```

返回值里会包含 `backendPath` 和 `signedUrl`。  
The result includes both `backendPath` and `signedUrl`.

## 图片生成 / Image Creation

积分预估 / Estimate fee:

```bash
opencli awb image-fee \
  --modelGroupCode <modelGroupCode> \
  --prompt "一位赛博风格少女站在霓虹街头" \
  --quality 1K \
  --ratio 16:9 \
  --generateNum 1
```

正式创建 / Create image task:

```bash
opencli awb image-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "一位赛博风格少女站在霓虹街头" \
  --quality 1K \
  --ratio 16:9 \
  --generateNum 1 \
  --dryRun true
```

Banana 系列多图参考 / Multi-reference for Banana-family models:

```bash
opencli awb image-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "参考图里的角色在雨夜奔跑" \
  --quality 1K \
  --ratio 16:9 \
  --generateNum 1 \
  --irefFiles "./a.webp,./b.webp" \
  --dryRun true
```

批量生图 / Batch image creation:

```bash
opencli awb image-create-batch \
  --inputFile ./image-batch.json \
  --modelGroupCode <modelGroupCode> \
  --concurrency 2 \
  --dryRun true -f json
```

## 视频生成 / Video Creation

首尾帧模式 / Frame-based mode:

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --frameFile ./first-frame.webp \
  --tailFrameFile ./last-frame.webp \
  --quality 720 \
  --generatedTime 5 \
  --ratio 16:9 \
  --dryRun true
```

纯提示词模式（仅部分模型） / Prompt-only mode (supported by some models only):

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "雨夜街头，人物缓慢走向镜头，电影感" \
  --quality 720 \
  --generatedTime 5 \
  --ratio 16:9 \
  --dryRun true
```

参考生视频模式 / Reference-based video mode:

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "@角色A 对镜说话" \
  --refImageFiles "角色A=./char.webp" \
  --refAudioFiles "角色A=./voice.mp3" \
  --quality 720 \
  --generatedTime 5 \
  --ratio 9:16 \
  --dryRun true
```

故事板模式 / Storyboard mode:

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --storyboardPrompts "镜头1：城市远景||镜头2：人物走近镜头" \
  --quality 720 \
  --generatedTime 5 \
  --ratio 16:9 \
  --dryRun true
```

批量生视频 / Batch video creation:

```bash
opencli awb video-create-batch \
  --inputFile ./video-batch.json \
  --modelGroupCode <modelGroupCode> \
  --concurrency 2 \
  --dryRun true -f json
```

## 任务查询 / Task Status

查询任务流 / Query task feeds:

```bash
opencli awb tasks --taskType IMAGE_CREATE -f json
opencli awb tasks --taskType VIDEO_GROUP -f json
```

等待任务完成 / Wait for a specific task:

```bash
opencli awb task-wait --taskId <taskId> --taskType IMAGE_CREATE -f json
opencli awb task-wait --taskId <taskId> --taskType VIDEO_GROUP -f json
```

## 说明 / Notes

推荐流程 / Recommended workflow:

```bash
opencli awb video-models --model "可灵 3.0"
opencli awb model-options --modelGroupCode <modelGroupCode>
opencli awb video-create ... --dryRun true
opencli awb video-create ...
```

`dryRun` 会构造真实请求并调用积分估算接口，但不会真正提交创作任务。  
`dryRun` builds the real request and calls the fee-estimation endpoint, but does not submit the final creation task.
