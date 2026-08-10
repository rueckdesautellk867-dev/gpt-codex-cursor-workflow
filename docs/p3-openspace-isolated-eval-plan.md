# P3 隔离评估方案：OpenSpace / 技能库层

> **本轮只写方案，不安装、不接入、不改主流程。**  
> OpenSpace 或任何「技能库 / 经验沉淀层」在此仅为**候选**，不是必装组件。  
> 对齐背景：闭环基础层已推送（协议 / handoff / Watcher R1–R3 / P1 / P2）；路线图见 [`docs/codex-cursor-loop-status-roadmap.md`](codex-cursor-loop-status-roadmap.md)。

---

## 1. 评估目标

判断「技能库 / 经验沉淀层」（下文以 OpenSpace **或同类工具**指代）是否适合作为本仓的**旁路知识层**，用于降低复用成本，同时**不改变**现有执行模型：

```text
CODEX_INSTRUCTION →（可选 Watcher 通知）→ Cursor 执行 → CURSOR_RESULT → CODEX_JUDGEMENT
→ 人工授权后才 commit / push
```

希望回答的核心问题：

1. 能否沉淀并检索：`CODEX_INSTRUCTION` / `CURSOR_RESULT` / `CODEX_JUDGEMENT`、Watcher 经验、P1/P2 文档任务模式？  
2. 能否减少重复写指令、重复查协议，且**保留证据**（可链回 handoff 文件与 commit）？  
3. 接入成本是否低于收益？是否会迫使重写主流程？

---

## 2. 隔离原则（硬）

| 原则 | 要求 |
|------|------|
| 沙盒优先 | 评估在**独立沙盒目录**进行，默认不写入本仓业务路径 |
| 只读主仓 | 评估期对主仓文档与 handoff **只读引用**；不改协议、不改 watcher、不改 INDEX 生成逻辑 |
| 不改主流程 | 不得把文件接力改成「技能库驱动自动执行」 |
| 候选非必装 | 评估结论可以是 reject；主线可永久不引入 |
| 无隐式联网安装 | 本方案阶段不 clone、不 `npm/pip install`、不拉远程技能包（实装评估另开任务并授权） |
| 授权不变 | 不自动 commit / push；高风险仍须人工确认 |

---

## 3. 不评估什么（本阶段明确排除）

- 不做无人值守**自动执行** instruction  
- 不做 Codex↔Cursor **进程级桥接**（属路线图 P4，且依赖稳定 API/CLI）  
- 不替代 `docs/handoffs/codex-cursor/` 文件接力与 `INDEX.md` 轻量索引  
- 不碰 AICF 小红书**发布 / 抓取 / 账号 / F4 / 日更**等运营链路  
- 不监视 Documents 旁路目录、不把旁路仓当锚点  
- 不把 OpenSpace 写成协议或 Watcher 的硬依赖  

---

## 4. 评估输入样例（只读）

评估时应带着真实材料进沙盒，而不是空谈：

| 类型 | 主仓路径（示例） |
|------|------------------|
| 协议模板 | `docs/codex-cursor-loop.md` |
| Watcher 方案与脚本经验 | `docs/codex-cursor-watcher-mvp.md`、`scripts/watch-codex-cursor-handoff.ps1`（只读） |
| Handoff 规范与索引 | `docs/handoffs/codex-cursor/README.md`、`INDEX.md` |
| Result 证据 | 如 `p1-*-r01-result.md`、`watcher-file-handoff-smoke-r01-result.md` |
| 状态与路线图 | `docs/codex-cursor-loop-status-roadmap.md`（含 P1 使用记录） |
| 可复用任务包装 | `docs/examples/codex-cursor-readme-goal-task.md` |

沙盒产出应能**链回**上述路径或 commit hash，而不是复制一份无出处文案。

---

## 5. 评估问题清单

