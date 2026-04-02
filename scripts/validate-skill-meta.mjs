#!/usr/bin/env node
import fs from 'node:fs/promises';
import path from 'node:path';

const rootDir = process.cwd();

async function readJson(relativePath) {
  const text = await fs.readFile(path.join(rootDir, relativePath), 'utf8');
  return JSON.parse(text);
}

async function readText(relativePath) {
  return (await fs.readFile(path.join(rootDir, relativePath), 'utf8')).trim();
}

const rootPkg = await readJson('package.json');
const corePkg = await readJson('packages/awb-core/package.json');
const cliPkg = await readJson('packages/awb-cli/package.json');
const skillVersion = await readText('skills/awb/VERSION');
const compat = await readJson('skills/awb/compat.json');

const problems = [];

if (rootPkg.version !== corePkg.version || rootPkg.version !== cliPkg.version) {
  problems.push(`package versions diverged: root=${rootPkg.version}, core=${corePkg.version}, cli=${cliPkg.version}`);
}
if (skillVersion !== compat.skillVersion) {
  problems.push(`skill version mismatch: VERSION=${skillVersion}, compat.skillVersion=${compat.skillVersion}`);
}
if (cliPkg.version !== compat.minCliVersion) {
  problems.push(`CLI compatibility mismatch: cli=${cliPkg.version}, compat.minCliVersion=${compat.minCliVersion}`);
}
if (rootPkg.version !== compat.minPluginVersion) {
  problems.push(`plugin compatibility mismatch: plugin=${rootPkg.version}, compat.minPluginVersion=${compat.minPluginVersion}`);
}

if (problems.length) {
  for (const line of problems) {
    process.stderr.write(`${line}\n`);
  }
  process.exit(1);
}

process.stdout.write(`skill metadata ok (${skillVersion})\n`);
