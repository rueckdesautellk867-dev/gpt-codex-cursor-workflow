# 一键本地观察命令方案（Automation Step 18 / Option B）

> **这是什么**：人工运行一次的**本地只读汇总**，把 repo / watcher / queue / INDEX 建议 / 风险提示收成一份视图，便于判断下一步交给 Cursor、Codex 还是人工。  
> **这不是什么**：不是后台 daemon；不自动执行 instruction；不自动判责；不自动写 INDEX；不自动 commit/push。  
> **R1 已实现**：[`scripts/show-codex-cursor-loop-status.ps1`](../../../scripts/show-codex-cursor-loop-status.ps1)（人工运行；只读 stdout）。
> 相关：[`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) · [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)

---

## 1. 目标

一次命令回答：

1. 仓库是否干净、是否 ahead？  
2. Watcher 是否有 lock·state（存在性 / mtime）？
3. 有哪些待判责 result？  
4. INDEX 是否可能漏行？  
5. 有无 `need_confirm` / `blocked` 需先人工看？

---

## 2. 建议汇总模块

| 模块 | 内容 | 数据来源（只读） |
|------|------|------------------|
| **repo** | `branch`、`HEAD`、`origin/main`、ahead/behind、dirty 数量 | `git` 只读查询 |
| **watcher** | `.watcher.lock` / `.watcher-state.json` 是否存在 + mtime；**不读内容、不改** | handoff 目录运行时文件 |
| **queue** | total / need_confirm / blocked / pass_review + 最近条目 | 子进程调用 [`list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1) `-Json` |
| **index suggestions** | suggestion_count / warning_count + 最近建议 | 子进程调用 [`suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1) `-Json` |
| **next hints** | 提示字符串（非可执行 API） | 由上述计数生成 |

「最近通知摘要」：若无可靠日志文件则标 `n/a`；**禁止**为观察而清空或改写 watcher state。

---

## 3. R0 / R1 / R2

| 阶段 | 方式 |
|------|------|
| **R0** | 人工分别运行现有脚本 + `git status`（见 §6） |
| **R1（已实现）** | [`scripts/show-codex-cursor-loop-status.ps1`](../../../scripts/show-codex-cursor-loop-status.ps1)：人工运行一次出总览 |
| **R2（未来）** | Watcher 通知文案中**提示**该命令（见 WATCHER_QUEUE_INDEX_LINK）；**不**自动运行 |

---

## 4. 日常入口（R1 脚本）

脚本路径（相对主仓根）：

```text
scripts/show-codex-cursor-loop-status.ps1
```

### 4.1 命令

在主仓根目录执行：

```powershell
# 默认：Markdown 总览 → stdout
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1

# JSON（可被 ConvertFrom-Json 解析）
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1 -Json

# 自定义仓库根
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\show-codex-cursor-loop-status.ps1 -RepoRoot "D:\path\to\repo"
```

| 参数 | 含义 |
|------|------|
| （默认） | Markdown 总览 → stdout |
| `-Json` | 结构化 JSON |
| `-RepoRoot <path>` | 覆盖仓库根（默认：脚本上级目录） |

`-ExecutionPolicy Bypass` 为**进程级**参数，仅影响本次调用，**不修改**系统/用户 ExecutionPolicy。

### 4.2 日常使用建议

| 时机 | 建议 |
|------|------|
| 开始闭环任务前 | 先运行一次，看 dirty / queue / need_confirm |
| result 回传后 | 再运行一次，确认 queue 与 INDEX suggestions |
| 输出含 `need_confirm` | **先看** [`RISK_GATE.md`](RISK_GATE.md)，再判责或写 INDEX |
| 输出含 INDEX suggestions | 按 [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) 决定是否写入（不自动写） |

日常主通道仍是：Codex instruction → Cursor result →（可选 Watcher）→ 判责 → 人工授权 commit/push。本脚本只做观察。

---

## 5. 输出格式（R1）

### Markdown（默认）

```markdown
# Codex-Cursor Loop Status
## Repo
...
## Watcher
...
## Queue
...
## Index Suggestions
...
## Next Hints
...
```

### JSON（`-Json`）

对象字段包括：`repo`、`watcher`、`queue`、`index_suggestions`、`next_hints`（及只读标记字段）。

`next_hints` 仅为**提示字符串**，不是可执行 API。

---

## 6. R0 操作清单（仍可用）

在主仓根目录分别跑（不必用 R1 时）：

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

1. **只读**：默认仅 stdout；**不写任何文件**
2. **不写** [`INDEX.md`](INDEX.md)
3. **不改** watcher `.watcher.lock` / `.watcher-state.json`
4. **不**自动判责 / 执行 instruction
5. **不**自动 commit / push
6. **不**扫描 Documents 旁路或其它仓（跨仓见 CROSS_REPO_OBSERVER，不捆绑）
7. **不**接网络 / Codex·Cursor API
8. INDEX 若需更新 → [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)；高风险 → [`RISK_GATE.md`](RISK_GATE.md)

---

## 8. 与联动方案的关系

| 文档 | 关系 |
|------|------|
| WATCHER_QUEUE_INDEX_LINK | 通知后可提示「运行本一键观察」；R2 对齐 |
| list / suggest 脚本 | R1 观察命令的组成模块，保持只读 |
| SAFE_INDEX_APPLY | 观察输出中的 index 建议不自动写入 |
| STABLE_SEMI_AUTO_CLOSEOUT | Option B 为稳定半自动之上的观察增强，不扩大执行边界 |

---

## 9. 相关文件

- [`scripts/show-codex-cursor-loop-status.ps1`](../../../scripts/show-codex-cursor-loop-status.ps1) — **R1 日常入口**
- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1)
- [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md)
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) · [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)
