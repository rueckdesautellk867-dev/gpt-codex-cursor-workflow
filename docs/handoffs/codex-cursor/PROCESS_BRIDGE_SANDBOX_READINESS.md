# Option C Step 3：只读桥接 Sandbox 实现前检查清单（Readiness）

> **这是什么**：进入 **sandbox 实现**之前的**人工确认清单**，防止从「方案已写好」滑到「直接自动执行 / 正式桥接」。  
> **这不是什么**：**不是**实现授权；**不是**安全豁免；**不替代** [`RISK_GATE.md`](RISK_GATE.md)。  
> 勾选通过且签核 `go` 之后，仍须**另开**带完整范围的 sandbox implement instruction，才允许写代码 / 建目录。  
> 服从：[`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)（结论 `sandbox`）· [`RISK_GATE.md`](RISK_GATE.md)  
> 不替代：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)（日常主通道仍是稳定半自动 + Option B）

---

## 1. 用途

| 问题 | 答案 |
|------|------|
| 何时用 | 打算开「只读/提示型 sandbox 实现」任务之前 |
| 谁填 | 人工 approver（仓库 owner / 值班人） |
| 通过意味着什么 | 边界已口头/书面确认，**可以起草**实现 instruction |
| 通过不意味着什么 | 不自动创建目录、不自动写代码、不放行 API、不放行 pilot |

---

## 2. 必须确认项（Checklist）

全部勾选为「是 / 已确认」后，才允许考虑 `go`。

| # | 确认项 | 是 / 否 | 备注 |
|---|--------|---------|------|
| 1 | **sandbox 目录明确且在主仓外**（建议：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`） | | |
| 2 | **不使用 Documents 旁路**作为锚点或工作根 | | |
| 3 | 范围限定为**只读 / 提示型**（提示、可复制命令/块、本地日志） | | |
| 4 | **不自动执行** instruction（不打开 Cursor/Codex Agent 自动跑） | | |
| 5 | **不自动判责** | | |
| 6 | **不写主仓文件**（含 handoff、watcher lock/state、脚本） | | |
| 7 | **不写 INDEX**（不走静默 apply） | | |
| 8 | **不**由本实验触发 **commit / push** | | |
| 9 | **不读取** `.env` / cookie / token / 账号材料 | | |
| 10 | **不接网络 / API**（默认禁网；接网须另开并完整授权，本清单默认否） | | |
| 11 | 有 **kill switch**（默认关闭；文件开关 + 可进程停止；见 SANDBOX_PLAN） | | |
| 12 | 有 **日志位置**，且约定日志**不含敏感内容** | | |
| 13 | 有 **清理 / 停止方式**（关 flag、杀进程、可删 logs/out；主仓无残留写入） | | |
| 14 | 实现任务将**单独授权**创建/使用 sandbox 目录（本清单本身不创建） | | |
| 15 | 明确本实验 **不是 pilot**、**不是**正式进程桥接入 | | |

打印或复制本表填写时，将「是 / 否」列改为 `yes` / `no`。

---

## 3. Go / No-Go 规则

| 规则 | 结果 |
|------|------|
| §2 **任一**项无法确认、为否、或含糊 | **`no-go`** |
| 场景命中高风险 / 拟自动执行 / 拟接运营链路 / 拟读密钥 | **`no-go`**，另走 [`RISK_GATE.md`](RISK_GATE.md)，不得用本清单放行 |
| 拟使用 UI 点击、键鼠、非官方注入充当「桥接」 | **`no-go`**（倾向纸面决策修订为 `reject`） |
| §2 **全部**为是，且签核块 `decision: go` | 仅表示 **可以另开** sandbox 实现 instruction |
| 未签核或 `decision` 空缺 | 视为 **`no-go`** |

**`go` ≠ 已授权实现**：实现 instruction 仍须写清路径、只读命令、日志、清理、禁止项；未开 instruction 前不得写代码、不得建目录（除非该 instruction 明确授权建目录）。

---

## 4. 建议人工签核块

将下列块复制到独立记录（可放在实现 instruction 附录，或本地笔记；**不必**改本文件）：

```markdown
## Sandbox readiness sign-off

| 字段 | 值 |
|------|-----|
| date | YYYY-MM-DD |
| approver | |
| sandbox_path | D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\ |
| decision | go / no-go |
| notes | |

Checklist §2: all yes? yes / no
Paper decision: sandbox (readonly/prompt-only)
Plan doc: PROCESS_BRIDGE_SANDBOX_PLAN.md
Risk: low only; RISK_GATE if escalated
```

---

## 5. 与已有文档的关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) | 实验范围与门槛；本清单是其「进入实现」前的人工门禁 |
| [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) | 决策仍为 `sandbox`；本清单不升级为 `pilot` |
| [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) | 阶梯不可跳级；禁止事项仍硬生效 |
| [`RISK_GATE.md`](RISK_GATE.md) | 高风险 / 越权意图 → 本清单直接 No-Go |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | 日常主通道不变；sandbox 可选且可关闭 |

---

## 6. 建议流程

```text
1. 阅读 SANDBOX_PLAN + 本清单
2. 人工填写 §2 与 §4 签核块
3. decision=no-go → 停止；修边界或走 RISK_GATE
4. decision=go → 另开 sandbox 实现 instruction（低风险、只读、主仓外）
5. 实现任务内再授权：创建目录 / 写 sandbox bin / 日志路径
6. 完成后验证 kill switch 与「主仓无写入」
```

---

## 7. 相关文件

- [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md)  
- [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)  
