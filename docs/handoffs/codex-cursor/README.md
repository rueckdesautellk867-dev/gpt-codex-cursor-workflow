# Codex ↔ Cursor 文件接力目录

本目录用于**可追溯**的文件接力（粘贴接力仍可用，见 `docs/codex-cursor-loop.md` §3）。  
协议正文以 `docs/codex-cursor-loop.md` 为准；本文只约定本目录的命名、生命周期与操作顺序。

## 命名

```text
docs/handoffs/codex-cursor/
  <task_id>-r<round>-instruction.md
  <task_id>-r<round>-result.md
  <task_id>-r<round>-judgement.md   # 可选
```

| 字段 | 规则 |
|------|------|
| `task_id` | 短横线小写，如 `loop-readme-goal`、`low-risk-doc-link-check` |
| `round` | 两位数字，从 `01` 起；同任务单调递增，不覆盖历史文件 |
| 后缀 | `instruction` = Codex→Cursor；`result` = Cursor→Codex；`judgement` = Codex 判责（可选落盘） |

模板文件（复制用，勿当作活跃任务）：

- [`_template-instruction.md`](_template-instruction.md)
- [`_template-result.md`](_template-result.md)

## 操作顺序

1. **Codex / 人工**：复制 `_template-instruction.md` → `<task_id>-r01-instruction.md`，填完整指令；在指令中写明 `result_path`（建议本目录对应 result 文件名）。
2. **Cursor**：读 instruction → 执行 → 复制 `_template-result.md` → 同轮 `…-result.md`（并在对话中贴出同等内容）。
3. **Codex**：读 result → 判责；`continue` 则写 `…-r02-instruction.md`；`pass` / `stop` 收口（可选写 `…-judgement.md`）。
4. **收口后**：活跃文件可保留作审计；不必删除。可选在 `docs/pilot-log.md` 记一行 tip。

## 约束

- 一项 instruction 只做一件可验收的事
- 高风险须 `need_confirm` / 人工确认后再继续
- 跨仓执行时：`target_repo` 写清目标路径；result 默认写回**本目录**，除非 instruction 另指定
- 本目录只放 handoff Markdown；不放密钥、账号 cookie、生产配置
- 未单独授权不 commit / 不 push（与单条 instruction 的「不做什么」一致）

## 与粘贴接力的关系

| 方式 | 何时用 |
|------|--------|
| 粘贴 | 单轮、短指令、快速试跑 |
| 本目录文件 | 需审计、多轮、跨会话、跨项目回传路径要固定 |

两者模板字段相同，可互相复制内容。
