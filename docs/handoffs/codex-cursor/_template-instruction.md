# Handoff Instruction（复制本文件后改名）

> 复制为 `<task_id>-r<round>-instruction.md` 再填写。  
> 字段说明见 `docs/codex-cursor-loop.md` 与本目录 `README.md`。

## CODEX_INSTRUCTION

- task_id: （例：loop-readme-goal）
- round: 01
- from: Codex
- to: Cursor
- mode: implement | debug | review
- risk: 低 | 中 | 高
- target_repo: D:\AIContentFactory\三方闭环整合项目
- result_path: docs/handoffs/codex-cursor/<task_id>-r01-result.md

### 任务标题

（一句话）

### 背景

（上一轮结论 / 相关文档链接）

### 目标

（完成后应达到的结果）

### 影响范围

- 预计改动文件：
- 不要碰的路径：

### 不做什么

- 不修改业务代码（若本任务仅为文档则写明）
- 不 commit / 不 push（除非本条明确授权）

### 验收标准

- [ ]
- [ ]

### 建议验证

```text
（命令或人工检查步骤）
```

### 判责提示（给 Codex 下一轮用）

- pass 条件：
- continue 时优先看：
- stop 条件：
