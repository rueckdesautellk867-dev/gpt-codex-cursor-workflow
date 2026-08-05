# T008 建立运行手册层

- **编号**：T008
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Cursor

## 任务标题

建立运行手册层

## 背景

规则、任务、验证、审批文档已齐；需要一份固定操作顺序，让 GPT / Codex / Cursor / 人工按同一路径重复执行任务。

## 目标

新增 `docs/runbook.md`（启动→分流→执行→验证→审批→提交→归档），并挂到 backlog、README、pilot-log；可选在 `docs/ai-workflow.md` 指向手册。本任务只建立运行手册，不执行真实业务任务。

## 影响范围

- 模块 / 目录：`docs/`、`tasks/`、根 `README.md`
- 预计改动文件：`docs/runbook.md`、`tasks/T008-runbook-layer.md`、`tasks/backlog.md`、`README.md`、`docs/pilot-log.md`；可选 `docs/ai-workflow.md`
- 可能波及的调用方：无（纯文档）

## 不做什么

- 不执行真实业务任务
- 不执行 T004，不修改 T004 状态
- 不改业务代码、不新增依赖、不接真实 CI

## 验收标准

- [x] 存在 `docs/runbook.md`，含标准 11 步顺序及各环节要点
- [x] T008 已完成；T004 仍为 `待确认`
- [x] 本任务只建立运行手册，不执行真实业务任务

## 测试命令

```text
无需运行测试，仅检查 Markdown 链接和格式
```

## 完成后需要说明的内容

- 变更总结：已建立运行手册层
- 验证：文档检查
- 风险：无
