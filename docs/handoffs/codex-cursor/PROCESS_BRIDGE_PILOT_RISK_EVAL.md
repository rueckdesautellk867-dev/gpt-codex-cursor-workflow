# Option C Step 10：Pilot 风险评估与重新签核方案

> **这是什么**：在 sandbox R1（`readonly_hint_only`）之上，若继续探索更自动的桥接，须先完成的**风险分级、硬门槛与重新签核**方案。  
> **这不是什么**：不是 pilot 实现授权；不写 pilot 代码；不改 sandbox runner；不接 API；不装插件。  
> **默认建议**：**允许评估 P0 / P1**；**P2 = hold**（须另查 API/权限/日志能力）；**P3 = reject**。  
> 服从：[`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) · [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)（日常主通道仍是稳定半自动 + Option B）

---

## 1. Pilot 是什么 / 不是什么

### 1.1 是什么

从只读提示型 sandbox 进一步尝试**更自动的桥接能力**，在严格闸门下可能包括：

| 方向（须分级） | 示例 |
|----------------|------|
| 提示增强 | 更好的摘要、复制块、下一步建议 |
| 半自动转交 | 生成待粘贴的 instruction/result/judgement 包，**人工确认后**才发送/粘贴 |
| （更高阶）本地 API/插件桥接 | 仅在 P2+ 且审计通过后另议 |

### 1.2 不是什么

| 禁止误解 | 说明 |
|----------|------|
| 无人值守 | pilot ≠ 无人值守闭环 |
| 自动执行 instruction | 即使标 pilot，默认仍须人工确认才执行 |
| 自动 commit / push | 入库授权句不可被桥接触发 |
| 绕过 RISK_GATE | 高风险 / `blocked` / `need_confirm` 仍须停下 |
| 由 R1 直接升级 | [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) 明确禁止 |

原 sandbox Go 签核（[`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md)）**不覆盖** pilot；须按本文件**重新签核**。

---

## 2. 必须先分级（P0–P3）

| Level | 含义 | 默认决策 |
|-------|------|----------|
| **P0** | 仍只读；只优化提示与复制块（可仍在主仓外 sandbox） | **可评估**；条件满足可 go |
| **P1** | 半自动生成待粘贴内容；**人工确认后**才发送/粘贴；不自动跑 Agent | **可评估**；条件满足可 go |
| **P2** | 尝试本地 API / 插件桥接；仍不执行高风险动作；须权限与审计 | **hold**；默认 no-go，除非另有 API/权限/日志审计通过 |
| **P3** | 自动执行 / 自动判责 / 自动入库 | **reject**；默认永久 no-go（本路线图） |

不可跳级：未完成并签核较低 level，不得实施更高 level。

---

## 3. 默认建议（本轮纸面）

| Level | 建议 |
|-------|------|
| P0 / P1 | **允许评估**；实现前须重新签核 `go` + 满足 §5 硬门槛 |
| P2 | **hold**；先另开任务查清官方可控 API、权限模型、审计日志、kill switch |
| P3 | **reject**；不纳入当前 Option C 前进路径 |

与 [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) 一致：无官方稳定接口与可关闭自动执行 → 不得进真执行型 pilot。

---

## 4. 关键风险

| 风险 | 说明 |
|------|------|
| 自动执行误触发 | 消息/API 直达 Agent → 未读 instruction 即开跑 |
| 权限越界 | 插件/API 读写过宽（含密钥、全盘、网络） |
| 高风险绕过 | 便利短路 RISK_GATE / STATE `blocked` |
| 重复执行 / 循环 | 无幂等与重试上限 → 同一任务多次跑 |
| 日志泄密 | 投递/桥接日志夹带 token、cookie、`.env` |
| API/插件权限不透明 | 无法审计、无法一键禁用 |
| Git 状态污染 | 桥接静默改主仓 / 误 commit |

命中高风险运营意图（AICF 抓取/发布等）→ 直接 [`RISK_GATE.md`](RISK_GATE.md)，本文件不放行。

---

## 5. 进入任意 Pilot 实现的硬门槛（全部满足）

1. **明确 `pilot_level`**：P0 / P1 / P2 / P3（且与签核一致）  
2. **明确输入 / 输出**（读什么、写什么、是否只 stdout / 仅 sandbox）  
3. **明确人工确认点**（发送前 / 执行前 / 入库前）  
4. **Kill switch**（默认关闭；可一键停；停后半自动路径仍可用）  
5. **本地非敏感日志**（task_id / round / 时间 / 动作类型；禁密钥正文）  
6. **dry-run 默认**（未显式关闭 dry-run 不得产生对外副作用）  
7. **不读密钥**（`.env` / cookie / token）  
8. **不触碰 AICF 运营链路**  
9. **不自动 commit / push**  
10. **不绕过 RISK_GATE**；P2+ 另须 API/权限审计文档  

任一不满足 → **no-go**。

---

## 6. 重新签核模板（可复制）

原 sandbox 签核**不足**以启动 pilot。将下列块复制到独立记录（实现 instruction 附录或本地签核；**本方案入库不等于已签**）：

```markdown
## PROCESS_BRIDGE_PILOT_SIGNOFF

- date:
- approver:
- pilot_level: P0 / P1 / P2 / P3
- decision: go / no-go
- allowed:
  - (list only what this level permits)
- forbidden:
  - execute instruction automatically (unless explicitly carved for a future level — default forbidden)
  - control Cursor/Codex UI without human confirm
  - call Codex/Cursor API without audited allowlist
  - read .env / cookie / token
  - write main repo / INDEX without separate auth
  - git commit / push
  - network outbound (unless audited allowlist)
  - touch AICF operation/publishing chain
  - bypass RISK_GATE
- kill_switch:
- rollback:
- dry_run_default: yes
- notes:
```

`decision: go` 时必须把 `pilot_level` 收成单一值（如 `P0`），并写清 `allowed` 不超过该 level。

---

## 7. Go / No-Go 规则

| 规则 | 结果 |
|------|------|
| `pilot_level` 为 **P0 或 P1**，§5 全部满足，签核 `decision: go` | **可另开**对应实现 instruction |
| `pilot_level` 为 **P2** | **默认 no-go / hold**；除非另有 API·权限·日志审计通过并写入 notes |
| `pilot_level` 为 **P3** | **no-go / reject** |
| 未签核、`decision` 空缺、或需放开 §6 `forbidden` 核心项 | **no-go** |
| 拟无人值守、自动入库、绕过 RISK_GATE | **no-go** |
| 仅持有 sandbox R1 Go、无本 pilot 签核 | **no-go**（不得实现 pilot） |

**`go` ≠ 已实现**：仍须另开实现 instruction；本文件只定评估与签核门槛。

---

## 8. 建议路径（评估后）

```text
1. 保持日常：稳定半自动 + Option B + 可选 sandbox R1
2. 若要增强：优先评估 P0（提示优化）→ 重新签核 → 另开实现
3. 再考虑 P1（待粘贴包 + 人工确认发送）
4. P2 仅在官方接口与审计齐备后重开评估
5. P3 保持 reject
```

---

## 9. 与既有文档的关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) | R1 可用但不升 pilot；本文件定义「若要升」的评估门 |
| [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) | 仅覆盖 readonly sandbox；pilot 须新签核 |
| [`RISK_GATE.md`](RISK_GATE.md) | 高风险 / 越权意图直接阻断 |
| [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) | 进程桥阶梯与禁止注入仍生效 |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | 日常主通道与观察入口不变 |

---

## 10. 相关文件

- [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md)  
- [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)  
