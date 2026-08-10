# Option C Step 11：Pilot P0 Go 签核记录

> **性质**：已填写的 Pilot **重新签核**存档（`pilot_level: P0`，`decision: go`）。  
> **本文件不是实现完成态**：记录 `go` 之后，**仍须另开** P0 实现 instruction，才可改主仓外 sandbox 提示逻辑。  
> **覆盖范围**：仅 `P0_readonly_hint_optimization`（主仓外 sandbox 只读提示优化）。  
> **不覆盖**：P1 / P2 / P3；自动发送；自动执行；API/UI；写主仓 / INDEX；commit/push；网络外呼。  
> 评估方案：[`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)  
> 相关：[`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) · [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`RISK_GATE.md`](RISK_GATE.md)

---

## 1. 该 Go 仅覆盖

| 项 | 说明 |
|----|------|
| `pilot_level` | **P0** |
| `scope` | `P0_readonly_hint_optimization` |
| 位置 | 主仓外 sandbox：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\` |
| 允许动作 | 读 handoff / observer；生成更好本地 hints；生成可复制 CODEX/CURSOR 块；写 sandbox-local 非敏感日志 |

原 sandbox R1 签核（[`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md)）仍有效；本签核是其上的 **P0 增量**授权，**不是**升 P1+。

---

## 2. 该 Go 不覆盖

| 禁止 | 说明 |
|------|------|
| P1 / P2 / P3 | 须新签核；本文件不放行 |
| 自动发送内容 | 禁止 |
| 自动执行 instruction | 禁止 |
| 控制 Cursor / Codex UI | 禁止 |
| 调用 Codex / Cursor API | 禁止 |
| 写主仓 / 写 INDEX | 禁止 |
| commit / push | 禁止 |
| 网络外呼 | 禁止 |
| AICF 运营链路 | 禁止 |
| 绕过 RISK_GATE | 禁止 |

越权 → [`RISK_GATE.md`](RISK_GATE.md) + [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)。

---

## 3. 完整签核块（用户确认）

```markdown
## PROCESS_BRIDGE_PILOT_SIGNOFF
- date: 2026-08-10
- approver: 用户确认
- pilot_level: P0
- decision: go
- scope: P0_readonly_hint_optimization
- allowed:
  - read handoff instruction/result files
  - read one-shot observer output
  - generate better local hints
  - generate copyable CODEX/CURSOR blocks
  - write sandbox-local non-sensitive logs
- forbidden:
  - execute instruction automatically
  - send content automatically
  - control Cursor/Codex UI
  - call Codex/Cursor API
  - read .env / cookie / token
  - write main repo files
  - write INDEX
  - git commit / push
  - network outbound
  - touch AICF operation/publishing chain
  - upgrade to P2/P3 without new signoff
- kill_switch: stop process / create DISABLED file / delete sandbox runner
- rollback: revert to readonly_hint_only sandbox R1; remove P0 changes if needed
- log_path: D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\logs
- notes: 仅允许 P0 只读提示优化；不允许自动发送、自动执行或 API/UI 控制
```

---

## 4. 后续

1. **另开**低风险 P0 实现 instruction（限主仓外 sandbox 提示/复制块优化；主仓仅允许 result 回传，除非 instruction 另授文档）。  
2. 服从 [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) §5 硬门槛与本签核 `forbidden`。  
3. Rollback：回到 readonly_hint_only sandbox R1；必要时移除 P0 改动。  
4. 日常主通道仍是稳定半自动 + Option B；sandbox/P0 为可选辅助。  

**Go ≠ 已经开工。**

---

## 5. 相关文件

- [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)  
- [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md)  
- [`RISK_GATE.md`](RISK_GATE.md)  
