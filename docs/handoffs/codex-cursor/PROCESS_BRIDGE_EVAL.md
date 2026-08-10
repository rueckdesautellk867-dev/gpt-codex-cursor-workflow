# 进程级桥接评估方案（Automation Step 8）

> **这是什么**：如何评估「Codex ↔ Cursor 不靠人工粘贴、而经稳定接口传 instruction/result」的**可行性与准入闸门**。  
> **当前结论倾向**：**不做**实装；默认决策起点为 `hold` / `reject`，直到前提满足。  
> **这不是桥接实现**：本文件不授权写桥接代码、不接 API、不做自动执行。  
> 相关：[`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md) · [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md) · [`RISK_GATE.md`](RISK_GATE.md) · `docs/codex-cursor-loop-phase-closeout.md`

---

## 1. 什么是进程级桥接

| 概念 | 说明 |
|------|------|
| 进程级桥接 | Codex 与 Cursor（或其官方 CLI/Agent API）之间，由**稳定、可审计**的接口传递 `CODEX_INSTRUCTION` / `CURSOR_RESULT` / `CODEX_JUDGEMENT`，减少人工复制粘贴 |
| 与现网差异 | 今天：文件接力 + 可选 Watcher **通知** + 人工粘贴；桥接：程序投递消息，但仍可要求人确认执行 |

桥接 **≠** 无人值守自动改代码；即使有桥，执行与入库仍可（且本方案要求必须）受人控闸门约束。

---

## 2. 当前为什么不做

1. **未确认**稳定、官方、可脚本化的 Cursor ↔ Codex 互通 API/CLI（纸面不得假设存在）  
2. **自动执行风险高**：一旦消息直达 Agent，易在无阅读 instruction 的情况下开跑  
3. **易绕过闸门**：人工授权 commit/push、[`RISK_GATE.md`](RISK_GATE.md)、STATE `blocked` 可能被「便利」短路  
4. 半自动层（Step 6/7）+ 文件接力 **已够用**；桥接收益未证明大于风险（同 P3/P4 保守原则）  

因此：**本阶段不写桥接代码、不接 API、不试点进程注入。**

---

## 3. 评估前提（全部满足才允许离开「默认不做」）

| # | 前提 | 说明 |
|---|------|------|
| 1 | 官方/稳定接口 | 有文档化、可版本约束的 API 或 CLI；禁止靠猜 DOM/私有协议 |
| 2 | 可关闭自动执行 | 桥接可配置为「只投递文件/只提示」，默认 **不**自动跑 Agent |
| 3 | 保留人工授权入库 | commit/push **不能**由桥接触发；须用户明确授权句 |
| 4 | 保留 RISK_GATE | 高风险消息不得自动进入执行通道；默认 `blocked` |
| 5 | 可审计 | 每条投递有日志：task_id、round、时间、是否人工确认 |
| 6 | 可一键禁用 | 关闭桥接后，文件接力闭环完全可用（零依赖桥接） |

任一前提不满足 → 决策不得进入 `pilot`。

---

## 4. 评估模式（阶梯，不可跳级）

```text
纸面评估（本文件 / 后续报告）
    → sandbox（主仓外；只读或假消息；不连生产 Agent）
    → 只读 bridge（仅同步/展示 instruction·result 路径，不触发执行）
    → 半自动 bridge（投递后仍须人在 Cursor/Codex 侧确认才执行/判责）
    → （不默认）全自动  —— 本仓路线图默认禁止
```

| 阶段 | 允许 | 禁止 |
|------|------|------|
| 纸面 | 文档、清单、决策 | 任何代码/安装 |
| sandbox | 假数据、mock 接口 | 连真实仓写改、真 Agent 执行 |
| 只读 bridge | 读 handoff、刷新 QUEUE 视图 | 写 judgement、开跑 Cursor |
| 半自动 | 投递路径/内容到对话入口后 **等人确认** | 跳过确认、跳过 RISK_GATE |

---

## 5. 禁止事项（硬）

- UI 自动点击、键鼠模拟、窗口窥探  
- 非官方进程注入、挂钩、内存补丁  
- 自动执行高风险任务 / AICF 运营链路  
- 自动 commit / push  
- 绕过 STATE `blocked` 或 RISK_GATE  
- 将 Documents 旁路仓当桥接锚点  
- 为「打通」而关闭人工授权  

---

## 6. 决策输出

评估报告（**另开任务**撰写）结论必须为以下之一：

| 决策 | 含义 |
|------|------|
| `reject` | 不采用进程级桥接；长期维持文件接力 + 半自动 Step 6/7 |
| `hold` | 暂缓；接口或闸门未清，继续观察官方能力 |
| `sandbox` | 仅允许主仓外沙盒验证接口形态，仍禁止真执行 |
| `pilot` | 小范围半自动桥接试点（仍禁自动执行高风险与自动入库） |

推荐默认：**当前纸面起点 = `hold`**（无稳定接口证据时不得标 `pilot`）。  
若明确只有非官方 hack 可行 → **`reject`**。

---

## 7. 与现有层的关系

| 层 | 关系 |
|----|------|
| 文件接力 / Watcher | **主通道**；桥接最多是可选加速，失败须回退 |
| CURSOR_RECEIVE / CODEX_JUDGEMENT_SEMI_AUTO | 桥接不得削弱其「人确认」语义 |
| RISK_GATE / STATE / QUEUE | 桥接消息必须仍能映射到状态机与风险阻断 |
| 路线图 P4 | 与本 Step 对齐；无接口则不推进 |

---

## 8. 建议后续任务（均须另开 instruction）

1. 纸面报告：对照 §3 前提打勾 → `reject` / `hold` / `sandbox` / `pilot`  
2. 若 `sandbox`：主仓外 mock，只验证消息格式与日志  
3. 永不与 AICF 发布/抓取任务捆绑评估  

---

## 9. 风险闸门

1. 无官方稳定接口 → 不做  
2. 不能关闭自动执行 → 不做  
3. 不能保留人工 commit/push 与 RISK_GATE → 不做  
4. 禁止键鼠/注入类「假桥接」  

---

## 10. 相关文件

- [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md)  
- [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`STATE.md`](STATE.md) · [`QUEUE.md`](QUEUE.md)  
- `docs/codex-cursor-loop-phase-closeout.md`  
- `docs/codex-cursor-loop-status-roadmap.md`（P4）  
