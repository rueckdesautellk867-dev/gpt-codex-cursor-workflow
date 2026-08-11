# 全自动模式

本文定义 GPT + Codex + Cursor 三方闭环从半自动模式推进到全自动模式时，哪些环节可以自动执行，哪些环节仍必须停在人工确认前。

## 模式目标

把低风险研发闭环自动化到“可独立启动、执行、验证、记录、回流”的程度：

```text
任务输入
    -> 风险分级
    -> 选择执行者
    -> Codex / Cursor 执行
    -> 本地验证 / CI
    -> 结果归档
    -> Obsidian 复盘入库
```

全自动模式只覆盖研发协作流程，不等于自动执行平台动作。

## 与 AICF 业务仓关系

三方闭环工作区可以推进“研发全自动”，但 AICF 业务仓默认仍按半自动发布策略执行：

- AICF 图文链路仍是半自动 + R0/R1 draft。
- R2+、公开发布自动化、F4、日更、抓取和凭证动作仍保持 hold / reject。
- Obsidian 每日复盘入库只是状态回流，不是平台动作，也不是发布授权。
- AICF 业务仓的默认路径以 `D:\AIContentFactory\repo\AIContentFactory\docs\default-semi-auto-r0-r1-workflow.md` 为准。

## 可自动执行范围

- 读取仓库规则、任务单、运行手册和相关文档。
- 为低风险或已明确的中风险任务生成执行计划。
- 在任务边界清楚时，由 Codex 执行仓库级改动。
- 运行任务单或 `docs/ci.md` 指定的本地验证命令。
- 生成变更总结、影响范围、验证结果、风险与待确认。
- 更新任务状态、backlog、pilot-log 或约定归档文档。
- 读取 AICF + Obsidian 上下文，写入 `D:\AIContentFactory\ObsidianMemory\05_Daily_Reviews\YYYY-MM-DD_每日复盘.md`。

## 当前执行器边界

当前全自动模式表示规则、CI 和已配置的 Obsidian daily review automation 已形成基线，不表示已经具备额外的端到端无人值守执行器。任务仍按 `docs/runbook.md`、`docs/ai-task-routing.md` 和本文件边界执行；遇到高风险、需求不清或验证失败时必须降级。

## 仍需人工确认

以下动作不得被全自动模式绕过：

- 远程 push，除非用户在当前任务中明确同意。
- GitHub PR 合并、分支保护设置变更、生产部署。
- 权限、支付、数据库结构、用户数据、安全配置、凭证处理。
- 新增依赖或改变运行环境。
- 打开小红书平台、登录、抓取、上传、暂存、发布、F4、日更。
- 创建 `publish_task` / `publish_plan` 或写入平台凭证。
- 删除、迁移或覆盖用户未明确授权的文件和历史脏态。

## 自动闭环步骤

1. 读取 `docs/runbook.md`，确认当前任务是否有任务单。
2. 没有任务单时，低风险文档类任务可自动创建；需求模糊或风险不清时先询问。
3. 按 `docs/ai-task-routing.md` 分流：GPT 拆解、Codex 执行、Cursor 局部审查或调试。
4. 执行前写清影响范围和不做事项。
5. 执行中只改任务所需文件。
6. 按 `docs/verification.md` 和 `docs/ci.md` 运行最低验证。
7. 验证失败时优先修复任务范围内问题；若修复会扩大范围，则停止并请用户确认。
8. 归档任务结果，并把关键状态回流到 Obsidian daily review。

## 失败降级

| 场景 | 处理 |
|------|------|
| 需求不清 | 停止并向用户提一个具体问题 |
| 风险不清 | 上调风险等级，按高风险处理 |
| 验证失败 | 报告失败命令、错误摘要和最小修复建议 |
| push 失败 | 按 `docs/push-fallback.md` 记录 tip，不死等 |
| Obsidian 写入失败 | 报告目标路径、权限错误和已读取证据 |
| 触及禁止动作 | 立即停止，不用自动化继续尝试 |

## 本工作区 Git 限制

当前 `C:\Users\Administrator\Documents\ChatGPT + Cursor 工作流` 不是可用 Git 仓库：目录中存在 `.git` 但 `git status` 返回 `fatal: not a git repository`。在修复仓库或另行指定真实 Git 主仓前：

- 归档以文件落盘、任务清单和 Obsidian 回流为准。
- 不把本工作区变更表述为已 commit 或已 push。
- 如需入库，必须先确认修仓、迁到真实 Git 主仓，或由用户另行授权。

## 今日目标

2026-08-11 的目标是把三方闭环研发流程推进到全自动模式：

- 自动执行低风险文档与仓库维护任务。
- 自动运行本地验证。
- 自动生成结果归档。
- 自动把每日复盘写入 Obsidian。
- 平台发布、抓取、F4、日更继续冻结。
