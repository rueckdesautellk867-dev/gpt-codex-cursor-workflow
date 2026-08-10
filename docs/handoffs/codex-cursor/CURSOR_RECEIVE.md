# Cursor 接收侧半自动化方案（Automation Step 6）

> **这是什么**：人在环内，把「发现 instruction → 打开 Cursor → 执行 → 写回 result」流程写清楚，并可叠加 Watcher **通知**。  
> **这不是什么**：不是 Cursor 无人值守自动执行；不是 Codex 进程级控制 Cursor；不是 API 桥接。  
> 状态 / 风险 / 队列见 [`STATE.md`](STATE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`QUEUE.md`](QUEUE.md)；目录约定见 [`README.md`](README.md)。

---

## 1. 目标流程（半自动）

```text
Codex/人工 写入 *-instruction.md（status → ready_for_cursor）
        ↓
（可选）Watcher 控制台 / -Toast 通知「有新 instruction」
        ↓
人工打开文件，或把内容贴进 Cursor 对话
        ↓
Cursor 按模板检查字段 → 执行（仅低风险且字段齐全时）
        ↓
写入 instruction 指定的 result_path（同轮 *-result.md）
        ↓
status → cursor_done / needs_codex_judgement（INDEX 可手改）
```

「半自动」= **通知 + 模板化执行习惯**；决策与粘贴仍由人完成。

---

## 2. 明确不是什么

| 不是 | 说明 |
|------|------|
| 自动执行 | Cursor Agent 不得在无用户打开对话的情况下自行开跑 instruction |
| Codex 直控 Cursor | 无进程级互发；文件/粘贴接力不变 |
| 自动改仓入库 | commit/push 仍须用户明确授权 |
| 自动解除风险 | 高风险必须 `blocked` / `need_confirm`，见 RISK_GATE |

---

## 3. R0 / R1

| 阶段 | 方式 | 说明 |
|------|------|------|
| **R0（当前）** | 人工 | Watcher 可选；人打开 `*-instruction.md` 或复制进 Cursor；执行后写 `result_path` |
| **R1（未来）** | 本地只读提示器 | 列出 `ready_for_cursor` 的 instruction 路径（stdout / Markdown）；**不**自动发送给 Cursor、**不**自动执行；**另开任务** |
| Watcher | 保持 | 只通知落盘；不打开 Cursor、不改状态 |

禁止 R1：调用未授权 Cursor API、自动 `--force` 执行、自动 commit/push。

---

## 4. 执行前必查字段

Cursor 在动手改文件前，必须确认 instruction 含：

| 字段 | 要求 |
|------|------|
| `task_id` | 非空，与文件名一致为佳 |
| `round` | 如 `01` |
| `risk` | `低` / `中` / `高`；缺省按更高风险处理 |
| `target_repo` | 路径存在且为本任务允许仓 |
| `result_path` | 明确回传路径（建议本目录 `…-rNN-result.md`） |
| `不做什么` | 非空列表 |
| `验收标准` | 至少一条可勾选标准 |

建议同时扫一眼：`mode`、影响范围、建议验证命令。

---

## 5. 高风险或缺字段时

| 情况 | Cursor 行为 |
|------|-------------|
| `risk: 高` 或命中 [`RISK_GATE.md`](RISK_GATE.md) | **不执行**；`CURSOR_RESULT.status=need_confirm` 或 `blocked`；说明需人工 |
| 缺 §4 任一必查字段 | **不执行**；`blocked`；列出缺项 |
| `target_repo` 越界 / Documents 旁路当锚点 | **不执行**；`blocked` |
| AICF 运营类意图且无完整授权 | **不执行**；`blocked`（见 RISK_GATE §3.2） |

解除后须新的或补全后的 instruction / 人工确认，状态机见 STATE。

---

## 6. Result 写回

1. 路径以 instruction 的 `result_path` 为准；未写则默认：同目录 `<task_id>-r<round>-result.md`  
2. 正文含完整 `## CURSOR_RESULT`（status / 变更总结 / 文件 / 验证 / 风险 / 建议下一动作）  
3. 对话中可贴同等内容，便于 Codex 粘贴接力  
4. 写回后：INDEX 可将该行标为 `cursor_done` 或 `needs_codex_judgement`（人工；不自动）  
5. 任务进入 QUEUE 待判责侧（见 QUEUE），**不是**自动判责  

---

## 7. 与 STATE / RISK_GATE / QUEUE 的关系

| 文档 | 关系 |
|------|------|
| STATE | 接收成功执行前：`ready_for_cursor`；写完 result：`cursor_done` → `needs_codex_judgement`；失败/风险：`blocked` |
| RISK_GATE | 执行前启发式；命中则不得进入「已执行」 |
| QUEUE | result 就绪后供 Codex/人工判责；Cursor 接收侧不维护判责队列 |

---

## 8. R0 操作清单（给人看）

1. （可选）`powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1`  
2. 打开最新 `*-instruction.md`  
3. 核对 §4 字段 + RISK_GATE  
4. 在 Cursor 粘贴或 `@` 引用该文件并执行  
5. 写 `result_path`  
6. 等 Codex 判责；勿自行 commit/push  

---

## 9. 风险闸门

1. 半自动 ≠ 自动执行  
2. 不接 Cursor API（本方案阶段）  
3. 不自动 commit/push  
4. 高风险默认 blocked  
5. 不扩展监视 Documents 旁路  

---

## 10. 相关文件

- [`README.md`](README.md) · [`STATE.md`](STATE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`QUEUE.md`](QUEUE.md)  
- [`_template-instruction.md`](_template-instruction.md) · [`_template-result.md`](_template-result.md)  
- `scripts/watch-codex-cursor-handoff.ps1`（仅通知）  
- `docs/codex-cursor-loop.md`  
