# 多仓 / 跨项目观察面板方案（Automation Step 5）

> **这是什么**：对一个或多个仓库 handoff 状态的**只读观察视图**（汇总 STATE / INDEX / QUEUE / RISK 提示）。  
> **这不是什么**：不是跨仓执行器；不改任何仓文件；不自动 commit/push；不替代单仓 QUEUE 判责流程。  
> Watcher 仍只监视**本仓**约定目录；本面板不扩展 Watcher 监视范围。

相关：[`STATE.md`](STATE.md) · [`QUEUE.md`](QUEUE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`INDEX.md`](INDEX.md) · `docs/codex-cursor-loop-phase-closeout.md`

---

## 1. 目标

在「主仓闭环已可用、其它仓可能陆续接入同一套 handoff 约定」时，提供一张**只读总表**，回答：

- 哪些仓有待判责 / blocked？  
- 各仓 tip / 分支是否可知？  
- 有无高风险提示需要人工先看？  

不回答、不触发：「去那个仓自动执行 / 自动判责 / 自动推送」。

---

## 2. 硬边界

| 规则 | 说明 |
|------|------|
| 只读 | 观察面板与未来 R1 脚本均不得修改被观察仓 |
| 默认单仓 | **仅**主仓在默认观察集内 |
| Allowlist | 其它仓必须**显式写入** §4 名单后才可观察 |
| 非锚点 | `C:\Users\Administrator\Documents\ChatGPT + Cursor 工作流` 等旁路**不得**作为 Git/观察锚点 |
| AICF | 业务/运营仓（含小红书发布、抓取、账号、F4、日更相关路径）**默认不纳入**；若纳入须另开任务，且范围仅限只读文档/handoff，禁止运营动作 |
| 无外服 | 不接入云看板、Webhook、第三方 SaaS（本方案阶段） |

---

## 3. 默认观察集

| repo_name | repo_path | 默认 |
|-----------|-----------|------|
| `gpt-codex-cursor-workflow`（三方闭环主仓） | `D:\AIContentFactory\三方闭环整合项目` | **是** |

主仓 handoff 根：`docs/handoffs/codex-cursor/`（含 STATE / INDEX / QUEUE / RISK_GATE）。

---

## 4. Allowlist（显式列入才观察）

模板（R0 人工维护；空 = 无额外仓）：

| repo_name | repo_path | handoff_root（相对仓） | notes | enabled |
|-----------|-----------|------------------------|-------|---------|
| （示例行，默认删除） | | `docs/handoffs/codex-cursor` | 须已采用同类约定 | no |

规则：

1. `enabled=yes` 且路径存在才进入面板  
2. 新增仓 = 另开低风险文档任务更新本表，并写明只读范围  
3. AICF 运营相关路径默认 `enabled=no`，即使有人误填  

---

## 5. 输出字段

建议 Markdown 表（未来可落 `CROSS_REPO_STATUS.md`，本轮**不强制**建数据文件）：

| 字段 | 含义 |
|------|------|
| `repo_name` | 短名 |
| `repo_path` | 绝对路径 |
| `branch` | 当前分支（只读 `git` 查询；R0 可手填） |
| `head` | 短 hash |
| `handoff_status_summary` | 一句话：如「3 pushed / 1 needs_codex_judgement / 0 blocked」 |
| `pending_judgement_count` | `needs_codex_judgement` + `cursor_done` 计数（依 INDEX/QUEUE） |
| `blocked_count` | `blocked` 计数（高风险待确认计入） |
| `last_result` | 最近 result 文件名或链接（相对该仓 handoff_root） |
| `risk_note` | 来自 RISK_GATE 提示或「无 / 见 blocked」 |

排序建议：`blocked_count` 降序 → `pending_judgement_count` 降序 → `repo_name`。

---

## 6. 数据来源（只读）

| 来源 | 用途 |
|------|------|
| 该仓 `INDEX.md` | status 汇总、last_result |
| 该仓 `QUEUE.md` 约定 / 可选 `QUEUE-active.md` | pending 列表 |
| 该仓 `STATE.md` | 枚举一致性（有则用；无则标记 `handoff_status_summary=unsupported`） |
| 该仓 `RISK_GATE.md` | 仅作规则参考；具体命中靠 INDEX `blocked` / 人工 note |
| `git status` / `rev-parse` | branch、head（只读） |

无 STATE/INDEX 的仓：可显示一行 `unsupported`，**不得**为了面板去改对方仓结构（接入另令）。

---

## 7. 更新方式

| 阶段 | 方式 | 说明 |
|------|------|------|
| **R0（当前）** | 人工 | 打开主仓 handoff，按需手填总表；其它仓仅当 allowlist 启用 |
| **R1（未来）** | 只读脚本 | 遍历 allowlist，读 INDEX + git 只读命令，打印/生成 Markdown；**另开任务** |
| Watcher | 不扩展 | 不因本面板监视多仓；跨仓通知另议且默认不做 |

禁止 R1 脚本：改文件、commit、push、执行 instruction、访问非 allowlist 路径、默认扫 AICF 运营目录。

---

## 8. R0 空表模板

```markdown
| repo_name | repo_path | branch | head | handoff_status_summary | pending_judgement_count | blocked_count | last_result | risk_note |
|-----------|-----------|--------|------|------------------------|-------------------------|---------------|-------------|-----------|
| gpt-codex-cursor-workflow | D:\AIContentFactory\三方闭环整合项目 | main | （手填） | （手填） | 0 | 0 | | 无 |
```

---

## 9. 风险闸门

1. 面板与脚本**只读**  
2. **不自动**执行 / commit / push  
3. Documents 旁路**永不**作锚点  
4. AICF 运营链路**默认排除**；纳入须另令且只读  
5. 高风险行只提示人工，不批准操作（见 [`RISK_GATE.md`](RISK_GATE.md)）  

---

## 10. 相关文件

- [`STATE.md`](STATE.md) · [`QUEUE.md`](QUEUE.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`INDEX.md`](INDEX.md)  
- [`README.md`](README.md)  
- `docs/codex-cursor-loop-phase-closeout.md`  
