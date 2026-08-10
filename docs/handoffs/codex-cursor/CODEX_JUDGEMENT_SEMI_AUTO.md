# Codex 判责侧半自动化方案（Automation Step 7）

> **这是什么**：人在环内，把「发现待判 result → 打开/粘贴给 Codex → 按清单输出 `CODEX_JUDGEMENT`」写清楚；可叠加 QUEUE **只读提示**。  
> **这不是什么**：不是 Codex 自动监听 result；不是无人值守自动判责；不是自动 commit/push；不是进程级 API 桥接。  
> 相关：[`QUEUE.md`](QUEUE.md) · [`STATE.md`](STATE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md)

---

## 1. 目标流程（半自动）

```text
Cursor 写回 *-result.md（status → cursor_done / needs_codex_judgement）
        ↓
（可选）QUEUE / 人工发现「待判」项
        ↓
人工把 CURSOR_RESULT 贴给 Codex，或指定 result 路径让 Codex 只读
        ↓
Codex 按 §4 检查清单输出 CODEX_JUDGEMENT
        ↓
status → passed | needs_continue | blocked（见 STATE）
        ↓
入库 / push 仍须用户明确授权（永不由判责自动触发）
```

「半自动」= **队列提示 + 固定判责清单/模板**；选哪一条、何时开判仍由人决定。

---

## 2. 明确不是什么

| 不是 | 说明 |
|------|------|
| 自动监听 | Codex 不常驻监视 handoff 目录 |
| 自动判责 | 无人工触发不得批量写 judgement |
| 自动入库 | `pass` ≠ 已 commit/push |
| 替代 RISK_GATE | 高风险仍须人工；判责不得「默许放行」 |
| 直控 Cursor | 不因 judgement 自动开跑下一轮执行（continue 只出下一 instruction 草稿意图） |

---

## 3. R0 / R1

| 阶段 | 方式 | 说明 |
|------|------|------|
| **R0（当前）** | 人工 | 粘贴 `CURSOR_RESULT` 到 Codex，或 `@`/打开指定 `*-result.md` 后要求输出 judgement |
| **R1（未来）** | 只读提示器 | 列出 `needs_codex_judgement` / `cursor_done`（来自 INDEX/QUEUE）；**人工点选一条**再交给 Codex；**不**自动调 Codex API；**另开任务** |
| Watcher | 可选通知 | result 落盘可通知「待判」；不写 judgement |

禁止 R1：无人值守循环判责、自动 `pass` 后 commit、自动 push。

---

## 4. 判责检查清单

Codex 输出 judgement 前应逐项核对：

| # | 检查项 | 不合格时倾向 |
|---|--------|----------------|
| 1 | `task_id` / `round` 与 instruction、result 文件名一致 | `blocked` / `stop` 或要求重交 result |
| 2 | `CURSOR_RESULT` 结构完整（总结/文件/验证/风险/建议） | `continue`（补 result）或 `blocked` |
| 3 | 实际改动未越出「影响范围 / 不做什么」 | `blocked` / `stop`；要求收窄或重做 |
| 4 | 验证命令与结果是否支撑验收标准 | 不足则 `continue` 或 `blocked` |
| 5 | 是否触发 [`RISK_GATE.md`](RISK_GATE.md)（含 AICF 运营意图） | 未人工确认 → `blocked` / `stop` |
| 6 | decision 选择：`pass` / `continue` / `blocked` / `stop` | 见 §5 |
| 7 | 若涉及入库：明确 **commit/push 仍需人工授权**，不得写「已自动推送」 |

可选：对照 instruction 验收标准打勾；对照 INDEX `status` 是否仍为待判。

---

## 5. 输出模板：`CODEX_JUDGEMENT`

```markdown
## CODEX_JUDGEMENT

- task_id:
- on_round:
- decision: pass | continue | blocked | stop
- rationale: （一句话）
- next: （continue → 下一 instruction 焦点；pass → 收口/待人工入库；blocked/stop → 等人或终止）
- commit_push: manual_only
```

| decision | 含义 | 建议 STATE |
|----------|------|------------|
| `pass` | 本轮验收通过 | `passed`（≠ committed/pushed） |
| `continue` | 需下一局部步骤 | `needs_continue` → 新 round instruction |
| `blocked` | 缺确认/越界/验证不足等，可恢复 | `blocked` |
| `stop` | 停止本任务线（合规/高风险未授权等） | `blocked` 或任务关闭（INDEX note 标明） |

协议里历史用过 `reassign`：可映射为 `blocked`/`continue` 并在 `next` 写明改派 Codex 整仓或人工；本方案主枚举以上表为准。

可选落盘：`<task_id>-r<round>-judgement.md`（与 README 命名一致）。

---

## 6. 与 QUEUE / STATE / RISK_GATE 的关系

| 文档 | 关系 |
|------|------|
| QUEUE | 提供「该判哪些」只读列表；判责后更新 INDEX，行离开待判或改 `suggested_action` |
| STATE | judgement 决定状态转移；`passed` 后仅人工 → `committed` → `pushed` |
| RISK_GATE | 判责中复检；不得用 pass 绕过人工高风险确认 |
| CURSOR_RECEIVE | 上游保证 result 来自半自动接收；判责侧不负责执行 |

---

## 7. R0 操作清单（给人 / Codex 看）

1. 打开 QUEUE 或 INDEX，找 `needs_codex_judgement` / 最新 result  
2. 将 result 贴给 Codex，或给出绝对路径  
3. 要求按 §4 清单输出 §5 模板  
4. 按 decision 更新 INDEX `status`（人工）  
5. 仅当用户说「同意 commit / 同意 push」时才入库  

---

## 8. 风险闸门

1. 半自动 ≠ 自动判责  
2. 不接 Codex API（本方案阶段）  
3. 不自动 commit/push  
4. 高风险默认 blocked/stop  
5. 不因跨仓观察面板（Step 5）自动开判其它仓  

---

## 9. 相关文件

- [`QUEUE.md`](QUEUE.md) · [`STATE.md`](STATE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md)  
- [`INDEX.md`](INDEX.md) · [`README.md`](README.md)  
- `docs/codex-cursor-loop.md`（协议中的 JUDGEMENT 块）  
