# anime-workbench-cli

[中文](./README.md) | [English](./README.en.md)

Terminal tooling repository for the LingJing AI Anime Workbench platform.

## Before You Start

Before using the CLI, make sure you have registered an account on the official Anime Workbench website and linked your WeChat account:

- https://animeworkbench.lingjingai.cn/home

The CLI currently recommends signing in with a WeChat QR code.

If your official site account is not yet linked to WeChat, finish registration and binding on the website first, then continue with the install and login steps below.

This repository currently contains four layers:

- `opencli frontend`: plugin entry for `opencli`, still compatible with `opencli awb ...`
- `@lingjingai/awb-cli`: standalone CLI entry, with command name `awb`
- `@lingjingai/awb-core`: shared core SDK for auth, uploads, model lookup, and task logic
- `skills/awb`: skill docs, workflows, compatibility metadata, and update scripts for agents

Project layout:

```text
.
├── index.js                  # opencli plugin entry
├── install.mjs              # opencli plugin installer
├── packages/
│   ├── awb-core/            # shared core
│   └── awb-cli/             # standalone CLI
├── skills/awb/              # agent skill bundle
├── docs/                    # release/update docs
├── README.md
└── README.en.md
```

Update mechanism docs:

- [docs/update-mechanism.md](./docs/update-mechanism.md)
- [docs/repository-architecture.md](./docs/repository-architecture.md)
- [CHANGELOG.md](./CHANGELOG.md)

## Install

### Standalone CLI (Recommended)

For agents, e2b, CI, and normal terminal usage, install the standalone command first:

```bash
npm install -g @lingjingai/awb-cli
awb --help
```

When developing from this repository:

```bash
npm install -g ./packages/awb-core ./packages/awb-cli
awb --help
```

### opencli Plugin

Prerequisite:

```bash
npm install -g @jackwener/opencli
```

Install from GitHub:

```bash
npm install -g github:LingJingAI-Labs/anime-workbench-cli
```

Or:

```bash
npm install -g git+https://github.com/LingJingAI-Labs/anime-workbench-cli.git
```

After installation, `postinstall` automatically places the plugin under `~/.opencli/plugins/awb` and syncs the Agent skill to `~/.cc-switch/skills/awb`.

`opencli awb` is the compatibility entry. The standalone `awb` command is the preferred polished entry with the brand banner and grouped help.

Verify installation:

```bash
opencli awb --help
```

If the standalone CLI does not yet have its own local session, it reuses the existing AWB auth and project-group state to avoid duplicate login. Supported legacy paths include:

- `~/.opencli/awb-auth.json`
- `~/.opencli/awb-state.json`
- `~/.animeworkbench_auth.json`

If multiple records exist, the CLI picks the newest one with the freshest token.

## Local Development

```bash
cd /path/to/anime-workbench-cli
npm install -g .
```

Or refresh the local plugin install directly:

```bash
node /path/to/anime-workbench-cli/install.mjs
```

Validate code:

```bash
npm run check
```

Sync versions:

```bash
npm run version:sync -- 0.1.1
```

Validate skill metadata:

```bash
npm run check
```

## Skill / Agent Usage

Skill entry files:

- `skills/awb/SKILL.md`
- `skills/awb/compat.json`
- `skills/awb/VERSION`

Skill updates:

```bash
bash skills/awb/scripts/check-update.sh
bash skills/awb/scripts/update.sh
```

If your Agent uses a custom skill directory, set `AWB_SKILL_INSTALL_DIR=/path/to/awb` before installing or updating.

Skill workflows only keep atomic basic usage, for example:

- simple text-to-image
- reference image generation / multi-reference image generation
- batch image generation
- first-frame video
- first-last-frame video
- multi-reference video
- storyboard video
- batch video generation

## Login

For automation, e2b, and CI, use an AWB access key directly. This avoids QR login and token refresh:

```bash
export AWB_ACCESS_KEY=<access_key>
# Legacy alias: AWB_CODE=<access_key>

awb auth-status -f json
awb me -f json
```

You can also save the access key to the local AWB auth file with `0600` permissions:

```bash
opencli awb login-key --accessKey <access_key>
# when the env var is already set:
opencli awb login-key --fromEnv true
# save without online verification:
opencli awb login-key --accessKey <access_key> --skipVerify true
```

On startup, the CLI looks upward from the current directory for the nearest `.env` and never overrides existing shell environment variables:

```dotenv
AWB_ACCESS_KEY=<access_key>
# AWB_CODE=<access_key>  # legacy alias; not a user_id
```

