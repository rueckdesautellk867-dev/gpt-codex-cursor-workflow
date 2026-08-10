# Option C：Pilot P2 hold 阶段收口

> **P2 结论**：**hold** — 不进入 API/UI/插件桥接实现。  
> **UI 自动化 / 键鼠模拟 / 进程注入**：**reject**。  
> **不可**：由本收口或 P1 **自然升级**为 P2 go / P3；不得「顺便」接 SDK、装插件、做 UI 控制。  
> 能力审计：[`PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md`](PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md)  
> 审计入库锚点：`6f6414b`（`docs: add bridge pilot p2 capability audit`）  
> 服从：[`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md) · [`RISK_GATE.md`](RISK_GATE.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)；日常主入口仍是半自动文件接力 + Option B [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)

---

## 1. 阶段结论

| 项 | 值 |
|----|-----|
| Level | **P2**（API/UI/插件桥接探索） |
| 决策 | **hold** |
| 是否实现 | **否** — 本阶段只完成能力审计与收口，**无**桥接代码 |
| 是否自动闭环 | **否**（亦不得借 P2 名义达成） |
| UI 自动化 | **reject** |
| P3 | 仍 **reject**（自动执行 / 自动判责 / 自动入库） |
| 签核 | **无 P2 Go 签核**；本文件不是授权实现 |

已完成链路（至此）：稳定半自动 → Option B → sandbox R1 → Pilot P0 → Pilot P1 → **P2 能力审计 → P2 hold 收口（本文件）**。

---

## 2. 审计要点（摘录）

| 路径 | verdict | 说明 |
|------|---------|------|
| 文件/粘贴接力 | **keep** | 日常主通道 |
| Option B one-shot observer | **keep** | 只读通知/观察 |
| sandbox P0/P1 | **keep** | 提示优化 / `draft_generation_only`；人工复制 |
| Cursor SDK / CLI / Cloud Agents API | **hold（high）** | 存在官方面，但是 **Agent 执行面**，不是默认可关执行的消息桥 |
| Codex 官方 thread handoff | **hold** | 本仓未确认稳定、可脚本、可关执行的接口 |
| OpenSpace / 未授权插件 | **hold** | 暂不安装 |
| UI 自动化 / 键鼠 / 注入 | **reject** | 路线图硬禁止 |

详见：[`PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md`](PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md)。

---

## 3. 不允许（硬）

本 hold 收口下 **禁止**：

| 禁止项 | 说明 |
|--------|------|
| API/UI/插件桥接 **实现** | 含 Cursor SDK/CLI/Cloud API 包装、hooks 投递实装 |
| UI 自动化 | 自动点击 IDE/网页控件 |
| 键鼠模拟 | SendInput / 焦点劫持类 |
| 进程注入 / DOM 窥探 / 私有协议 | 非官方伪桥 |
| 自动发送 | 未经人工确认把内容送进对话/Agent |
| 自动执行 | 未经确认触发 Agent run / instruction 开跑 |
| 自动判责 | 机器写最终 `decision: pass` 并当作闭环完成 |
| 自动 commit / push | 入库须用户明确授权句 |
| 写 `INDEX.md` / 改 STATE / 改 RISK_GATE | 本收口与任何「便利桥接」均不得顺带改 |
| 碰 AICF 运营链路 | 发布 / 抓取 / 登录 / F4 / 日更 |

「存在 Cursor SDK」**不等于**「P2 可 go」。

---

## 4. 保留路径（继续用）

| 路径 | 用途 |
|------|------|
| 文件接力 + 人工粘贴 | Codex instruction ↔ Cursor result 主通道 |
| Option B one-shot observer | 本地只读状态一览 / 通知减负 |
| sandbox R1 + Pilot P0/P1 | 主仓外只读提示与草稿生成；`DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED` |
| 稳定半自动文档任务 | 低风险真实任务日常路径 |

sandbox 路径（可选，主仓外）：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`

---

## 5. 解除 hold 的条件（全部满足才可另开 Go）

离开 **hold** 前须 **全部** 满足，并另开任务 + **新签核**（本文件不构成签核）：

1. **明确官方接口** — 文档化、可版本约束；职责是投递 instruction/result，**不是**默认跑 Agent  
2. **权限模型清楚** — 最小读写面；禁止宽 cwd / 默认云端执行  
3. **dry-run 默认** — 未显式关闭不得产生对外副作用  
4. **人工确认点** — 至少执行前与入库前须人确认  
5. **kill switch** — 默认关闭；一键停；停后文件接力仍可用  
6. **本地非敏感日志** — task_id / round / 时间 / 动作类型；禁密钥正文  
7. **不读密钥** — 不读 `.env` / cookie / token（API key 若必需须显式通道且不入库）  
8. **不触碰 AICF 运营链路**  
9. **不自动 commit/push**；不绕过 RISK_GATE  
10. **与 P3 隔离** — 不得把「SDK 一键跑 Agent」标成 P2 go  
11. **新签核** — 独立 `PROCESS_BRIDGE_PILOT_P2_SIGNOFF`（尚未创建）；原 P0/P1 签核 **不覆盖** P2  

任一不满足 → **继续 hold / no-go**。

---

## 6. 下一阶段

| 优先级 | 动作 |
|--------|------|
| **1（默认）** | **停在 P1**：日常半自动 + Option B + 可选 sandbox P0/P1 |
| 2 | 若仍要推进 P2：**仅**可另开「权限 / 日志 / dry-run / kill-switch」**专项审计**（纸面）；**仍不写实现** |
| 停 | 不接 API、不装插件、不做 UI 自动化、不写桥接代码、不升 P3 |

推荐默认：**不继续自动化扩张**；把精力放在真实低风险文档任务。

---

## 7. 相关文件

- [`PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md`](PROCESS_BRIDGE_PILOT_P2_CAPABILITY_AUDIT.md) · [`option-c-p2-api-ui-capability-audit-r01-result.md`](option-c-p2-api-ui-capability-audit-r01-result.md)  
- [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md) · [`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`RISK_GATE.md`](RISK_GATE.md)

---

## 8. 收口签字栏（纸面）

| 项 | 值 |
|----|-----|
| P2 decision | **hold** |
| UI 自动化 | **reject** |
| 实现授权 | **无** |
| 可标 P2 go？ | **否** |
| 下一默认阶段 | **停在 P1** |
