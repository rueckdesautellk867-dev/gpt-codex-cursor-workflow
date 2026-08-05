# 任务总清单（backlog）

状态：`待办` / `进行中` / `待确认` / `已完成` / `已取消`  
用法见 [tasks/README.md](README.md)。

| 编号 | 标题 | 风险 | 推荐执行者 | 状态 | 任务单 |
|------|------|------|------------|------|--------|
| T001 | 建立 tasks/ 使用说明与状态约定 | 低 | Cursor | 已完成 | [T001-tasks-usage.md](T001-tasks-usage.md) |
| T002 | README 增加任务系统入口链接 | 低 | Cursor | 已完成 | [T002-readme-tasks-link.md](T002-readme-tasks-link.md) |
| T003 | 编写「从任务单到合并」最短操作清单 | 低 | Cursor | 已完成 | [T003-task-to-merge-checklist.md](T003-task-to-merge-checklist.md) |
| T004 | 高风险门禁样例（用户表会员等级字段） | 高 | 人工确认后 Codex 或人工 | 待确认 | [T004-high-risk-gate-sample.md](T004-high-risk-gate-sample.md) |
| T005 | 建立 CI / 验证层设计文档 | 低 | Cursor | 已完成 | [T005-verification-layer.md](T005-verification-layer.md) |
| T006 | 接入真实 CI 配置 | 中 | Codex 或 Cursor | 待办 | [T006-ci-setup.md](T006-ci-setup.md) |

## 说明

- T001–T003 随 v0.2 落地一并完成（文档与入口，无业务代码）。
- **T004 仅作高风险门禁样例，状态保持 `待确认`，本阶段不执行。**
- T005 随 v0.3 完成：只建立验证设计，**不接真实 CI**。
- T006 为预留任务：接入真实 CI，v0.3 不执行。
