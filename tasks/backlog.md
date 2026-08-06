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
| T006 | 接入真实 CI 配置 | 中 | Codex 或 Cursor | 已完成 | [T006-ci-setup.md](T006-ci-setup.md) |
| T007 | 建立风险与人工审批层 | 低 | Cursor | 已完成 | [T007-risk-approval-layer.md](T007-risk-approval-layer.md) |
| T008 | 建立运行手册层 | 低 | Cursor | 已完成 | [T008-runbook-layer.md](T008-runbook-layer.md) |
| T009 | 建立项目交付包 | 低 | Cursor | 已完成 | [T009-project-delivery-package.md](T009-project-delivery-package.md) |
| T010 | 建立远程仓库准备方案 | 低 | Cursor | 已完成 | [T010-remote-repo-plan.md](T010-remote-repo-plan.md) |
| T011 | 创建远程仓库并推送 main | 中 | 人工确认后 Cursor 或人工 | 已完成 | [T011-remote-repo-push.md](T011-remote-repo-push.md) |
| T012 | 配置 main 分支保护 | 中 | 人工 | 已完成 | [T012-branch-protection.md](T012-branch-protection.md) |
| T013 | PR + CI + 分支保护冒烟验证 | 低 | Codex / 人工 | 已完成 | [T013-pr-ci-protection-smoke-test.md](T013-pr-ci-protection-smoke-test.md) |
| T014 | 复制到其它项目模板化落地 | 低 | Codex / Cursor / 人工 | 已完成 | [T014-copy-template-to-other-projects.md](T014-copy-template-to-other-projects.md) |
| T015 | 推送失败降级策略（CLI → Desktop） | 低 | Cursor | 已完成 | [T015-push-fallback.md](T015-push-fallback.md) |

## 说明

- T001–T003 随 v0.2 落地一并完成（文档与入口，无业务代码）。
- **T004 仅作高风险门禁样例，状态保持 `待确认`，本阶段不执行。**
- T005 随 v0.3 完成：只建立验证设计，**不接真实 CI**。
- T006 已完成：接入最小真实 CI，覆盖文档链接、任务索引、关键文件和高风险样例状态。
- T007 随 v0.4 完成：建立风险与人工审批流程文档，**不执行高风险任务**。
- T008 随 v0.5 完成：建立运行手册，用于重复执行任务流程。
- T009 随 v0.6 完成：建立项目交付包，归档阶段成果。
- T010 随 v0.7 完成：远程仓库准备方案，**不实际推送**。
- T011 已完成人工审批后的远程仓库连接与 `main` 推送；分支保护后续单独处理。
- T012 已完成：GitHub 网页开启 `main` 分支保护，要求 `Docs validation` 通过后再合并。
- T013 已完成：通过 PR #1 验证分支推送、`Docs validation`、PR 合并和本地 main 同步链路。
- T014 已完成：建立复制到其它项目的说明和本地复制脚本，默认不覆盖目标项目已有文件。
- T015 已完成：推送失败降级策略见 `docs/push-fallback.md` 与 `scripts/push-with-fallback.ps1`（失败记 tip、标待 Desktop 推送、不死等）。
