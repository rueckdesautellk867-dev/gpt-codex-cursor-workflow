# Codex ↔ Cursor 局部执行闭环协议

文件交接驱动的工作闭环：**Codex 出指令 → Cursor 局部执行 → 结构化回传 → Codex 再判并出下一指令**。  
无进程级 API；靠粘贴任务块或写入约定 handoff 文件接力。

> 本协议不改变 `docs/ai-workflow.md` / `docs/ai-task-routing.md` 的总分工：  
> Cursor = IDE 内局部修改、调试、审查；整仓批量实现仍优先 Codex。

## 1. 闭环示意

```text
（可选）GPT 拆任务 / 定验收
           ↓
Codex 写 CODEX_INSTRUCTION（或审上一轮 RESULT 后出下一令）
           ↓
交接：粘贴到 Cursor 对话，或写入 handoff 文件
           ↓
Cursor 执行（局部改 / 调试 / 审查）→ 输出 CURSOR_RESULT
           ↓
Codex 判责：pass | continue | reassign | stop
           ↓
pass → 收口（写回任务 / 规则 / pilot-log）
continue → 新 CODEX_INSTRUCTION → 再进 Cursor
reassign → 改派 Codex 整仓或人工
stop → 高风险 / 缺授权 / 验收失败，等人确认
```

## 2. 角色与边界

| 角色 | 本闭环中做什么 | 不做什么 |
|------|----------------|----------|
| **Codex** | 写/改指令；读 RESULT 判责；决定下一轮或收口；适合整仓批量时自己做 | 假定 Cursor 已自动收到指令 |
| **Cursor** | 按单轮指令做局部改、调试、审查；固定格式回传 | 替代 Codex 做整仓批量；扩大「不做什么」范围 |
| **人工** | 粘贴/落盘交接；高风险确认；push / 发布 / 账号闸门授权 | 被 AI 跳过确认直接执行高风险项 |
| **GPT** | （可选）首轮拆任务、验收标准；争议时澄清边界 | 不写业务代码实现 |

硬性约束（与现有分流一致）：

- 未写清「不做什么」与「验收标准」的指令，Cursor **不执行**
- 高风险（权限 / 支付 / 库表 / 用户数据 / 鉴权 / 生产配置）→ `status: need_confirm`，停等人
- AICF 小红书相关：遵守 RISK/BANNED 与合规入口文档；无完整授权句不发布、不抓取、不跑 F4 / 日更
- 远程 push 须用户同意；失败按 `docs/push-fallback.md` 处理

## 3. 交接方式（二选一）

### A. 粘贴接力（最快）

1. Codex（或人工）把完整 `CODEX_INSTRUCTION` 块贴进 Cursor 对话  
2. Cursor 执行后回复完整 `CURSOR_RESULT` 块  
3. 人工把 RESULT 贴回 Codex（或 Codex 从对话/文件读取）

### B. 文件接力（可追溯）

约定目录（本仓）：

```text
docs/handoffs/codex-cursor/
  <task_id>-r<round>-instruction.md
  <task_id>-r<round>-result.md
```

- `task_id`：短横线小写，如 `t400-fix-x` 或 `loop-readme-goal`
- `round`：从 `01` 起递增
- 同一轮：先有 instruction，再有 result；下一轮 round+1
- 活跃任务可在 `docs/pilot-log.md` 记一行 tip（可选，非强制）

跨项目执行时：指令可指向目标仓路径（如 AICF）；RESULT 写回本仓 handoff 或目标仓约定 docs，**在 instruction 里写明回传路径**。

