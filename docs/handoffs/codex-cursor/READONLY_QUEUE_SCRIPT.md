# 只读待判责队列脚本方案（Automation Step 9）

> **这是什么**：未来用**只读脚本**扫描本仓 handoff，汇总「待 Codex 判责」的 `*-result.md` 列表（Markdown 表或 JSON）。  
> **这不是什么**：不是自动判责器；不改 result/INDEX/STATE；不 commit/push；不调 Codex/Cursor API。  
> 队列语义对齐 [`QUEUE.md`](QUEUE.md)；状态对齐 [`STATE.md`](STATE.md)；风险仅提示见 [`RISK_GATE.md`](RISK_GATE.md)；判责流程见 [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)。  
> R1 脚本已实现：[`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)（只读；见 §5.1）。

---

## 1. 脚本是什么 / 不是什么

| 是 | 不是 |
|----|------|
| 只读扫描默认目录下的 `*-result.md`（及可选读 INDEX） | 自动写 `CODEX_JUDGEMENT` |
| 打印待判列表供人/Codex 挑选 | 修改任何 handoff / 业务文件 |
| 可附带 `risk_hint` 字符串 | 自动拦截或放行执行 |
| 退出码表示扫描成败（可选） | 调用 Codex API / Cursor API / 联网 |

---

## 2. 输入范围

| 项 | 约定 |
|----|------|
| 默认根目录 | `docs/handoffs/codex-cursor/`（相对主仓 `D:\AIContentFactory\三方闭环整合项目`） |
| 包含 | 匹配 `*-result.md` 的文件 |
| 忽略（不作为 result 候选） | `_template-*`、`README.md`、`INDEX.md`、`STATE.md`、`QUEUE.md`、`RISK_GATE.md`、`CROSS_REPO_OBSERVER.md`、`CURSOR_RECEIVE.md`、`CODEX_JUDGEMENT_SEMI_AUTO.md`、`PROCESS_BRIDGE_EVAL.md`、`READONLY_QUEUE_SCRIPT.md`、`AUTOMATION_STEPS_CLOSEOUT.md`、其它非 `*-result.md` 方案/索引文 |
| 不扫描 | 其它仓、Documents 旁路、AICF 运营路径（跨仓见 Step 5，本脚本默认单仓） |

可选：只读解析同目录 `INDEX.md` 的 `status` 列，用于过滤 `pushed` / 标记 `needs_codex_judgement`（**不得写回** INDEX）。

---

## 3. 输出字段

| 字段 | 含义 |
|------|------|
| `task_id` | 自文件名解析，或 result 正文 |
| `round` | 如 `01` |
| `result_path` | 相对 handoff 根或绝对路径 |
| `status` | 优先 INDEX；否则自 `CURSOR_RESULT.status` 映射（见 STATE）；未知 `?` |
| `mode_done` | 自 result 读取（若有） |
| `risk_hint` | 启发式提示字符串（如 `低` / `高?关键词:迁移`）；**不**做自动拦截 |
| `mtime` | 文件修改时间（排序用） |
| `suggested_judgement` | 只读建议：如 `review_for_pass` / `check_risk_gate` / `ask_human`；**不**等于已判责 |

默认输出：stdout 上的 Markdown 表格；可选 `--json`（未来实现时）。

---

## 4. 谁进入列表 / 排序

### 4.1 入选（建议）

- INDEX `status` ∈ `needs_codex_judgement`、`cursor_done`、`blocked`（待确认类）  
- 或：无 INDEX 行但存在较新的 `*-result.md`，且未找到对应 `*-judgement.md`  
- **排除**：`status=pushed` / `committed`（除非 `--include-done` 调试开关，默认关）

### 4.2 排序

1. `risk_hint` 含高风险 / `status=blocked` 优先  
2. 同档内 **mtime 新者优先**（先处理最新 result）  
3. 再按 `task_id`  

与 [`QUEUE.md`](QUEUE.md) §4 一致处：blocked / 高风险置顶；本脚本对「新 result」额外加权。

---

## 5. R0 / R1

| 阶段 | 方式 |
|------|------|
| **R0** | 人工查看 [`QUEUE.md`](QUEUE.md) + INDEX + 打开 result；不跑脚本 |
| **R1（已实现）** | [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)：只读扫描、打印表/JSON；**不写** handoff / INDEX / STATE；不自动判责 |

Watcher：**不**调用本脚本；不因通知自动判责。

### 5.1 R1 脚本入口与用法

脚本路径（相对主仓根）：

```text
scripts/list-codex-cursor-queue.ps1
```

在主仓根目录执行：

```powershell
# 默认：Markdown 表格 → stdout
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\list-codex-cursor-queue.ps1

# JSON
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\list-codex-cursor-queue.ps1 -Json

# 自定义 handoff 目录
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\list-codex-cursor-queue.ps1 -HandoffDir "D:\path\to\handoffs"
```

说明：

- **只读**：不修改 handoff、INDEX、STATE，不写运行时文件
- **不自动判责**：输出供 Codex/人工挑选；见 [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)
- `-ExecutionPolicy Bypass` 为**进程级**参数，仅影响本次 `powershell` 调用，**不修改**系统/用户 ExecutionPolicy

---

## 6. 与 RISK_GATE / 判责半自动的关系

| 文档 | 关系 |
|------|------|
| RISK_GATE | 脚本最多填充 `risk_hint`；**不**自动改状态为 blocked、**不**阻止用户打开文件 |
| CODEX_JUDGEMENT_SEMI_AUTO | 列表供人工点选后交给 Codex；**不替代**判责检查清单与 `CODEX_JUDGEMENT` |
| STATE / QUEUE | 字段与入选规则与之对齐；冲突时以 STATE 枚举为准 |

---

## 7. 实现约束（R1 脚本须遵守）

1. 只读打开文件；无 `Set-Content` 写 handoff  
2. 无网络、无新依赖（PowerShell 内置即可）  
3. 单实例非必须；不抢 Watcher lock  
4. 失败时非零退出并打日志，不得半写 INDEX  
5. 不调用 Codex API / Cursor API；不改 watcher 行为

---

## 8. 风险闸门

1. 只读汇总 ≠ 自动判责 / 自动执行  
2. 不自动 commit/push  
3. 不扫 Documents 旁路与其它仓（除非另令改范围）  
4. `risk_hint` 不得解释为已批准  

---

## 9. 相关文件

- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1) — R1 只读队列脚本
- [`QUEUE.md`](QUEUE.md) · [`STATE.md`](STATE.md) · [`INDEX.md`](INDEX.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)  
- [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md)  
