# Codex ↔ Cursor 文件接力目录

本目录用于**可追溯**的文件接力（粘贴接力仍可用，见 `docs/codex-cursor-loop.md` §3）。  
协议正文以 `docs/codex-cursor-loop.md` 为准；本文只约定本目录的命名、生命周期与操作顺序。

## 当前默认使用入口（2026-08-10）

> **一句话边界**：当前默认是**半自动文件/粘贴接力 + P1 草稿辅助**；**P2 hold**，**P3 reject**，**UI 自动化 reject**。
> 远端收口锚点：`58831bd`（P2 hold closeout）。

| 用途 | 文档 |
|------|------|
| **总入口 / 默认边界** | [`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md) |
| 稳定半自动收口 | [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) |
| Option B 一键观察 | [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) |
| Pilot P1（草稿可用） | [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md) |
| Pilot P2（hold） | [`PROCESS_BRIDGE_PILOT_P2_HOLD_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P2_HOLD_CLOSEOUT.md) |

**主通道**：本目录文件接力 + 人工粘贴。
**辅助观察**（仓库根执行）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1
```

**辅助草稿**：主仓外 sandbox P0/P1（见 P1 收口；不自动发送/执行）。
**不要**：接 API/UI 桥、UI 自动化、自动判责、自动 commit/push。

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

## Watcher 使用提示（可选）

文件落盘后可用本机 Watcher **只做通知**（不自动执行 instruction、不调 API、不写 git）：

```powershell
# 仓库根目录执行
powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1

# 需要桌面提示时（失败回退控制台）
powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1 -Toast
```

- 监视本目录；忽略 `_template-*` / `README.md`
- 运行时 `.watcher-state.json` / `.watcher.lock` 已 gitignore，勿提交
- 方案与边界见 `docs/codex-cursor-watcher-mvp.md`；状态与路线图见 `docs/codex-cursor-loop-status-roadmap.md`

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
