# 稳定半自动闭环阶段收口（Automation Step 21）

> **阶段结论**：**稳定半自动闭环已达成**。  
> **这不是什么**：不是进程级自动互通；不是无人值守执行；不自动判责；不自动 commit/push；不自动写 INDEX。  
> 相关：[`E2E_REAL_TASK.md`](E2E_REAL_TASK.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md) · [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md)

---

## 1. 阶段锚点

| 项 | 值 |
|----|-----|
| 主仓路径 | `D:\AIContentFactory\三方闭环整合项目` |
| 远程 | `origin/main`（`gpt-codex-cursor-workflow`） |
| **E2E 已跑通语义锚点** | **`9721362`**（`docs: run e2e real doc task`） |
| Steps 1–8 方案锚点（较早） | `62642d3`（见 [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md)） |

本文件入库后 tip 会前移；**「E2E 低风险真实文档任务已跑通」**仍以 `9721362` 为语义锚点。

---

## 2. 阶段结论（一句话）

文件接力 + Watcher 通知 + 只读 queue / INDEX 建议 + 人工判责 + 人工授权 commit/push + SAFE_INDEX_APPLY —— **可用、可复盘、边界清晰**。  
**未**进入进程级 Codex↔Cursor 互发，也**未**进入无人值守。

---

## 3. 已建立能力

| 能力 | 说明 | 自动执行？ |
|------|------|------------|
| instruction / result 文件接力 | handoff 目录 + 协议模板 | **否**（人粘贴/打开） |
| Watcher 通知 | `scripts/watch-codex-cursor-handoff.ps1` | 仅通知，不执行 |
| 状态机 / INDEX / QUEUE / RISK_GATE | 文档规则 + 轻量 INDEX | **否** |
| Cursor 接收侧 / Codex 判责侧方案 | [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md) · [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md) | **否**（半自动清单） |
| queue 只读待判责 | `scripts/list-codex-cursor-queue.ps1` | 只读 |
| INDEX suggestion 只读建议 | `scripts/suggest-codex-cursor-index.ps1` | 只读 |
| SAFE_INDEX_APPLY | [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) 人工写入流程 | **否**（人确认后写） |
| Watcher ↔ queue / INDEX 联动方案 | [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) | 提示用，不自动跑 |
| 一键观察方案 | [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)（R0 人工分跑；R1 脚本未做） | **否** |
| E2E 低风险真实文档 | 按 [`E2E_REAL_TASK.md`](E2E_REAL_TASK.md)；Step 20 已推送 `9721362` | 人触发 |

---

## 4. 仍未建立

| 未建立 | 说明 |
|--------|------|
| 自动打开 Cursor | 仍须人工打开 / 粘贴 instruction |
| Codex / Cursor 进程级互发 | 见 [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)；当前默认不做 |
| 自动执行 instruction | 禁止 |
| 自动判责 | 禁止 |
| 自动 commit / push | 禁止；须完整人工授权句 |
| 自动写 INDEX | 禁止；须按 SAFE_INDEX_APPLY |
| 一键观察聚合脚本 R1 | 仅有方案 [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) |
| 无人值守后台闭环 | 明确不在本阶段范围 |

---

## 5. 当前推荐使用路径

```text
1. Codex 出 instruction（文件或粘贴）
2. （可选）Watcher 通知 instruction
3. Cursor 执行并写 result
4. （可选）Watcher 通知 result
5. 人工 / Codex 跑 list-codex-cursor-queue.ps1（或 ONE_SHOT_OBSERVER R0）
6. Codex 判责 pass / continue / stop
7. 人工授权 commit → 再人工授权 push（可分授）
8. 必要时跑 suggest-codex-cursor-index.ps1
9. 按 SAFE_INDEX_APPLY 决定是否更新 INDEX（另授）
```

高风险 / `blocked` / `need_confirm` → 先 [`RISK_GATE.md`](RISK_GATE.md)，不继续运营或跨仓动作。

---

## 6. 下一阶段选项

| 选项 | 内容 | 风险注意 |
|------|------|----------|
| **Option A（推荐默认）** | **停在稳定半自动**，进入日常使用；按 §5 路径跑文档/低风险任务 | 保持现有边界即可 |
| **Option B** | 做一键观察脚本 R1：`scripts/show-codex-cursor-loop-status.ps1`（只读聚合；见 [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)） | 低；另开 instruction；仍不写文件 |
| **Option C** | 评估进程级桥接 / MCP / API | **须走** [`RISK_GATE.md`](RISK_GATE.md) + [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)；默认不做实装；禁止 UI 注入/非官方挂钩 |

选项可并行讨论，但 **C 不得跳过评估前提**；A 与 B 不依赖 C。

---

## 7. 与较早收口的关系

| 文档 | 覆盖 |
|------|------|
| [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md) | Steps 1–8 **方案层**收口 |
| 本文件 | Steps 9–20 落地后的 **稳定半自动**阶段收口（含脚本 + E2E） |
| [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) | 进程级互通仍为「评估后另议」，非本阶段交付物 |

---

## 8. 风险闸门（收口时仍成立）

1. 半自动 ≠ 自动执行 / 自动判责 / 自动入库  
2. INDEX 写入必须人工 + SAFE_INDEX_APPLY  
3. 进程级桥接未批准前不得试点注入或旁路 API  
4. 不进入 AICF 运营链路；Documents 旁路不是主仓  

---

## 9. 相关文件

- [`E2E_REAL_TASK.md`](E2E_REAL_TASK.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
- [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md)  
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md)  
- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1)  
- [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md) · [`RISK_GATE.md`](RISK_GATE.md)  
