# 最终阶段收口：三方闭环自动化边界与默认使用路径

> **当前结论**：闭环已达到「**可日常使用的半自动 + 只读 / P1 草稿辅助**」。  
> **仍不是**：无人值守自动闭环；进程级正式互通；自动发送 / 执行 / 最终 pass 判责。  
> **OpenSpace**：**暂不安装**。  
> **P2**：**hold** · **P3**：**reject**（不得由本收口自然推进）。  
> **阶段语义锚点**：`6bcdcd7`（`docs: add bridge pilot p1 closeout`）；本文件入库后 tip 会前移，语义仍以该锚点为「P1 收口齐备」。  
> 分层收口：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md)  
> OpenSpace 纸面：[`docs/p3-openspace-paper-eval-report.md`](../../p3-openspace-paper-eval-report.md)

---

## 1. 阶段结论（一句话）

文件接力 + Watcher 通知 + 只读 queue/INDEX 建议 + 一键观察 +（可选）主仓外 sandbox P0/P1 草稿辅助 —— **可日常跑真实低风险文档任务**；执行、判责、入库仍**人工**；**不装 OpenSpace**；**不进 P2/P3**。

---

## 2. 默认使用路径

```text
1. （推荐）运行 Option B one-shot observer：
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1
2. Codex 生成 instruction（文件或粘贴）
3. Cursor 按 instruction 执行并写 result
4. （可选）Watcher 通知；或再跑 observer / queue
5. Codex 判责 pass / continue / stop
6. 人工授权 commit → 再人工授权 push（可分授）
7. 必要时跑 suggest-codex-cursor-index.ps1
8. 按 SAFE_INDEX_APPLY 人工决定是否更新 INDEX
9. （可选）主仓外 sandbox P0/P1：
   powershell -NoProfile -ExecutionPolicy Bypass -File D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\run-readonly-bridge.ps1 -Once
   → 看 hints / copy blocks / DRAFT 块 → 人工复制粘贴（永不自动发送）
```

高风险 / `need_confirm` / `blocked` → 先 [`RISK_GATE.md`](RISK_GATE.md)。

---

## 3. 已完成能力清单

| 层 | 能力 | 说明 |
|----|------|------|
| 协议 / handoff | instruction · result · 模板 | 文件接力主通道 |
| Watcher | `watch-codex-cursor-handoff.ps1` | 通知，不执行 |
| 状态 / 索引 | STATE · INDEX · QUEUE · RISK_GATE | 规则 + 轻量 INDEX |
| 只读脚本 | queue / INDEX suggest | 不写 INDEX |
| Option B | `show-codex-cursor-loop-status.ps1` | **日常观察主入口** |
| SAFE_INDEX_APPLY | 人工写 INDEX 流程 | 不自动 apply |
| sandbox R1 | 主仓外只读提示 runner | 不进主仓 git |
| Pilot P0 | hints + NEXT_ACTION 复制块 | 人工复制 |
| Pilot P1 | `DRAFT_ONLY` / `HUMAN_REVIEW_REQUIRED` 草稿 | 人工复制发送；无最终 pass |

E2E：低风险真实文档任务已跑通（见稳定半自动 / E2E 文档）。

---

## 4. 当前硬边界

| 禁止 | 说明 |
|------|------|
| 自动发送 | 含剪贴板代发、进程投递到 Cursor/Codex |
| 自动执行 instruction | 不打开 Agent 代跑 |
| 自动判责 `pass` | P1 最多 `review_needed` / `need_confirm` |
| 写主仓 / INDEX（由桥接/sandbox 静默写） | INDEX 仅 SAFE_INDEX_APPLY + 另授 |
| 自动 commit / push | 须完整人工授权句 |
| API / UI 控制 | 禁止键鼠注入、非官方挂钩 |
| 网络外呼（sandbox/bridge 默认） | 禁止 |
| AICF 运营链路 | 抓取 / 发布 / F4 / 日更等禁止经本闭环触发 |
| Documents 旁路当主仓 | 禁止 |
| 无人值守全自动闭环 | **未达成，也不作为默认目标** |

---

## 5. 暂停项（明确）

| 项 | 状态 | 说明 |
|----|------|------|
| **OpenSpace** | **暂不安装** | 纸面评估见 [`docs/p3-openspace-paper-eval-report.md`](../../p3-openspace-paper-eval-report.md)；未授权前不装、不接 |
| **Pilot P2** | **hold** | 本地 API/插件桥接；须另开权限/日志/API 审计 |
| **Pilot P3** | **reject** | 自动执行 / 自动判责 / 自动入库 — 本路线图默认拒绝 |

变更任一项边界 → **必须**重新走 [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) / [`RISK_GATE.md`](RISK_GATE.md) + **新签核**；不得由日常任务「顺便」升级。

---

## 6. 推荐下一步

| 优先级 | 动作 |
|--------|------|
| **1（默认）** | **进入日常真实任务使用**（低风险文档优先；按 §2 路径） |
| 2 | 需要时用 Option B / sandbox P0/P1 减负复制粘贴 |
| 3 | INDEX 漏行时按 SAFE_INDEX_APPLY 人工补 |
| 停 | 不装 OpenSpace；不推 P2/P3；不扩自动化边界 |

---

## 7. 锚点与文档地图

| 锚点 / 文档 | 含义 |
|-------------|------|
| **`6bcdcd7`** | Pilot P1 收口语义锚点 |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) | 稳定半自动阶段 |
| [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | Option B 日常观察 |
| [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) | sandbox R1 |
| [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) | P0 |
| [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md) | P1 |
| **本文件** | **总入口 / 默认边界** |

sandbox 路径（可选，主仓外）：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`

---

## 8. 相关文件

- [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
- [`docs/p3-openspace-paper-eval-report.md`](../../p3-openspace-paper-eval-report.md)  
- 主仓脚本：`scripts/show-codex-cursor-loop-status.ps1` · `list-codex-cursor-queue.ps1` · `suggest-codex-cursor-index.ps1` · `watch-codex-cursor-handoff.ps1`  
