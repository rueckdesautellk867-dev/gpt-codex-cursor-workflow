# 复制到其它项目

本文说明如何把本仓库的 GPT + Codex + Cursor 三方闭环模板复制到其它项目。

## 目标

把以下能力带到目标项目：

- 仓库级 AI 协作规则
- Cursor 协作规则
- 任务单与 backlog
- 验证层与 CI 本地复现脚本
- 风险审批层
- 运行手册
- PR 检查清单

## 推荐方式

优先使用脚本复制基础骨架：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\copy-workflow-template.ps1 -TargetPath "D:\目标项目"
```

默认不会覆盖目标项目已有文件。需要覆盖时显式加 `-Force`：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\copy-workflow-template.ps1 -TargetPath "D:\目标项目" -Force
```

## 复制内容

脚本会复制：

- `AGENTS.md`
- `PR_CHECKLIST.md`
- `.cursor/rules/ai-workflow.mdc`
- `.github/workflows/ci.yml`
- `scripts/ci-check.ps1`
- `docs/ai-task-routing.md`
- `docs/ai-workflow.md`
- `docs/ci.md`
- `docs/definition-of-done.md`
- `docs/risk-approval.md`
- `docs/runbook.md`
- `docs/task-template.md`
- `docs/verification.md`
- `tasks/README.md`

脚本会创建目标项目专用 starter 文件：

- `README.md`
- `docs/project-status.md`
- `docs/pilot-log.md`
- `tasks/backlog.md`

脚本不会复制：

- `docs/project-status.md`
- `docs/release-notes.md`
- `docs/pilot-log.md`
- `docs/remote-repo-plan.md`
- 已完成的历史任务单 `tasks/T*.md`
- 当前仓库历史 backlog
- 示例文档和 PR 测试文档

这些文件包含本仓库自己的历史，不应直接带入目标项目。

## 复制后必须改

复制完成后，在目标项目里至少检查：

1. `README.md` 是否需要加入文档索引。
2. `tasks/backlog.md` 是否要清空历史任务，只保留目标项目自己的任务。
3. `.github/workflows/ci.yml` 是否适合目标项目平台。
4. `scripts/ci-check.ps1` 的必需文件列表是否匹配目标项目。
5. `docs/risk-approval.md` 的高风险类型是否需要补充业务特定风险。

## 验证

在目标项目根目录运行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

如果目标项目不是纯文档仓，先把 CI 扩展为项目真实检查，例如：

- lint
- 类型检查
- 单元测试
- 构建检查
- 安全扫描

## 高风险原则

复制模板不等于允许执行高风险任务。

目标项目仍必须遵守：

- 高风险先人工确认
- 自动化测试不能替代人工审批
- 生产、权限、支付、数据库、真实用户数据相关任务必须单独评估

## 首次落地建议

1. 复制模板。
2. 新建一个低风险文档任务。
3. 跑本地 CI。
4. 开 PR 让 `Docs validation` 跑一次。
5. 确认目标项目的 `main` 分支保护策略。
