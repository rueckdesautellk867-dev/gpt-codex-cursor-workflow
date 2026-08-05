# T010 建立远程仓库准备方案

- **编号**：T010
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Cursor

## 任务标题

建立远程仓库准备方案

## 背景

本地已有 v0.1–v0.6 文档闭环与清晰提交历史；下一步需要远端备份与协作，但平台未定，不宜直接推送。

## 目标

新增 `docs/remote-repo-plan.md`（平台选择、推送前检查、初始化步骤），登记 T010，预留 T011；本任务只做远程仓库方案，不实际推送。

## 影响范围

- 模块 / 目录：`docs/`、`tasks/`、根 `README.md`
- 预计改动文件：`docs/remote-repo-plan.md`、`tasks/T010-remote-repo-plan.md`、`tasks/T011-remote-repo-push.md`、`tasks/backlog.md`、`README.md`、`docs/project-status.md`、`docs/release-notes.md`、`docs/pilot-log.md`
- 可能波及的调用方：无（纯文档）

## 不做什么

- 不创建远程仓库、不设置 remote、不推送代码
- 不接真实 CI、不新增依赖、不改业务代码
- 不执行 T004 / T011，不修改 T004 状态

## 验收标准

- [x] 存在 `docs/remote-repo-plan.md`，含平台、检查项、步骤与「暂不执行」
- [x] T010 已完成；T011 为 `待确认`；T004 仍为 `待确认`
- [x] 本任务只做远程仓库方案，不实际推送

## 测试命令

```text
无需运行测试；检查 Markdown 链接；确认 git remote 仍为空、未发生 push
```

## 完成后需要说明的内容

- 变更总结：已建立远程仓库准备方案
- 验证：文档检查 + `git remote -v` 仍无远端
- 风险：无；真实推送留待 T011 人工确认后
