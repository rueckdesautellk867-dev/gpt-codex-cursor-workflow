# 一键本地观察命令方案（Automation Step 18）

> **这是什么**：人工运行一次的**本地只读汇总**，把 repo / watcher / queue / INDEX 建议 / 风险提示收成一份视图，便于判断下一步交给 Cursor、Codex 还是人工。  
> **这不是什么**：不是后台 daemon；不自动执行 instruction；不自动判责；不自动写 INDEX；不自动 commit/push。  
> **本轮只定方案，不写聚合脚本。**  
> 相关：[`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) · [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md)

---

## 1. 目标

一次命令回答：

1. 仓库是否干净、是否 ahead？  
2. Watcher 是否在跑 / 是否有 lock·state？  
3. 有哪些待判责 result？  
4. INDEX 是否可能漏行？  
5. 有无 high / blocked / need_confirm 需先人工看？  

---

## 2. 建议汇总模块

| 模块 | 内容 | 数据来源（只读） |
|------|------|------------------|
| **repo** | `branch`、`HEAD`、`origin/main`、ahead/behind、dirty 文件列表 | `git status` / `rev-parse` / `rev-list` |
| **watcher** | 是否存在 `.watcher.lock` / `.watcher-state.json`；lock 内 pid 是否存活；**不**改 state/lock | handoff 目录运行时文件 |
| **queue** | 待判责表 | 复用 [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1) 输出（子进程只读或内联同等逻辑） |
| **index suggestions** | INDEX 建议行 + warnings | 复用 [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1) |
| **risk summary** | 计数：`need_confirm` / `blocked` / `risk_hint=high` | 来自 queue（及可选 INDEX `blocked` 行） |

「最近通知摘要」：若无可靠日志文件则标 `n/a`；**禁止**为观察而清空或改写 watcher state。

---

## 3. R0 / R1 / R2

| 阶段 | 方式 |
|------|------|
| **R0（当前）** | 人工分别运行现有脚本 + `git status`（见 §6） |
| **R1（未来）** | 新增只读聚合脚本，**人工运行**一次出总览；**另开 implement 任务** |
| **R2（未来）** | Watcher 通知文案中**提示**该命令（见 WATCHER_QUEUE_INDEX_LINK）；**不**自动运行 |

---

## 4. 推荐未来脚本名与用法

```text
scripts/show-codex-cursor-loop-status.ps1
```

建议参数：

| 参数 | 含义 |
|------|------|
| （默认） | Markdown 总览 → stdout |
| `-Json` | 结构化 JSON |
| `-HandoffDir <path>` | 覆盖 handoff 目录（默认本仓 `docs/handoffs/codex-cursor`） |
| `-SkipGit` / `-SkipQueue` / `-SkipIndex` | 可选跳过模块（调试用） |

示例（未来）：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1 -Json
```

进程级 Bypass，不改系统 ExecutionPolicy。

---

## 5. 输出格式（建议）

### Markdown（默认）

```markdown
# Codex↔Cursor loop status
## repo
...
## watcher
...
## risk summary
- need_confirm: N
- blocked: N
- high: N
## queue
（嵌入 list-codex-cursor-queue 表）
## index suggestions
（嵌入 suggest-codex-cursor-index 表 + warnings）
## next actions (hints only)
- ...
```

### JSON（可选）

对象字段：`repo`、`watcher`、`risk_summary`、`queue`、`index_suggestions`、`warnings`。

`next actions` 仅为**提示字符串**（如「把某 result 交给 Codex」「按 SAFE_INDEX_APPLY 考虑补 INDEX」），不是可执行 API。

---

## 6. R0 操作清单（现在就能做）

在主仓根目录：

```powershell
git status --branch --short
git rev-parse --short HEAD
git rev-parse --short origin/main

powershell -NoProfile -ExecutionPolicy Bypass -File scripts\list-codex-cursor-queue.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1
```

可选：查看 handoff 下是否存在 `.watcher.lock` / `.watcher-state.json`（只看，不删）。

---

## 7. 安全边界（硬）

1. **不写文件**（含 INDEX、handoff、gitignore 外产物；R1 默认仅 stdout）  
2. **不改** watcher state/lock  
3. **不**自动判责 / 执行 instruction  
4. **不** commit/push  
5. **不**扫描 Documents 旁路或其它仓（跨仓见 CROSS_REPO_OBSERVER，不捆绑）  
6. **不**接网络 / Codex·Cursor API  
7. INDEX 若需更新 → [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)；高风险 → [`RISK_GATE.md`](RISK_GATE.md)  

---

## 8. 与联动方案的关系

| 文档 | 关系 |
|------|------|
| WATCHER_QUEUE_INDEX_LINK | 通知后可提示「运行本一键观察」或分别跑 queue/index；R2 对齐 |
| list / suggest 脚本 | 本观察命令的组成模块，保持只读 |
| SAFE_INDEX_APPLY | 观察输出中的 index 建议不自动写入 |

---

## 9. 相关文件

- [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1)  
- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md)  
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