After registering on the official website and linking WeChat, sign in by scanning the QR code in terminal:

```bash
opencli awb login-qr
```

Only print the QR URL without waiting:

```bash
opencli awb login-qr --waitSeconds 0 -f json
```

Phone verification-code login:

```bash
opencli awb send-code --phone 13800138000 --captchaVerifyParam '<aliyun-captcha>'
opencli awb phone-login --phone 13800138000 --code 123456
```

## Teams And Project Groups

Inspect current account, team, and project group:

```bash
opencli awb me -f json
opencli awb points -f json
```

Switch team:

```bash
opencli awb teams -f json
opencli awb team-select --groupId <groupId> -f json
```

Manage project groups:

```bash
opencli awb project-groups -f json
opencli awb project-group-current -f json
opencli awb project-group-users -f json
opencli awb project-group-create --name "CLI Project" -f json
opencli awb project-group-select --projectGroupNo <projectGroupNo> -f json
```

Project / e2b sandbox usage summary:

```bash
opencli awb usage-summary \
  --projectGroupNo <projectGroupNo> \
  --since "2026-04-27 00:00:00" \
  --startProjectPointBalance 10000 \
  --pointPriceYuan 0.01 \
  -f json

# Or inject env vars from the backend and query directly
AWB_PROJECT_GROUP_NO=<projectGroupNo> \
AWB_USAGE_STARTED_AT=1777219200000 \
AWB_START_PROJECT_POINT_BALANCE=10000 \
AWB_POINT_PRICE_YUAN=0.01 \
opencli awb usage-summary -f json
```

## Model Discovery

List image models:

```bash
opencli awb image-models
```

List video models:

```bash
opencli awb video-models
```

Filter by name:

```bash
opencli awb image-models --model "Nano Banana"
opencli awb video-models --model "可灵 3.0"
```

Inspect model parameters, constraints, and recommended CLI usage:

```bash
opencli awb model-options --modelGroupCode <modelGroupCode>
```

## Uploads

Upload local files to the media bucket:

```bash
opencli awb upload-files --files ./ref.webp -f json
opencli awb upload-files --files ./frame.webp --sceneType material-video-create -f json
```

The result includes both `backendPath` and `signedUrl`.

## Image Creation

Estimate fee:

```bash
opencli awb image-fee \
  --modelGroupCode <modelGroupCode> \
  --prompt "一位赛博风格少女站在霓虹街头" \
  --quality 1K \
  --ratio 16:9 \
  --generateNum 1
```

Create image task:

```bash
opencli awb image-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "一位赛博风格少女站在霓虹街头" \
  --quality 1K \
  --ratio 16:9 \
  --generateNum 1 \
  --dryRun true
```

Multi-reference for Banana-family models:

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

Batch image creation:

```bash
opencli awb image-create-batch \
  --inputFile ./image-batch.json \
  --modelGroupCode <modelGroupCode> \
  --concurrency 2 \
  --dryRun true -f json
```

## Video Creation

Frame-based mode:

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

Prompt-only mode (supported by some models only):

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --prompt "雨夜街头，人物缓慢走向镜头，电影感" \
  --quality 720 \
  --generatedTime 5 \
  --ratio 16:9 \
  --dryRun true
```

Reference-based video mode:

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

Storyboard mode:

```bash
opencli awb video-create \
  --modelGroupCode <modelGroupCode> \
  --storyboardPrompts "镜头1：城市远景||镜头2：人物走近镜头" \
  --quality 720 \
  --generatedTime 5 \
  --ratio 16:9 \
  --dryRun true
```

Batch video creation:

```bash
opencli awb video-create-batch \
  --inputFile ./video-batch.json \
  --modelGroupCode <modelGroupCode> \
  --concurrency 2 \
  --dryRun true -f json
```

## Task Status

Query task feeds:

```bash
opencli awb tasks --taskType IMAGE_CREATE -f json
opencli awb tasks --taskType VIDEO_GROUP -f json
```

Wait for a specific task:

```bash
opencli awb task-wait --taskId <taskId> --taskType IMAGE_CREATE -f json
opencli awb task-wait --taskId <taskId> --taskType VIDEO_GROUP -f json
```

## Notes

Recommended workflow:

```bash
opencli awb video-models --model "可灵 3.0"
opencli awb model-options --modelGroupCode <modelGroupCode>
opencli awb video-create ... --dryRun true
opencli awb video-create ...
```

`dryRun` builds the real request and calls the fee-estimation endpoint, but does not submit the final creation task.
