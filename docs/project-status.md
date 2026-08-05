# 项目状态

便于把本仓库作为模板复制到其它项目时，先看清能力、限制与下一步。

| 项 | 内容 |
|----|------|
| 项目名称 | 三方闭环整合项目 |
| 当前版本 | v0.6 准备中 |
| 当前工作区 | `D:\三方闭环整合项目\` |

版本明细见 [`docs/release-notes.md`](release-notes.md)；操作顺序见 [`docs/runbook.md`](runbook.md)。

## 当前能力

| 层级 | 说明 | 入口 |
|------|------|------|
| 规则层 | GPT / Codex / Cursor 分工与仓库规则 | `AGENTS.md`、`.cursor/rules/ai-workflow.mdc`、`docs/ai-workflow.md` |
| 任务层 | 可复用任务单与 backlog | `tasks/`、`docs/task-template.md` |
| 验证层 | 风险对应的最低验证与交付字段 | `docs/verification.md` |
| 风险审批层 | 高风险禁止动作与审批记录 | `docs/risk-approval.md` |
| 运行手册层 | 启动→归档的固定操作顺序 | `docs/runbook.md` |

## 已验证事项

- 低风险任务可执行（文档类试跑与 T001–T003、T005、T007–T009 类任务）
- 高风险任务可识别并停在人工确认前（T004 保持 `待确认`）
- 任务可归档（`tasks/backlog.md`、`docs/pilot-log.md`）
- 提交记录清晰（v0.1–v0.5 均有独立 commit，见 release-notes）

## 当前限制

- 未接真实 CI（T006 仍为 `待办`）
- 未接外部任务系统（仅仓库内 Markdown 任务）
- 未接云端部署
- 未接监控反馈

## 下一步建议

1. 接入真实 CI（执行 T006）
2. 接入远程 Git 仓库
3. 接入任务系统（如需与看板 / Issue 同步）
4. 设计阿里云测试环境（部署与反馈闭环另开任务，高风险须审批）

## 复制到其它项目时

1. 复制规则与 `docs/`、`tasks/` 骨架，按目标仓库改名与路径
2. 用 `docs/runbook.md` 跑第一个低风险任务验证
3. 再按需接入 CI、远程仓库与环境；高风险仍走 `docs/risk-approval.md`