1. **映射**：现有三段块（INSTRUCTION / RESULT / JUDGEMENT）能否无损映射为技能/卡片/笔记，而不丢 `task_id` / `round` / `result_path`？  
2. **检索**：按 `task_id`、主题（文档任务 / watcher）、风险等级检索是否比扫 handoff 目录更快？  
3. **证据**：能否一键跳到仓库内 result 文件或 commit，而不是只剩聊天摘要？  
4. **边界**：工具是否默认鼓励「自动跑脚本 / 自动改仓」？若是，如何关闭或隔离？  
5. **运维**：是否引入常驻服务、账号体系、额外运行时？本机失败时主闭环能否照常只用 Markdown？  
6. **权限**：是否要求写入主仓 `.cursor` / hooks / 全局配置？能否完全旁路？  
7. **合规**：是否可能触达 AICF 运营或外网抓取能力？默认策略能否锁死为「文档/知识 only」？  
8. **迁移成本**：若 reject，沙盒内容能否丢弃且主仓零残留？  

---

## 6. 通过 / 暂缓 / 拒绝标准

### pass（可进入「有限试点」讨论，仍非主线必装）

- 能降低重复指令成本，且证据链完整（handoff / commit 可追）  
- 沙盒运行不改主流程；关闭工具后闭环仍可用  
- 无强制联网服务、无强制自动执行  
- 运维负担可接受（单人可维护说明 ≤ 一页）  

### hold（暂缓）

- 概念有用，但安装/权限/数据模型未清  
- 与现有 INDEX / 协议字段映射有摩擦，需再开一轮沙盒  
- 缺少稳定本地运行路径，但无立即否决理由  

### reject（不进主线）

- 要求重写文件接力或绕过人工授权  
- 引入复杂常驻服务 / 多账号 / 高运维负担  
- 边界模糊（易滑向自动执行或运营自动化）  
- 无法只读引用主仓证据，只能「另起炉灶」丢链路  

决策输出建议固定为三选一：`pass` / `hold` / `reject`，并写清一句话 rationale。

---

## 7. 风险闸门

1. 评估期**禁止**自动执行高风险变更  
2. **禁止**自动 commit / push  
3. **禁止**接入 AICF 发布、抓取、账号、F4、日更  
4. **禁止**把旁路 Documents 目录当 Git 锚点  
5. 任何安装/clone/联网步骤必须**另开 instruction** 并获用户明确授权  
6. 试点若写入本仓，仅允许新增 `docs/` 下评估报告类 Markdown；不得改 watcher/协议（除非另令）  

---

## 8. 建议执行方式（后续任务，非本轮）

```text
1. 建沙盒目录（主仓外或主仓 docs/_sandbox/ 且 gitignore——具体另令）
2. 只读打开主仓协议 / handoff / 路线图样例
3. 按 §5 问题清单做一轮纸面或沙盒试用记录
4. 输出评估报告（建议路径另定，例如 docs/p3-openspace-eval-report.md）
5. 结论 pass | hold | reject → 再决定是否开「有限试点」任务
```

本轮交付物仅为**本方案文档**；不创建沙盒、不写评估报告正文结论。

---

## 9. 与现有层的关系

| 层 | 关系 |
|----|------|
| 协议 / handoff / Watcher | **主闭环**；P3 不得削弱 |
| `INDEX.md` | 轻量索引继续人工维护；技能库若存在应**链接**而非取代 |
| 路线图 P4 | 进程级桥接另行评估；不与 P3 捆绑 |

---

## 10. 相关文件

- [`docs/codex-cursor-loop-status-roadmap.md`](codex-cursor-loop-status-roadmap.md) — P3 在路线图中的位置  
- [`docs/codex-cursor-loop.md`](codex-cursor-loop.md) — 协议  
- [`docs/handoffs/codex-cursor/INDEX.md`](handoffs/codex-cursor/INDEX.md) — 轻量索引  
- [`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md) — 文件接力规范  
