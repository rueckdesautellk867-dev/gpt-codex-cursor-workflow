# 项目状态

便于把本仓库作为模板复制到其它项目时，先看清能力、限制与下一步。

| 项 | 内容 |
|----|------|
| 项目名称 | 三方闭环整合项目 |
| 当前版本 | v0.11 已完成，模板化复制落地包已建立 |
| 当前工作区 | `D:\三方闭环整合项目\` |
| 远程仓库 | `https://github.com/rueckdesautellk867-dev/gpt-codex-cursor-workflow.git` |

版本明细见 [`docs/release-notes.md`](release-notes.md)；操作顺序见 [`docs/runbook.md`](runbook.md)。

## 当前能力

| 层级 | 说明 | 入口 |
|------|------|------|
| 规则层 | GPT / Codex / Cursor 分工与仓库规则 | `AGENTS.md`、`.cursor/rules/ai-workflow.mdc`、`docs/ai-workflow.md` |
| 任务层 | 可复用任务单与 backlog | `tasks/`、`docs/task-template.md` |
| 验证层 | 风险对应的最低验证与交付字段 | `docs/verification.md` |
| CI 层 | GitHub Actions 与本地复现脚本 | `.github/workflows/ci.yml`、`docs/ci.md` |
| 风险审批层 | 高风险禁止动作与审批记录 | `docs/risk-approval.md` |
| 运行手册层 | 启动→归档的固定操作顺序 | `docs/runbook.md` |
| 模板复制层 | 复制到其它项目的说明与脚本 | `docs/template-rollout.md`、`scripts/copy-workflow-template.ps1` |

## 已验证事项

- 低风险任务可执行（文档类试跑与 T001–T003、T005、T007–T009 类任务）
- 高风险任务可识别并停在人工确认前（T004 保持 `待确认`）
- 任务可归档（`tasks/backlog.md`、`docs/pilot-log.md`）
- 提交记录清晰（v0.1–v0.8 均有独立记录，见 release-notes）
- 真实 CI 已接入：`Docs validation`
- `main` 分支保护已在 GitHub 网页开启
- PR #1 已验证分支推送、`Docs validation`、合并和本地同步链路
- 复制到其它项目的模板说明和本地复制脚本已建立
- 首次真实目标项目 `D:\AIContentFactory` 已完成模板复制和本地 CI 验证

## 当前限制

- 已接最小真实 CI（T006 已完成），当前覆盖文档链接、任务索引和关键文件检查
- 未接外部任务系统（仅仓库内 Markdown 任务）
- 未接云端部署
- 未接监控反馈
- 分支保护已开启；通过检查后的 PR 合并链路已验证。CI 失败时是否强制拦截尚未反向验证

## 下一步建议

1. 在 `D:\AIContentFactory` 创建第一个项目专用低风险任务，验证新骨架实际可用
2. 接入任务系统（如需与看板 / Issue 同步）
3. 如需更严格验证，可另开失败 PR 测试分支保护拦截
4. 设计阿里云测试环境（部署与反馈闭环另开任务，高风险须审批）

## 复制到其它项目时

1. 按 `docs/template-rollout.md` 和 `scripts/copy-workflow-template.ps1` 复制规则与骨架
2. 用 `docs/runbook.md` 跑第一个低风险任务验证
3. 再按需接入 CI、远程仓库与环境；高风险仍走 `docs/risk-approval.md`
