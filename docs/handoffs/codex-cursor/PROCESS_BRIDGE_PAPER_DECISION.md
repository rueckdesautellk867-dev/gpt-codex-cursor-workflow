# Option C Step 1：进程级桥接纸面评估报告

> **评估对象**：Codex ↔ Cursor **进程级互通 / 桥接**（稳定接口投递 `CODEX_INSTRUCTION` / `CURSOR_RESULT` / `CODEX_JUDGEMENT`，减少人工粘贴）。  
> **本文件性质**：纸面决策报告；**不**写桥接代码、**不**接 API、**不**安装工具、**不**试点真 Agent 执行。  
> **服从**：[`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`RISK_GATE.md`](RISK_GATE.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)（稳定半自动仍是主通道）  
> **日常入口**：Option B [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) / `scripts/show-codex-cursor-loop-status.ps1`

---

## 1. 结论（必须四选一）

| 字段 | 值 |
|------|-----|
| **决策** | **`sandbox`** |
| 含义 | 允许**未来另开任务**做主仓外、**只读 / 提示型**沙盒验证；**禁止**进入 `pilot`；**禁止**真执行 / 自动判责 / 自动入库 |
| 日常推荐 | 继续 **Option A（稳定半自动）+ Option B（一键观察）**；桥接不是日常依赖 |

**明确否定**：当前 **不得**标为 `pilot`。  
**不选 `reject`**：长期目标仍可探索官方可控接口；当前证据不足以永久否决，但也不够放行试点。  
**相对 `hold`**：`hold` 仅「继续观察」；本报告将「下一允许动作」收窄为可审计的 sandbox 门槛，避免无边界地讨论「怎么自动」。

---

## 2. 为什么不应直接 `pilot`

对照 [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) §3，当前主仓状态：

| # | 前提 | 当前状态 |
|---|------|----------|
| 1 | 官方/稳定可脚本化 Codex↔Cursor 互通 API/CLI | **未在本仓得到可引用的接口契约**；不得假设存在 |
| 2 | 默认可关闭自动执行（只投递/只提示） | **未建立**可配置桥接与默认关闭策略 |
| 3 | commit/push 不能由桥接触发 | 稳定半自动已落实人工授权，但**进程桥未证明不会短路** |
| 4 | 保留 RISK_GATE / `blocked` | 文档闸门存在；**自动通道尚未证明不会绕过** |
| 5 | 可审计日志（task_id / round / 时间 / 是否确认） | **无**桥接投递审计实现 |
| 6 | 一键禁用后文件接力仍可用 | 文件接力已可用；桥接侧 **无** kill switch 实现 |

任一未满足 → 按评估方案 **不得进入 `pilot`**。另缺：清晰权限模型、隐私边界、失败重试上限。

非官方 UI 点击 / 键鼠 / 进程注入 → 直接归入禁止项，等价于走向 `reject` 路径，**本报告不批准**。

---

## 3. 当前已有替代方案（足够日常）

| 能力 | 作用 |
|------|------|
| 文件 handoff | instruction / result 主通道 |
| Watcher | 通知，不执行 |
| queue / INDEX 只读脚本 | 待判责与 INDEX 建议 |
| 一键观察（Option B） | `show-codex-cursor-loop-status.ps1` 日常总览 |
| 人工判责 + 授权 commit/push | 闭环收口 |
| SAFE_INDEX_APPLY | INDEX 写入门槛 |

**判断**：在缺少官方可控 API 前，替代方案已覆盖「可复盘的半自动闭环」；进程桥接的边际收益 **未证明** 大于自动执行与越权风险。

---

## 4. 关键风险

| 风险 | 说明 |
|------|------|
| 自动执行误触发 | 消息直达 Agent → 未读 instruction 即开跑 |
| 高风险绕过 RISK_GATE | 「便利」短路 `blocked` / `need_confirm` |
| 自动 commit/push 越权 | 桥接触发入库，突破人工授权句 |
| API/插件权限不清 | 过度授权读写工作区、密钥、网络 |
| 日志 / 隐私泄露 | 投递日志夹带 token、cookie、`.env`、账号材料 |
| 失败循环 / 重复执行 | 无幂等与重试上限 → 同一 instruction 多次执行 |
| AICF 运营链路误连 | 抓取/发布/F4/日更等被桥接带入 |

---

## 5. 进入 `sandbox` 的必要条件（全部满足）

仅当**计划中的沙盒实验**满足下列全部条件时，才允许另开 instruction 实施（本报告本身不实施）：

1. **只读或提示型**：可监听 / 展示路径与摘要；最多生成「请人工粘贴的命令」  
2. **不执行** instruction（不打开 Cursor/Codex 自动跑 Agent）  
3. **不写** INDEX；不改 STATE / RISK_GATE 正文  
4. **不** commit / push  
5. **不接** AICF 运营链路  
6. **明确 kill switch**：一键停用后零依赖桥接；文件接力仍完整可用  
7. **本地日志**：含 task_id / round / 时间 / 动作类型；**禁止**敏感内容（密钥、cookie、token、完整 `.env`）  
8. **可复现回滚**：实验产物在主仓外或可丢弃目录；主仓默认无桥接副作用  

任一不满足 → 保持观察（等价继续 `hold`），不得开工。

---

## 6. sandbox 最小实验建议（若未来另开任务）

| 允许 | 禁止 |
|------|------|
| 仅监听 handoff 的 instruction / result **文件事件**（或 mock） | 自动打开 Cursor / Codex 执行 |
| 仅生成提示文案或可复制命令（stdout / 本地日志） | 自动判责、写 judgement、写 INDEX |
| 主仓外目录或明确隔离工作区 | 读 `.env` / cookie / token / 账号材料 |
| 假数据验证消息格式与审计字段 | 接网络 / 外部 API（除非**另开任务并完整授权**） |
| 验证 kill switch | UI 点击、键鼠模拟、非官方进程注入 |

**成功标准（沙盒）**：能演示「文件变更 → 提示/日志」且可一键关闭；**失败不影响**主仓半自动路径。  
**非成功标准**：不得以「已经能自动跑任务」作为 sandbox 完成定义。

---

## 7. 与已有文档的关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) | 本报告为其 §6「另开任务撰写」的决策产出；阶梯不可跳级 |
| [`RISK_GATE.md`](RISK_GATE.md) | 任何未来桥接消息必须可映射到风险阻断；高风险默认 blocked |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) | **不被本报告替代**；日常仍按半自动路径 |
| [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | **Option B 仍是推荐日常观察入口** |
| CURSOR_RECEIVE / CODEX_JUDGEMENT_SEMI_AUTO | 桥接不得削弱「人确认」语义 |

---

## 8. 建议下一动作

| 优先级 | 动作 |
|--------|------|
| **现在** | 继续日常使用稳定半自动 + Option B 观察；不写桥接代码 |
| **若推进 Option C** | 另开低风险 instruction：主仓外 mock / 只读提示型 sandbox（对照 §5–§6） |
| **暂缓** | `pilot`、半自动真投递到 Agent、任何自动 commit/push、任何 AICF 捆绑 |
| **若仅发现非官方 hack** | 将决策修订为 **`reject`**（另开纸面修订任务） |

---

## 9. 决策摘要表

| 项 | 内容 |
|----|------|
| 决策 | **`sandbox`** |
| 当前可否实现桥接代码 | **否**（本报告不授权） |
| 当前可否 `pilot` | **否** |
| 日常主通道 | 文件接力 + Watcher + 人工判责/授权 + Option B |
| 锚点语境 | 稳定半自动已达成；Option B 已落地；Option C 仅纸面准入 |

---

## 10. 相关文件

- [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)  
- [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
- [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md) · [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)  
