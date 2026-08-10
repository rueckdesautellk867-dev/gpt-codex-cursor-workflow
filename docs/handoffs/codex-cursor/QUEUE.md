# 待判责 / Result 汇总队列（Automation Step 3）

> **这是什么**：从 handoff `*-result.md`、[`INDEX.md`](INDEX.md)、[`STATE.md`](STATE.md) 得到的**只读待办视图**，帮助 Codex/人工回答「下一步该判哪些」。  
> **这不是什么**：不是自动判责器；不执行 instruction；不改代码；不自动 commit/push；不驱动 Watcher。  
> 状态枚举以 [`STATE.md`](STATE.md) 为准；INDEX 的 `status` 约定见 INDEX §2.1。

---

## 1. 目标

在 result 与多轮任务变多时，提供一张**短列表**：

- 哪些轮次已 `cursor_done` / `needs_codex_judgement`，等待 `CODEX_JUDGEMENT`
- 哪些处于 `blocked`（含原 `need_confirm`），需人工先看
- 哪些 `needs_continue`，需 Codex 出下一 round instruction

`pushed` / 已收口任务**不进**本队列（可仍留在 INDEX 作历史）。

---

## 2. 输入

| 输入 | 用途 |
|------|------|
| [`INDEX.md`](INDEX.md) | 主信号：`status`、`task_id`、`round`、`result`、`commit`、`push`、`note` |
| [`STATE.md`](STATE.md) | 枚举与转移合法性（队列不发明新状态） |
| `*-result.md` | 校对 INDEX；取 `risk`、摘要、阻塞原因（若 INDEX 缺失） |
| （可选）`*-judgement.md` | 若已有判责文件，对应行应离开「待判」或标 `passed` / `needs_continue` / `blocked` |

不扫描业务仓、不监视 Documents 旁路、不读密钥文件。

---

## 3. 输出（建议 Markdown 表）

建议落盘名（未来 R1 脚本或人工维护时使用，**本轮不强制新建数据文件**）：

```text
docs/handoffs/codex-cursor/QUEUE-active.md   # 可选；或直接维护下方「样例空表」
```

### 3.1 字段

| 字段 | 含义 |
|------|------|
| `task_id` | 任务 id |
| `round` | 轮次 |
| `status` | STATE 枚举：优先 `blocked` / `needs_codex_judgement` / `cursor_done` / `needs_continue` |
| `result` | 相对本目录的 result 链接 |
| `age` | 自 result 落盘或 INDEX 上次更新起的大致时长（人工填 `今天` / `2d` 即可；脚本可用 mtime） |
| `risk` | 从 instruction/result 读取：`低` / `中` / `高`；未知填 `?` |
| `suggested_action` | 只读建议，如「Codex 判责」「人工确认高风险」「Codex 写 r02 instruction」 |

### 3.2 谁可以出现在队列

| `status` | 是否入队 | `suggested_action` 示例 |
|----------|----------|-------------------------|
| `blocked` | 是（最高优先） | 人工确认 / 补上下文 |
| `needs_codex_judgement` | 是 | Codex 输出 `CODEX_JUDGEMENT` |
| `cursor_done` | 是（视同待判） | 标为待判责或先改 INDEX 为 `needs_codex_judgement` |
| `needs_continue` | 是 | Codex 写下一 round instruction |
| `ready_for_cursor` | 否* | *可选「执行队列」另表；本 QUEUE 专注判责侧 |
| `draft` / `passed` / `committed` / `pushed` | 否 | 已过待判或尚未到 Cursor 完成 |

\* 若需「待 Cursor 执行」列表，另开 Step，不与本 QUEUE 混用。

---

## 4. 排序规则

从上到下：

1. `blocked`（含映射自 `need_confirm` 的行）  
2. `risk=高` 且仍待处理的行（同档内再按 status）  
3. `needs_codex_judgement`  
4. `cursor_done`  
5. `needs_continue`  
6. 同档内：`age` 更久者优先（先判积压）

`pushed`、已 `passed` 且无后续动作的行：**不进入**待办表。

---

## 5. 更新方式

| 阶段 | 方式 | 说明 |
|------|------|------|
| **R0（当前）** | 人工 | 看 INDEX + 打开 result，按 §3 手填/改队列表；可与 INDEX 同步改 `status` |
| **R1（未来）** | 只读脚本 | 扫描 INDEX（及可选 result 头字段）**生成** Markdown 表；**另开任务**；默认只写 stdout 或 gitignore 产物 |
| Watcher | 不参与 | 仍只通知文件落盘；不写 QUEUE、不改 INDEX |

禁止：

- 脚本自动写 `CODEX_JUDGEMENT`  
- 脚本自动 commit / push  
- 脚本自动执行 instruction  
- 在未授权下改协议 / watcher  

---

## 6. 与 CURSOR_RESULT / 判责的关系

```text
Cursor 写 result → status≈cursor_done / needs_codex_judgement → 进入 QUEUE
        ↓
Codex 读 QUEUE（或 INDEX）→ 写 JUDGEMENT
        ↓
status → passed | needs_continue | blocked → 行离开「待判」或改 suggested_action
        ↓
人工授权后才 committed / pushed（永不由 QUEUE 触发）
```

---

## 7. R0 空表模板（复制用）

```markdown
| task_id | round | status | result | age | risk | suggested_action |
|---------|-------|--------|--------|-----|------|------------------|
| | | | | | | |
```

当前无强制活跃待判行时，表可留空，并在 note 写「无积压」。

---

## 8. 风险闸门

1. QUEUE 只读视图；**不自动执行**  
2. **不自动** commit / push  
3. `risk=高` 必须先人工，不得建议「直接执行」  
4. 不碰 AICF 运营链路；不扫 Documents 旁路  
5. R1 脚本若出现，默认无网络、不引入新依赖（具体另令）  

---

## 9. 相关文件

- [`STATE.md`](STATE.md) — 状态机  
- [`INDEX.md`](INDEX.md) — 任务索引  
- [`README.md`](README.md) — 目录约定  
- `docs/codex-cursor-loop.md` — 协议模板  
