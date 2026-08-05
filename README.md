# GPT + Codex + Cursor 三方研发闭环

以代码仓库、任务系统、CI、评审规则为中心的 AI 协作工程规范。

## 项目目标

建立以代码仓库、任务系统、CI 和评审规则为中心的 GPT + Codex + Cursor 三方 AI 研发闭环。

## 三方分工

| 角色 | 负责 |
|------|------|
| **GPT** | 需求澄清、任务拆解、方案比较、验收标准、PR 总结 |
| **Codex** | 明确任务下的仓库级修改、测试、修 CI、开 PR |
| **Cursor** | IDE 内局部修改、调试、UI 调整、人工结对审查 |

## 推荐流程

```text
需求 / Bug / 告警
    → GPT 拆任务
    → Codex 实现
    → CI 验证
    → Cursor + 人工审查
    → 合并发布
    → 反馈回流
```

## 文档索引

| 文档 | 说明 |
|------|------|
| [AGENTS.md](AGENTS.md) | Codex 仓库级规则 |
| [.cursor/rules/ai-workflow.mdc](.cursor/rules/ai-workflow.mdc) | Cursor 协作规则 |
| [PR_CHECKLIST.md](PR_CHECKLIST.md) | 合并前检查清单 |
| [docs/ai-workflow.md](docs/ai-workflow.md) | 三方闭环流程详解 |
| [docs/definition-of-done.md](docs/definition-of-done.md) | 完成标准 |
| [docs/task-template.md](docs/task-template.md) | 标准任务模板 |
| [docs/ai-task-routing.md](docs/ai-task-routing.md) | 任务分流规则 |
| [docs/verification.md](docs/verification.md) | 验证层设计（风险门槛与交付字段） |
| [docs/risk-approval.md](docs/risk-approval.md) | 风险分级与人工审批流程 |
| [tasks/README.md](tasks/README.md) | 任务目录使用说明与最短操作 |
| [tasks/backlog.md](tasks/backlog.md) | 可执行任务总清单 |

## 使用建议

1. 新任务先按 [任务模板](docs/task-template.md) 填写，并登记到 [tasks/backlog.md](tasks/backlog.md)
2. 再按 [分流规则](docs/ai-task-routing.md) 决定交给 GPT、Codex、Cursor 或人工
3. 合并前对照 [PR_CHECKLIST.md](PR_CHECKLIST.md) 与 [完成标准](docs/definition-of-done.md)

## 风险原则

高风险任务（权限、支付、数据库迁移、用户数据、安全、生产发布）**必须人工确认后再执行**。
