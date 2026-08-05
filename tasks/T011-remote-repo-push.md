# T011 创建远程仓库并推送 main

- **编号**：T011
- **状态**：已完成
- **风险等级**：中
- **推荐执行者**：人工确认后由 Cursor 或人工执行

> 方案见 [`docs/remote-repo-plan.md`](../docs/remote-repo-plan.md)。已获人工确认，远程推送已完成。

## 任务标题

创建远程仓库并推送 main（或约定主分支）

## 背景

准备方案已就绪；首次推送会暴露仓库内容、绑定平台账号，并影响后续协作与 CI，须人工确认平台与可见性后再做。

## 目标

在选定平台创建空仓库，配置 `origin`，推送主分支，确认远程文件完整，并启用分支保护（禁止直接推主分支）。

## 影响范围

- 模块 / 目录：Git remote 与远端仓库；不改业务代码
- 预计改动文件：本地可能仅有 git config 中的 remote；无业务文件变更预期
- 可能波及的调用方：后续 PR / CI / 协作者克隆地址

## 不做什么

- v0.7 及未审批前：不创建远程、不推送
- 不在本任务中配置完整 CI（交给 T006）
- 不强制公开仓库；可见性由审批决定
- 不把密钥推上远端

## 验收标准

- [x] 已按 `docs/risk-approval.md` / 本任务留下人工确认（平台、可见性、分支名）
- [x] `git remote -v` 指向约定仓库
- [x] 远端文件与本地关键目录一致
- [ ] 主分支保护待在 GitHub 网页配置（后续任务处理）

## 测试命令

```text
git status
git remote -v
# 浏览器或 gh/gl 核对远端文件列表
```

## 人工审批记录

- 审批人：用户
- 审批时间：2026-08-05
- 审批范围：连接 GitHub private repo 并推送当前项目 main 分支
- 允许执行的动作：改名 main、添加 origin、推送 main、更新任务状态
- 回滚方案：删除 origin 或删除远程仓库；本地可保留 git 历史
- 备注：平台 GitHub；仓库 `https://github.com/rueckdesautellk867-dev/gpt-codex-cursor-workflow.git`；Private；本地 `master` → `main`；CI 暂不接

## 完成后需要说明的内容

- remote URL（可打码敏感部分）、分支名、是否已开保护
- 是否需要人工确认：是（执行前必须）