目录内命名与操作顺序见 [`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md)。

### C. Watcher（可选）

文件接力时可另开本机 Watcher，**只做控制台通知，不自动执行、不调用 Codex/Cursor API、不写 git**：

```text
powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1
# optional desktop tip (falls back to console on failure):
powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1 -Toast
```

- 监视目录：`docs/handoffs/codex-cursor/`
- 已实现：R1 轮询/防抖/忽略模板；R2 持久去重 state + 单实例锁；R3 可选 `-Toast`
  （运行时 `.watcher-state.json` / `.watcher.lock` 已 gitignore，勿提交）
- 方案、边界与验收：[`docs/codex-cursor-watcher-mvp.md`](codex-cursor-watcher-mvp.md)
- 默认仍只打控制台；`-Toast` 失败不得中断 watcher 主流程

## 4. 指令模板：`CODEX_INSTRUCTION`

复制填写；一项指令只做一件事。

```markdown
## CODEX_INSTRUCTION

- task_id:
- round: 01
- from: Codex
- to: Cursor
- mode: implement | debug | review
- risk: 低 | 中 | 高
- target_repo: （如 D:\AIContentFactory 或本仓路径）
- result_path: （可选；文件接力时填写 result 落盘路径）

### 目标

（完成后应达到的结果，一句话 + 必要细节）

### 背景

（上一轮结论 / 缺陷 / 相关 tip；首轮可链 `docs/task-template.md` 任务）

### 影响范围

- 预计改动文件：
- 不要碰的路径：

### 不做什么

- 

### 验收标准

- [ ]
- [ ]

### 建议验证

```text
（命令或人工检查步骤）
```

### 判责提示（给 Codex 下一轮用）

- pass 条件：
- continue 时优先看：
- stop 条件：
```

`mode` 含义：

| mode | Cursor 行为 |
|------|-------------|
| `implement` | 最小局部实现；只改列出的文件范围 |
| `debug` | 复现 → 定位 → 最小修复；先证据后改代码 |
| `review` | 只读审查或按清单核对；默认不改代码，除非指令明确允许「审查中顺带修」 |

## 5. 回传模板：`CURSOR_RESULT`

Cursor 每轮结束必须输出（对话 + 若指定了 `result_path` 则落盘）。

```markdown
## CURSOR_RESULT

- task_id:
- round:
- status: done | blocked | need_confirm
- mode_done: implement | debug | review

### 变更总结

- （做了什么、为什么；无代码改动则写「仅审查/仅调试结论」）

### 实际改动文件

- path — 简述
- （无则写：无）

### 验证结果

- 命令：
- 结果：通过 | 失败 | 未跑（原因）

### 风险与待确认

- （无则写：无）

### 阻塞原因（仅 blocked）

- 

### 建议下一动作

- pass | continue | reassign_codex | stop_human
- 若 continue：建议下一指令焦点（给 Codex 起草用）
```

`status`：

| status | 含义 | Codex 典型动作 |
|--------|------|----------------|
| `done` | 本轮验收项已满足或审查结论已给出 | 判 pass 或 continue（有后续切片） |
| `blocked` | 缺上下文 / 环境 / 依赖他人 | 补指令或转人工，勿盲目加 round |
| `need_confirm` | 高风险或越权边界 | **stop**，等人确认后再出令 |

## 6. Codex 判责（读 RESULT 后）

Codex 输出简短判责块（可写入下一轮 instruction 的「背景」）：

```markdown
## CODEX_JUDGEMENT

- task_id:
- on_round:
- decision: pass | continue | reassign | stop
- rationale: （一句话）
- next: （continue 时指向 rNN instruction；pass/stop 时写收口动作）
```

| decision | 条件示例 |
|----------|----------|
| `pass` | 验收勾满；验证通过或已说明可接受的未跑原因；无待确认 |
| `continue` | 目标未完但本轮切片正确；需下一局部步骤 |
| `reassign` | 发现需整仓/多模块批量 → 改由 Codex 实现，或改派人工 |
| `stop` | 高风险、合规闸门、验收失败且不可自动修、用户未授权 |

## 7. 轮次与收口

1. **单轮单焦点**：一则 instruction 只含一个可验收切片  
2. **round 单调递增**：不覆盖历史 instruction/result 文件  
3. **主执行者唯一**：本闭环 Cursor 为主执行者时，Codex 只出令与判责，不并行改同一批文件（避免冲突）  
4. **收口**：`pass` 后按需更新 `docs/pilot-log.md` / 任务状态；经验缺陷写回 `AGENTS.md` 或 `.cursor/rules`（另开任务，不在本轮顺手改）  
5. **与总流程关系**：本闭环可嵌入 `docs/ai-workflow.md` 的「实现 ↔ 审查/修复」段；合并前仍对照 `PR_CHECKLIST.md`

## 8. 最小试跑清单

- [ ] Codex（或人工代填）写 `CODEX_INSTRUCTION`（低风险、单一文件更佳）  
- [ ] Cursor 执行并回 `CURSOR_RESULT`  
- [ ] Codex 出 `CODEX_JUDGEMENT`  
- [ ] 若 `continue`，再跑一轮；若 `pass`，记 tip 收口  

示例任务可参考：`docs/examples/low-risk-doc-update-task.md`（把推荐执行者设为 Cursor，并包一层本协议模板）。

## 9. 相关文件

- `docs/ai-workflow.md` — 三方总流程  
- `docs/ai-task-routing.md` — 谁做谁不做  
- `docs/task-template.md` — 通用任务模板（首轮可先填这个再拆成 instruction）  
- `docs/definition-of-done.md` — 完成标准  
- `docs/risk-approval.md` — 高风险审批  
- `docs/push-fallback.md` — 推送失败降级  
- `docs/handoffs/codex-cursor/README.md` — 文件接力目录规范  
- `docs/codex-cursor-watcher-mvp.md` — Watcher MVP 方案（可选通知器）  
- `scripts/watch-codex-cursor-handoff.ps1` — Watcher R1/R2 脚本  
- `AGENTS.md` — Codex 仓库级规则  
- `.cursor/rules/ai-workflow.mdc` — Cursor 执行规范  
