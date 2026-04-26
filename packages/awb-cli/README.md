# @lingjingai/awb-cli

独立的 LingJing AI Anime Workbench CLI。  
Standalone CLI for LingJing AI Anime Workbench.

开始使用前，请先确保你已经在 Anime Workbench 官网注册账号，并完成微信绑定：  
Before using the CLI, make sure you have registered an account on the official Anime Workbench website and linked your WeChat account:

- https://animeworkbench.lingjingai.cn/home

CLI 支持 access key 和微信扫码登录；自动化场景推荐 `AWB_ACCESS_KEY`（`AWB_CODE` 仅作旧别名，不是 user_id）。
The CLI supports access-key and WeChat QR login; use `AWB_ACCESS_KEY` for automation (`AWB_CODE` is only a legacy alias, not a user_id).

本地运行：

```bash
node bin/awb.js --help
```

登录示例：

```bash
export AWB_ACCESS_KEY=<access_key>
node bin/awb.js auth-status -f json

node bin/awb.js login-key --accessKey <access_key>
node bin/awb.js login-key --accessKey <access_key> --skipVerify true
node bin/awb.js login-qr
```


主体发布示例：

```bash
node bin/awb.js subject-publish --name 小莉 --primaryUrl /material/video-create/xxx-char.webp -f json
node bin/awb.js subject-publish-batch --inputFile ./subject-batch.json --dryRun true -f json
```

推荐工作流（真人主体参考生视频）：

```bash
# 1) 先把图放进生视频素材池
node bin/awb.js upload-files --files ./char.webp --sceneType material-video-create -f json

# 2) 再把 backendPath 注册成主体 asset id
node bin/awb.js subject-publish --name 小莉 --primaryUrl /material/video-create/xxx-char.webp -f json

# 3) 最后在 Seedance / Grok 里用 --refSubjects
node bin/awb.js video-create --modelGroupCode JiMeng_Seedance_2_Fast_VideoCreate_Group --prompt "@小莉 对镜说话" --refSubjects "小莉=asset-xxx" --quality 720 --generatedTime 5 --ratio 9:16
```
