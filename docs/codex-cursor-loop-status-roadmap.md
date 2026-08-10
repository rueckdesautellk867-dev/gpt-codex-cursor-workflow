# Codex ↔ Cursor 自动闭环：基础层状态与路线图

> **收口说明**：本文描述当前「已经做到什么 / 仍未做到什么 / 下一阶段怎么推进」。  
> **对齐提交**：`06a27c6`（Watcher R3 已推送）。  
> **勿误解**：现有能力是 **文件接力 + 通知增强**，不是进程级自动互发，也不是无人值守自动执行。

相关入口：

- 协议：[`docs/codex-cursor-loop.md`](codex-cursor-loop.md)
- 文件接力目录：[`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md)
- Watcher 方案：[`docs/codex-cursor-watcher-mvp.md`](codex-cursor-watcher-mvp.md)
- Watcher 脚本：[`scripts/watch-codex-cursor-handoff.ps1`](../scripts/watch-codex-cursor-handoff.ps1)

---

## 1. 当前状态（已完成）

| 层 | 状态 | 说明 |
|----|------|------|
| 协议层 | 完成 | `CODEX_INSTRUCTION` / `CURSOR_RESULT` / `CODEX_JUDGEMENT` 模板与边界已固化 |
| 文件接力目录 | 完成 | `docs/handoffs/codex-cursor/` + `_template-*` + 命名/生命周期约定 |
| Watcher 方案 | 完成 | MVP 文档定义监视范围、防抖、通知、硬边界、切片 |
| Watcher R1 | 完成 | 轮询、控制台日志、防抖、忽略模板 |
| Watcher R2 | 完成 | 持久去重 `.watcher-state.json` + 单实例 `.watcher.lock`（已 gitignore） |
| Watcher R3 | 完成 | 可选 `-Toast`；失败回退控制台，不中断主流程 |
| 协议入口 | 完成 | `docs/codex-cursor-loop.md` §3C 写明启动方式与边界 |
| 冒烟验证 | 通过 | 文件接力 + watcher 通知冒烟结果已入库 |

主仓锚点：`D:\AIContentFactory\三方闭环整合项目`（`gpt-codex-cursor-workflow`）。  
旁路 `Documents\ChatGPT + Cursor 工作流` **不是** Git 锚点，不纳入本路线图监视范围。

---

## 2. 能力边界（现在是什么 / 不是什么）

### 现在是

- **粘贴接力**或 **handoff 文件接力** 的人机/双 Agent 协作通道
- 本机 Watcher 对 handoff 目录的 **通知增强**（控制台，可选 Toast）
- Cursor 局部执行 + Codex 判责 + **人工**授权 commit/push 的闭环

### 现在不是

- Codex ↔ Cursor **进程级**自动互发 API
- **无人值守**自动打开 Agent、自动执行 instruction 正文
- 自动 commit / 自动 push / 自动放行高风险变更
- 多仓并行监视、云端 webhook、远程触发

一句话：**通知层 ≠ 自动执行层。**

---

## 3. 已验证

| 项 | 结果 | 依据（示例） |
|----|------|----------------|
| instruction 稳定落盘 → 通知 | 通过 | 冒烟 / R1–R3 短跑 |
| result 稳定落盘 → 通知 | 通过 | 冒烟 |
| state 去重（含重启后同签名） | 通过 | R2 / 冒烟 |
| lock 单实例 | 通过 | R2 / 冒烟（第二实例 `LOCK_BLOCKED`） |
| runtime 文件不进 git | 通过 | `.gitignore` + `check-ignore` |
| 默认无 Toast；`-Toast` 可选 | 通过 | R3（失败不中断主流程） |
| 探针清理后工作区干净 | 通过 | 冒烟 result |

冒烟回传示例：`docs/handoffs/codex-cursor/watcher-file-handoff-smoke-r01-result.md`。

---

## 4. 未完成 / 明确不做（本阶段）

| 项 | 说明 |
|----|------|
| 自动执行 instruction | 不做；须 Cursor/人工打开并执行 |
| 进程级桥接 | 无稳定官方 API/CLI 前不评估落地 |
| OpenSpace / 外部技能总线进主线 | 本阶段不做；仅允许隔离评估（见 P3） |
| 监视 Documents 旁路或整仓 | 不做 |
| AICF 发布/抓取/账号/F4/日更自动化 | 不做；遵守 RISK/BANNED 与授权句 |
| Watcher 多仓 / 远程通知 | 非当前基础层范围 |

---

## 5. 下一阶段路线图

| 阶段 | 内容 | 完成标准（摘要） |
|------|------|------------------|
| **P1** | **稳定使用**现有 watcher 跑真实低风险文档任务 | 至少 1～2 轮真实 `CODEX_INSTRUCTION`→文件接力→`CURSOR_RESULT`→判责；仍人工授权入库 |
| **P2** | （可选）补任务日志 / `pilot-log` 轻量索引 | 活跃 handoff tip 可检索；不改变执行模型 |
| **P3** | （隔离）评估 OpenSpace 或技能库层 | 沙盒结论文档；**不默认合并主线**；不替代本协议 |
| **P4** | 仅当存在稳定 API/CLI 时，再评估真正桥接 | 书面边界 + 人工闸门；默认仍禁止无人值守高风险 |

推进原则：先把 P1 用熟，再谈 P2；P3/P4 不得挤压 P1 的稳定性。

### P1 使用记录（真实低风险文档任务）

基础层已用于真实文档任务（不只是冒烟）。流程仍是：

`CODEX_INSTRUCTION` →（可选 Watcher 通知）→ Cursor 执行 → `CURSOR_RESULT` → `CODEX_JUDGEMENT` → **人工授权**后才 commit/push。

这不是自动执行 instruction，也不是 Codex↔Cursor 进程级互通。

| 提交 | 任务 | 说明 |
|------|------|------|
| `674c36a` | 路线图入口补充 | 在 `docs/codex-cursor-loop.md` §9 增加本路线图链接 |
| `25de00f` | handoff Watcher 使用提示 | 在 `docs/handoffs/codex-cursor/README.md` 增加启动命令与 `-Toast` 提示 |

P1「至少 1～2 轮真实低风险文档任务」样例已满足；后续可继续同类任务，或另开任务评估可选 P2。

---

## 6. 风险闸门（硬）

1. **不自动执行**高风险任务（权限 / 支付 / 库表 / 用户数据 / 鉴权 / 生产配置）  
2. **不自动** commit / push；须用户明确授权句  
3. Watcher **只监视**约定 handoff 目录；不监视 Documents 旁路、不监视 AICF 业务仓（除非另开任务并书面改范围）  
4. **不碰** AICF 小红书运营链路：发布、抓取、账号、F4、日更等  
5. **新工具**（含 OpenSpace、第三方 Agent 总线）先沙盒评估，再决定是否进主线  
6. Toast / 通知失败必须可降级为控制台；不得为了通知引入不明网络外呼依赖  

---

## 7. 推荐日常用法（P1）

```text
1. Codex 写 docs/handoffs/codex-cursor/<task>-r01-instruction.md
2. （可选）本机启动：
   powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1
   # 需要桌面提示时再加 -Toast
3. Cursor 读 instruction → 执行 → 写同轮 *-result.md（并可贴对话）
4. Codex 读 result → CODEX_JUDGEMENT
5. 入库 / push 仅在用户明确授权后进行
```

---

## 8. 相关文件

- [`docs/codex-cursor-loop.md`](codex-cursor-loop.md)
- [`docs/codex-cursor-watcher-mvp.md`](codex-cursor-watcher-mvp.md)
- [`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md)
- [`docs/examples/codex-cursor-readme-goal-task.md`](examples/codex-cursor-readme-goal-task.md)
- [`scripts/watch-codex-cursor-handoff.ps1`](../scripts/watch-codex-cursor-handoff.ps1)
- [`docs/ai-workflow.md`](ai-workflow.md) / [`docs/ai-task-routing.md`](ai-task-routing.md)
