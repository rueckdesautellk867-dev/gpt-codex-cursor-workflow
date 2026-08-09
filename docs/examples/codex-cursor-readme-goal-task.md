# 示例任务：README 项目目标微调（Codex↔Cursor 闭环包装）

> **低风险文档任务**样例。示范如何把「README 项目目标微调」包装为 `CODEX_INSTRUCTION`，供后续同类任务复用。  
> 对应已完成试跑提交：`e2c6d70`（`docs: align readme goal with loop protocol`）。再跑时请改 `task_id` / 文案焦点，勿盲复同一 diff。

## 任务标题

低风险试跑：按闭环协议微调 README 项目目标描述

## 背景

三方闭环协议见 `docs/codex-cursor-loop.md`。文档类低风险改动适合用结构化接力验证通道是否顺畅：  
`CODEX_INSTRUCTION → Cursor 执行 → CURSOR_RESULT → CODEX_JUDGEMENT`。

通用任务骨架还可参考：`docs/examples/low-risk-doc-update-task.md`。

## 目标

在不改动其它章节的前提下，检查并微调 `README.md` 中「项目目标」相关表述，使其与 `docs/ai-workflow.md`、`docs/codex-cursor-loop.md` 一致。

## 影响范围

- 模块 / 目录：项目根目录文档
- 预计改动文件：`README.md`（仅「项目目标」小节）
- 可能波及的调用方：无（纯文档）

## 不做什么

- 不修改业务代码
- 不调整分工表、流程、文档索引等其它 README 章节
- 不改 `docs/codex-cursor-loop.md` 协议正文
- 不新增依赖、不改 CI、不改 Git 配置
- 未经明确指令不 commit；push 须单独授权

## 验收标准

- [ ] 仅修改 `README.md` 中「项目目标」相关文案
- [ ] 表述与 `docs/ai-workflow.md`、`docs/codex-cursor-loop.md` 不冲突
- [ ] Markdown 标题层级和链接保持正常
- [ ] 输出 `CURSOR_RESULT`（变更总结、影响范围、验证结果、风险与待确认）

## 验证命令

```text
人工检查 README Markdown 格式与相关链接
git status --short
git diff -- README.md
```

## 风险等级

低（纯文档文案；可随时回滚该段）

## 推荐执行者

Cursor（主执行者；Codex 出令与判责）

## 完成后需要说明的内容

- 改了哪个文件、改了哪一段
- 为什么改（对齐闭环表述 / 补协议入口等）
- 测试命令与结果
- 是否已 commit / push（默认否）
- 残留风险 / 待确认项

---

## 可直接粘贴的 `CODEX_INSTRUCTION`

复制下方块发给 Cursor（或写入 handoff）即可发起同类任务：

````markdown
## CODEX_INSTRUCTION

- task_id: low-risk-readme-goal
- round: 01
- from: Codex
- to: Cursor
- mode: implement
- risk: 低
- target_repo: D:\AIContentFactory\三方闭环整合项目

### 任务标题

低风险试跑：按闭环协议微调 README 项目目标描述

### 背景

三方闭环协议 `docs/codex-cursor-loop.md` 已就绪。用低风险文档任务验证
`CODEX_INSTRUCTION → 执行 → CURSOR_RESULT → CODEX_JUDGEMENT` 接力。
参考：`docs/examples/codex-cursor-readme-goal-task.md`

### 目标

在不改动其它章节的前提下，检查并微调 `README.md` 中「项目目标」相关表述，
使其与当前三方闭环文档一致。

### 影响范围

- 预计改动文件：`README.md`（仅「项目目标」小节）
- 不要碰的路径：业务代码、CI、脚本、依赖、`docs/codex-cursor-loop.md`

### 不做什么

- 不修改业务代码
- 不改 CI、脚本、依赖、Git 配置
- 不改协议正文
- 不提交、不 push（除非另授）

### 验收标准

- [ ] 仅修改 `README.md` 中项目目标相关文案
- [ ] 表述与 `docs/ai-workflow.md`、`docs/codex-cursor-loop.md` 不冲突
- [ ] Markdown 标题层级和链接保持正常
- [ ] 输出完整 `CURSOR_RESULT`

### 建议验证

```text
人工检查 README Markdown 格式与相关链接
git status --short
git diff -- README.md
```

### 判责提示（给 Codex 下一轮用）

- pass 条件：仅 README 目标段变更；验证通过；无越界文件
- continue 时优先看：表述仍与协议冲突、或链接失效
- stop 条件：出现业务/CI/协议正文改动，或未授权 commit/push
````
