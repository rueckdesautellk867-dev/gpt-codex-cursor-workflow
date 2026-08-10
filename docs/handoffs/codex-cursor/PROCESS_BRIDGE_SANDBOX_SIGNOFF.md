# Option C Step 5：只读桥接 Sandbox Go 签核记录

> **性质**：已填写的人工签核存档（`decision: go`）。  
> **本文件不是实现授权的完成态**：记录 `go` 之后，**仍须另开** sandbox 实现 instruction，才可创建主仓外目录 / 写只读 runner。  
> **范围**：仅 `readonly_hint_only`；**不是** `pilot`。  
> 模板：[`PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md)  
> 相关：[`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) · [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)

---

## 1. 该 `go` 仅允许

| 允许 | 说明 |
|------|------|
| 主仓外 sandbox | 路径见下方签核块 `sandbox_path` |
| 只读 / 提示型 | 读 handoff / observer 输出；生成本地提示与可复制命令 |
| 本地非敏感日志 | 仅写在 sandbox 内 `log_path`；不含密钥 / cookie / token |

---

## 2. 该 `go` 不允许

| 禁止 | 说明 |
|------|------|
| `pilot` / 正式进程桥接入 | 纸面决策仍为 sandbox 阶梯 |
| 自动执行 instruction | 不打开 / 控制 Cursor·Codex Agent 自动跑 |
| 自动判责 | 不替代 Codex 人工判责 |
| 写主仓文件 / 写 INDEX | 主仓只读引用 |
| commit / push | 不由本实验触发 |
| 网络 / API | 含 Codex/Cursor API；默认禁网 |
| AICF 运营链路 | 抓取 / 发布 / F4 / 日更等 |
| 读 `.env` / cookie / token | 禁止 |

越权意图 → [`RISK_GATE.md`](RISK_GATE.md)，本签核不覆盖。

---

## 3. 完整签核块（用户确认）

```markdown
## PROCESS_BRIDGE_SANDBOX_SIGNOFF
- date: 2026-08-10
- approver: 用户确认
- sandbox_path: D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly
- decision: go
- scope: readonly_hint_only
- allowed:
  - read handoff instruction/result files
  - read one-shot observer output
  - generate local hints / copyable commands
  - write sandbox-local non-sensitive logs
- forbidden:
  - execute instruction automatically
  - control Cursor/Codex UI
  - call Codex/Cursor API
  - read .env / cookie / token
  - write main repo files
  - write INDEX
  - git commit / push
  - network outbound
  - touch AICF operation/publishing chain
- kill_switch: stop process / delete sandbox runner
- log_path: D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\logs
- cleanup: stop process, remove sandbox directory if needed
- notes: 仅允许只读提示型 sandbox，不允许自动执行
```

---

## 4. 后续

1. **另开**低风险实现 instruction（授权创建 `sandbox_path`、写只读/提示型 runner、日志与 kill switch）。  
2. 实现须服从 [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) 与本签核 `forbidden`。  
3. 日常主通道仍是稳定半自动 + Option B 观察；sandbox 可关闭、可删除。  

---

## 5. 相关文件

- [`PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md)  
- [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md)  
- [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md)  
- [`RISK_GATE.md`](RISK_GATE.md)  
