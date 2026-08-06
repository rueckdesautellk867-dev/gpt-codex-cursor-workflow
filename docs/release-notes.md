# 版本记录（Release Notes）

三方闭环整合项目里程碑。提交 hash 来自本地 `git log`。

## v0.1 — 初始化三方闭环规则

- **版本目标**：建立 GPT + Codex + Cursor 规则、清单与示例试跑基础
- **主要文件**：`AGENTS.md`、`.cursor/rules/ai-workflow.mdc`、`PR_CHECKLIST.md`、`README.md`、`docs/ai-workflow.md`、`docs/definition-of-done.md`、`docs/task-template.md`、`docs/ai-task-routing.md`、`docs/pilot-log.md`、`docs/examples/*`
- **提交 hash**：`f870389`（`docs: initialize GPT Codex Cursor workflow`）
- **状态**：已发布

## v0.2 — 新增任务执行层

- **版本目标**：`tasks/` 可复用执行；T001–T004 入队（T004 门禁样例）
- **主要文件**：`tasks/README.md`、`tasks/backlog.md`、`tasks/T001`–`T004`、`README.md`、`docs/pilot-log.md`
- **提交 hash**：`880e14c`（`docs: add reusable task execution layer`）
- **状态**：已发布

## v0.3 — 新增验证层设计

- **版本目标**：统一验证类型与风险最低门槛；不接真实 CI
- **主要文件**：`docs/verification.md`、`tasks/T005-verification-layer.md`、`tasks/T006-ci-setup.md`、`tasks/backlog.md`
- **提交 hash**：`8265789`（`docs: define verification layer`）
- **状态**：已发布

## v0.4 — 新增风险审批流程

- **版本目标**：固化高风险禁止动作、审批字段与回滚要求
- **主要文件**：`docs/risk-approval.md`、`tasks/T007-risk-approval-layer.md`、`docs/ai-task-routing.md`
- **提交 hash**：`f4d2790`（`docs: add risk approval workflow`）
- **状态**：已发布

## v0.5 — 新增运行手册

- **版本目标**：固定启动→分流→执行→验证→审批→提交→归档顺序
- **主要文件**：`docs/runbook.md`、`tasks/T008-runbook-layer.md`、`docs/ai-workflow.md`
- **提交 hash**：`5e2d4c5`（`docs: add workflow runbook`）
- **状态**：已发布

## v0.6 — 新增项目交付包

- **版本目标**：归档能力、限制、下一步与版本记录，便于复制到其它项目
- **主要文件**：`docs/project-status.md`、`docs/release-notes.md`、`tasks/T009-project-delivery-package.md`
- **提交 hash**：`3cea8de`（`docs: add project delivery package`）
- **状态**：已提交

## v0.7 — 远程仓库准备层

- **版本目标**：明确远程平台选择、推送前检查与初始化步骤；不实际推送
- **主要文件**：`docs/remote-repo-plan.md`、`tasks/T010-remote-repo-plan.md`、`tasks/T011-remote-repo-push.md`
- **提交 hash**：`d497003`（`docs: plan remote repository setup`）
- **状态**：已提交

## v0.8 — 接入最小真实 CI

- **版本目标**：为文档型三方闭环模板接入可本地复现的 GitHub Actions 检查
- **主要文件**：`.github/workflows/ci.yml`、`scripts/ci-check.ps1`、`docs/ci.md`、`docs/verification.md`、`tasks/T006-ci-setup.md`
- **提交 hash**：`efd3556`（`ci: add docs validation workflow`）
- **状态**：已提交

## v0.9 — main 分支保护

- **版本目标**：让 `main` 进入 PR + CI 门禁流程，避免直接裸推绕过验证
- **主要文件**：`tasks/T012-branch-protection.md`、`tasks/backlog.md`、`docs/project-status.md`、`docs/pilot-log.md`
- **提交 hash**：`4e19740`（`docs: record branch protection setup`）
- **状态**：已提交

## v0.10 — PR + CI 冒烟验证

- **版本目标**：用真实 PR 验证分支推送、`Docs validation`、合并和本地同步链路
- **主要文件**：`tasks/T013-pr-ci-protection-smoke-test.md`、`tasks/backlog.md`、`docs/project-status.md`、`docs/pilot-log.md`
- **提交 hash**：`126fc6a`（`docs: record PR CI smoke test`）
- **状态**：已提交
