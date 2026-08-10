# INDEX 更新助手方案（Automation Step 13）

> **这是什么**：只读扫描 handoff 的 `*-instruction.md` / `*-result.md`，对照 [`STATE.md`](STATE.md) 与现有 [`INDEX.md`](INDEX.md)，**生成建议的 INDEX 行、diff 预览与 warnings**，供人工粘贴/核对。  
> **这不是什么**：不是自动状态机；不自动改 `INDEX.md`；不自动判责；不自动 commit/push。  
> 解析可复用 [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) / `scripts/list-codex-cursor-queue.ps1` 的思路。
> R1 脚本已实现：[`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)（只读；见 §4.1）。

---

## 1. 目标

减少人工维护 INDEX 时的遗漏（漏记 result、状态过时、非法 status），同时保持「人确认后才改 INDEX」的边界。

---

## 2. 输入 / 输出

### 2.1 建议输入

| 输入 | 用途 |
|------|------|
| handoff 目录 | 默认 `docs/handoffs/codex-cursor/` |
| [`STATE.md`](STATE.md) | 合法 `status` 枚举 |
| [`INDEX.md`](INDEX.md) | 当前表，用于 diff / 查重 |
| （可选）`*-judgement.md` | 辅助判断是否已判责 |

忽略：与只读队列脚本相同的方案文 / `_template-*` / README 等（非任务轮次文件）。

### 2.2 建议输出（stdout）

| 输出 | 说明 |
|------|------|
| Markdown 表格行 | 可直接粘贴进 INDEX 的建议行（字段对齐 INDEX：`task_id, round, status, result, commit, push, note`） |
| diff preview | 相对当前 INDEX：`add` / `update_status` / `unchanged` 列表 |
| warnings | 缺字段、非法 status、重复 `task_id+round`、result 无对应 instruction、INDEX 有行但文件缺失等 |

默认**不写文件**；若未来写预览文件，须 gitignore，且**另开任务**明确路径。

---

## 3. 建议状态推断（只读启发式）

助手只**建议** status，不落盘：

| 观察 | 建议 status（示例） |
|------|---------------------|
| 仅有 instruction，无 result | `ready_for_cursor` 或 `draft`（缺字段则 draft） |
| 有 result，无 judgement，CURSOR_RESULT=`done` | `needs_codex_judgement` 或 `cursor_done` |
| result=`blocked` / `need_confirm` | `blocked` |
| 人工已知 commit/push（来自 INDEX 或 git 只读查询，可选） | 保持/建议 `committed` / `pushed`；**不得**在无证据时瞎填 hash |

非法枚举：只进 `warnings`，**不自动改成**某个合法值。

`commit` / `push` 列：无证据时建议 `-` / `no`；已在 INDEX 的保留，助手不猜测远端。

---

## 4. R0 / R1 / 写入门槛

| 阶段 | 方式 |
|------|------|
| **R0** | 人工根据 result 手动补 INDEX（现流程） |
| **R1（已实现）** | [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)：只读打印建议行 + warnings；**不写** INDEX |
| **写入 INDEX** | 必须另开任务或用户明确授权「把建议合并进 INDEX」；助手本身永不静默改表。**写入 [`INDEX.md`](INDEX.md) 前须按 [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) 人工确认**（建议 → 挑选 → 写入前/后检查）；不得跳过该流程 |

与队列脚本关系：可先 `list-codex-cursor-queue.ps1` 看待判，再用本助手检查 INDEX 是否漏行——二者都只读。

### 4.1 R1 脚本入口与用法

脚本路径（相对主仓根）：

```text
scripts/suggest-codex-cursor-index.ps1
```

在主仓根目录执行：

```powershell
# 默认：Markdown 建议表 + warnings → stdout
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1

# JSON（含 suggestions / warnings）
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1 -Json

# 自定义 handoff 目录
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1 -HandoffDir "D:\path\to\handoffs"
```

说明：

- **只读**：不修改 `INDEX.md`，不修改任何 handoff 文件，不写运行时文件
- **不自动应用建议**：输出仅供人工核对后另授写入
- `-ExecutionPolicy Bypass` 为**进程级**参数，仅影响本次调用，**不修改**系统/用户 ExecutionPolicy

---

## 5. 与 STATE / READONLY_QUEUE_SCRIPT / SAFE_INDEX_APPLY 的关系

| 文档 | 关系 |
|------|------|
| STATE | `status` **只能**使用状态机枚举；非法只警告 |
| INDEX | 助手服务其维护；不取代人工 ownership |
| [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) | **写入 INDEX 的安全流程入口**：只读建议之后，须按该文档人工确认再改 [`INDEX.md`](INDEX.md)；本助手 / suggest 脚本均不自动写入 |
| READONLY_QUEUE_SCRIPT | 复用文件名/正文字段解析；队列偏「待判责」，助手偏「INDEX 是否同步」 |
| QUEUE / 判责半自动 | 不替代判责；不因建议行自动 pass |

---

## 6. 边界（硬）

1. 不修改任何文件（含 INDEX）  
2. 不扫描其它仓；不读 Documents 旁路  
3. 不接 API / 网络  
4. 不改 watcher；不自动 commit/push  
5. 不把「建议 status」当成已发生的 STATE 转移  

---

## 7. 脚本行为摘要（已实现）

| 项 | 约定 |
|----|------|
| 路径 | `scripts/suggest-codex-cursor-index.ps1` |
| 输出 | Markdown 建议表 + `## warnings`；或 `-Json` |
| 建议 status | 有 result 时保守为 `needs_codex_judgement`（INDEX 已更靠前则不回退） |
| 退出码 | 扫描成功为 0；有 warnings 仍可为 0 |

---

## 8. 风险闸门

1. 只读建议 ≠ 自动改 INDEX / 自动状态机  
2. 高风险任务仍走 [`RISK_GATE.md`](RISK_GATE.md)；助手不放行  
3. AICF 运营链路不因 INDEX 建议而执行  

---

## 9. 相关文件

- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1) — R1 INDEX 建议脚本
- [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) — 写入 [`INDEX.md`](INDEX.md) 前须按此流程人工确认（建议 → 挑选 → 检查 → 写入）
- [`INDEX.md`](INDEX.md) · [`STATE.md`](STATE.md)  
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`QUEUE.md`](QUEUE.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md)  
