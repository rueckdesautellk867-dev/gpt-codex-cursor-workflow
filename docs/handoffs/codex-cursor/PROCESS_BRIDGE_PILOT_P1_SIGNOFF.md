# Option C：Pilot P1 Go 签核记录

> **性质**：已填写的 Pilot P1 **重新签核**存档（`pilot_level: P1`，`decision: go`，`scope: draft_generation_only`）。  
> **本文件不是实现完成态**：记录 `go` 之后，**仍须另开** P1 实现 instruction，才可在主仓外 sandbox 增加草稿生成能力。  
> **覆盖范围**：仅 **`draft_generation_only`**（待人工复制粘贴的草稿块；强制 `DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED`）。  
> **不覆盖**：P2 / P3；自动发送；自动执行；API/UI；最终 `pass` 判责；写主仓 / INDEX；commit/push；网络外呼。  
> 评估：[`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md)  
> 相关：[`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md)（P0）· [`RISK_GATE.md`](RISK_GATE.md)

---

## 1. 该 Go 仅覆盖

| 项 | 说明 |
|----|------|
| `pilot_level` | **P1** |
| `scope` | `draft_generation_only` |
| 位置 | 主仓外 sandbox：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\` |
| 允许动作 | 读 handoff 元数据与**限长必要**正文片段；生成带水印的待粘贴草稿；建议 `review_needed` / `need_confirm`；写 sandbox-local 非敏感日志 |
| 草稿强制标记 | 每块须含 **`DRAFT_ONLY`** 与 **`HUMAN_REVIEW_REQUIRED`** |

P0 签核（[`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md)）仍有效；本签核是其上的 **P1 增量**，**不是**升 P2/P3。

---

## 2. 该 Go 不覆盖

| 禁止 | 说明 |
|------|------|
| P2 / P3 | 须新签核；本文件不放行 |
| 自动发送内容 | 含剪贴板自动写入、进程投递 |
| 自动执行 instruction | 禁止 |
| 控制 Cursor / Codex UI | 禁止 |
| 调用 Codex / Cursor API | 禁止 |
| 自动生成最终 `pass` 判责 | 最多 `review_needed` / `need_confirm` |
| 写主仓 / 写 INDEX | 禁止 |
| commit / push | 禁止 |
| 网络外呼 | 禁止 |
| AICF 运营链路 | 禁止 |
| 绕过 RISK_GATE | 禁止 |

越权 → [`RISK_GATE.md`](RISK_GATE.md) + [`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md)。

---

## 3. 完整签核块（用户确认）

```markdown
## PROCESS_BRIDGE_PILOT_P1_SIGNOFF
- date: 2026-08-10
- approver: 用户确认
- pilot_level: P1
- decision: go
- scope: draft_generation_only
- allowed:
  - read handoff instruction/result metadata
  - read limited necessary body snippets for draft generation
  - generate DRAFT_ONLY / HUMAN_REVIEW_REQUIRED paste blocks
  - generate review_needed / need_confirm suggestions
  - write sandbox-local non-sensitive logs
- forbidden:
  - send content automatically
  - execute instruction automatically
  - control Cursor/Codex UI
  - call Codex/Cursor API
  - generate final pass judgement automatically
  - read .env / cookie / token
  - write main repo files
  - write INDEX
  - git commit / push
  - network outbound
  - touch AICF operation/publishing chain
  - upgrade to P2/P3 without new signoff
- kill_switch: stop process / create DISABLED file / delete sandbox runner
- rollback: revert to Pilot P0 runner behavior; remove P1 draft-generation changes if needed
- log_path: D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\logs
- notes: 仅允许生成待人工复制粘贴的草稿块；草稿必须包含 DRAFT_ONLY 与 HUMAN_REVIEW_REQUIRED；不允许自动发送、自动执行、自动 pass 判责或 API/UI 控制
```

---

## 4. 后续

1. **另开** P1 实现 instruction（`draft_generation_only`；优先主仓外 sandbox；草稿强制水印）。  
2. 服从 [`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md) 防线与本签核 `forbidden`。  
3. Rollback：回到 Pilot P0 runner 行为；必要时移除 P1 草稿生成改动。  
4. 日常主通道仍是稳定半自动 + Option B；P1 为可选辅助。  

**Go ≠ 已经开工。**

---

## 5. 相关文件

- [`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md)  
- [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md)  
- [`RISK_GATE.md`](RISK_GATE.md)  
