# Option C：Pilot P1 风险评估与重新签核方案

> **这是什么**：在 Pilot P0（可复制 NEXT_ACTION 块）之上，评估 **P1 = 半自动生成待粘贴草稿、人工确认后手动发送** 的风险、防线与重新签核门槛。  
> **这不是什么**：不是 P1 实现授权完成态；不写 P1 代码；不改 sandbox runner；不接 API。  
> **建议结论**：**P1 可进入签核**，但仅限 **`draft_generation_only`**；**P2 hold / P3 reject** 不变。  
> 服从：[`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md)（P0）· [`RISK_GATE.md`](RISK_GATE.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)；日常主入口仍是 Option B + 稳定半自动。

---

## 1. P1 是什么 / 不是什么

### 1.1 是什么

| 项 | 说明 |
|----|------|
| 相对 P0 | 在可复制块基础上，生成更完整的**待粘贴草稿**：`CODEX_INSTRUCTION` / `CURSOR_RESULT` / `CODEX_JUDGEMENT` 形态 |
| 发送方式 | **人工复制、人工发送**（粘贴到 Cursor/Codex） |
| 典型产物 | 带强制水印的草稿块 → stdout / sandbox 展示 |

### 1.2 不是什么

| 禁止误解 | 说明 |
|----------|------|
| 自动发送 | 不把草稿推入对话 / 剪贴板 / Agent |
| 自动执行 | 不打开 Cursor/Codex 跑 instruction |
| API / UI 控制 | 不调接口、不点 UI |
| 自动判责 | 不输出最终 `pass` 作为已发生判决 |
| 自动 commit / push | 入库仍须完整人工授权句 |
| 由 P0 直接升级 | [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) 禁止；须本文件 + **新签核** |

---

## 2. P1 相比 P0 的新增风险

| 风险 | 说明 |
|------|------|
| 草稿被当成最终指令 | 人未审就整段粘贴执行 |
| 自动生成 judgement 误导 | 文案像「已判责」导致跳过人工判断 |
| 上下文截断 / 误读 result | 片段不全 → 错误建议 |
| 高风险关键词未识别 | 草稿暗示放行高风险动作 |
| 人工复制时误贴 | 贴错窗口 / 贴错任务 / 重复粘贴 |

---

## 3. 必须防线（实现时硬约束）

| # | 防线 |
|---|------|
| 1 | 草稿必须带 **`DRAFT_ONLY`** |
| 2 | 草稿必须带 **`HUMAN_REVIEW_REQUIRED`** |
| 3 | **不**生成最终 `decision: pass`；最多建议 `review_needed` / `need_confirm` |
| 4 | 命中高风险 / RISK_GATE → **只**生成 `need_confirm` 草稿（或拒绝生成执行向草稿） |
| 5 | 草稿**不**进入剪贴板；**不**自动发送 |
| 6 | 日志**不**记录正文敏感内容（密钥、cookie、token、大段隐私正文） |
| 7 | dry-run 默认：仅 stdout / sandbox 展示；无主仓副作用 |
| 8 | kill switch 可用（如 `DISABLED` / 停进程） |

---

## 4. P1 允许 / 禁止范围

### 4.1 允许（签核后实现时）

| 允许 | 说明 |
|------|------|
| 读 handoff 元数据 | 文件名、mtime、task_id、round、路径 |
| 读必要正文片段 | 仅供生成草稿；**限长**；禁止读 `.env` / cookie / token |
| 生成待粘贴草稿块 | `DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED` |
| 建议 `review_needed` / `need_confirm` | 非最终判决 |
| 本地 stdout 输出 | 人工阅读后手动复制 |
| sandbox-local 非敏感日志 | 同 P0 字段风格 + 草稿类型标记（无正文） |

### 4.2 禁止

| 禁止 | 说明 |
|------|------|
| 自动发送 | 含剪贴板自动写入、进程投递 |
| 自动执行 instruction | |
| 调 API / UI | |
| 写主仓 / INDEX | |
| commit / push | |
| 网络外呼 | |
| AICF 运营链路 | |
| 自动判定 `pass` | 不得输出「已通过」类最终 decision |

---

## 5. 建议结论（纸面）

| 项 | 结论 |
|----|------|
| P1 | **可进入签核**；范围锁定 **`draft_generation_only`** |
| P2 | **hold**（须 API/权限/日志审计） |
| P3 | **reject** |
| 日常 | 仍优先稳定半自动 + Option B；P1 为可选辅助 |

未签核前：**不得**写 P1 实现。

---

## 6. 重新签核模板（可复制）

P0 签核**不覆盖** P1。复制下列块到独立记录（实现 instruction 附录或本地签核；**本方案入库 ≠ 已签**）：

```markdown
## PROCESS_BRIDGE_PILOT_P1_SIGNOFF
- date:
- approver:
- pilot_level: P1
- decision: go / no-go
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
- kill_switch:
- rollback:
- log_path:
- notes:
```

将 `decision: go / no-go` 改为单一值；`scope` 必须保持 `draft_generation_only`。

---

## 7. Go / No-Go 规则

### 7.1 Go（须同时满足）

| # | 条件 |
|---|------|
| 1 | `decision: go` |
| 2 | `pilot_level: P1` |
| 3 | `scope: draft_generation_only` |
| 4 | 实现承诺：草稿强制 `DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED` |
| 5 | §4.2 **禁止项全部保留**（无一注明「本次放开」） |
| 6 | `kill_switch` / `rollback` / `log_path` 已填写 |
| 7 | 服从 [`RISK_GATE.md`](RISK_GATE.md)；高风险仅 `need_confirm` 草稿 |

满足 → 仅可**另开** P1 实现 instruction（建议仍落主仓外 sandbox）。

### 7.2 No-Go（命中任一）

| # | 条件 |
|---|------|
| 1 | 需要自动发送 |
| 2 | 需要自动判责 `pass` |
| 3 | 需要 API / UI |
| 4 | 需要写主仓 / INDEX |
| 5 | 需要联网 |
| 6 | 无法控制日志敏感内容 |
| 7 | 未签核 / `decision` 空缺 / 仅持有 P0 Go |
| 8 | 试图直升 P2/P3 |

---

## 8. 建议路径

```text
1. 日常继续：半自动闭环 + Option B + 可选 P0 sandbox
2. 人工填写 §6 P1 签核 → go
3. 另开 P1 实现（draft_generation_only；主仓外优先）
4. 验收：草稿含水印；无剪贴板/发送；主仓 scripts/INDEX 无 diff
5. P2/P3：仍 hold/reject，另开高风险审计
```

---

## 9. 与既有文档关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) | 总分级；本文件细化 P1 |
| [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) | P0 收口；升级须新评估/签核 |
| [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md) | 仅 P0；不覆盖 P1 |
| [`RISK_GATE.md`](RISK_GATE.md) | 高风险 → need_confirm / 停 |

---

## 10. 相关文件

- [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md) · [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)  
