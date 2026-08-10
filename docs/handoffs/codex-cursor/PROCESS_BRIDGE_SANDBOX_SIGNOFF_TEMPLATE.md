# Option C Step 4：只读桥接 Sandbox Go / No-Go 签核模板

> **用途**：Option C **只读 / 提示型**桥接 sandbox **实现前**的人工签核记录模板。  
> **填写后**：仅当 `decision: go` 且满足 §3 Go 条件时，才可**另开** sandbox 实现 instruction。  
> **明确声明**：  
> 1. **本模板本身不是授权**；空白模板、未填字段、或未写明 `decision: go` → **不得实现**。  
> 2. `go` **只允许** `scope: readonly_hint_only`；**不允许** `pilot`、自动执行、正式进程桥接入。  
> 3. 不替代 [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) checklist，也不替代 [`RISK_GATE.md`](RISK_GATE.md)。  
> 服从：[`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) · [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)

---

## 1. 如何使用

1. 先完成 [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) §2 全部确认。  
2. 复制下方 **§2 签核块**到独立记录（实现 instruction 附录、或本地/对话签核；**不必**改本模板文件）。  
3. 人工填写全部字段；`decision` 只能是 `go` 或 `no-go`。  
4. `go` → 另开低风险实现 instruction（可授权创建主仓外目录与 sandbox 内脚本）。  
5. `no-go` 或未签 → 停止；修边界或走 RISK_GATE。  

本轮仓库任务**只提供模板**，**不在此文件内完成签核**。

---

## 2. 可复制签核块

```markdown
## PROCESS_BRIDGE_SANDBOX_SIGNOFF

- date:
- approver:
- sandbox_path:
- decision: go / no-go
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
- kill_switch:
- log_path:
- cleanup:
- notes:
```

### 字段填写提示

| 字段 | 建议 |
|------|------|
| `sandbox_path` | 主仓外，例如 `D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`；禁止 Documents 旁路 |
| `kill_switch` | 例如 `config\enabled.flag` 存在且为 `1` 才可跑；默认关闭；+ `Ctrl+C` |
| `log_path` | 例如同目录下 `logs\`；约定不含敏感内容 |
| `cleanup` | 关 flag / 结束进程 / 可选删 `logs\`·`out\`；确认主仓无写入 |
| `notes` | 例外、限制时间窗、引用 readiness 勾选日期等 |

将 `decision: go / no-go` 改成单一值：`go` 或 `no-go`（不要保留斜杠选项）。

---

## 3. Go 条件（须同时满足）

| # | 条件 |
|---|------|
| 1 | `decision: go`（已填写，非空、非模板原文） |
| 2 | `scope: readonly_hint_only` |
| 3 | `sandbox_path` 明确且在**主仓外**（且非 Documents 旁路） |
| 4 | `kill_switch`、`log_path`、`cleanup` **均已填写** |
| 5 | `allowed` / `forbidden` 列表未被删改成扩大执行权；**无一** forbidden 项被注明「本次放开」 |
| 6 | readiness checklist 已全部 yes（见 READINESS 文档） |

全部满足 → 仅可另开 **只读/提示型** sandbox 实现 instruction。  
仍须在该 instruction 中再次写清边界；**本签核块不自动开工**。

---

## 4. No-Go 条件（命中任一即不得实现）

| # | 条件 |
|---|------|
| 1 | 未填写、`decision` 空缺、或 `decision: no-go` |
| 2 | 任一 `forbidden` 项需要放开（自动执行、UI 控制、API、写主仓、写 INDEX、commit/push、外网、AICF 运营等） |
| 3 | `sandbox_path` 不明确、落在主仓内、或使用 Documents 旁路 |
| 4 | 需要网络 / API（本模板默认禁网） |
| 5 | 需要自动执行 instruction 或控制 Cursor/Codex UI |
| 6 | 试图将本次升级为 `pilot` 或正式进程桥接入 |
| 7 | 高风险场景未先走 [`RISK_GATE.md`](RISK_GATE.md) |

---

## 5. 与已有文档的关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) | 本模板是其签核块的独立、可复制载体 |
| [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) | 实验范围与目录约定 |
| [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) | 决策仍为 `sandbox`，非 `pilot` |
| [`RISK_GATE.md`](RISK_GATE.md) | 越权 / 高风险 → No-Go |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | 日常主通道不变 |

---

## 6. 相关文件

- [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md)  
- [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md)  
- [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) · [`RISK_GATE.md`](RISK_GATE.md)  
