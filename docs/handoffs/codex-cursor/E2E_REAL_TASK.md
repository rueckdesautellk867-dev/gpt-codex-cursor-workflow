# 真实任务 E2E 验证方案（Automation Step 19）

> **这是什么**：用一次**低风险真实文档任务**跑通文件 handoff → watcher → queue → judgement → commit/push 授权 → INDEX 建议（及可选 SAFE_INDEX_APPLY 写入）的闭环验证。  
> **这不是什么**：不是自动执行；不是无人值守；不跳过人工授权；不触发高风险变更；不进入 AICF 运营链路。  
> **本轮只定方案，不执行 E2E，不改 INDEX / 脚本。**  
> 相关：[`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md)

---

## 1. 目标

验证半自动闭环在「真实低风险文档改动」上是否可端到端走通，并留下可复盘记录：

| 检查点 | 期望 |
|--------|------|
| instruction → Cursor | 有 `*-instruction.md`，Cursor 按 instruction 改文档并写 `*-result.md` |
| Watcher | instruction / result 出现时有通知（人工确认） |
| Queue | `list-codex-cursor-queue.ps1` 能列出本任务待判责 |
| Judgement | Codex/人工给出 pass / continue / stop 并有记录 |
| Git | commit 与 push **均**有完整人工授权句后才执行 |
| INDEX | `suggest-codex-cursor-index.ps1` 能建议本任务；是否写入遵循 SAFE_INDEX_APPLY |

---

## 2. 建议试跑任务（低风险）

| 约束 | 要求 |
|------|------|
| 改动类型 | **只改一个文档**（例如某方案文「相关文件」列表、或 handoff 索引入口的一行链接） |
| 禁止 | 业务代码、脚本、CI、依赖、Git 配置、INDEX/STATE/RISK_GATE **正文**（INDEX 写入仅在判责后按 SAFE_INDEX_APPLY 另步） |
| risk 字段 | 指令中标明 `risk: 低` |
| 范围 | 仅 `docs/handoffs/codex-cursor/` 内 Markdown（或同级纯文档） |

**示例任务标题（未来执行时另开 instruction）**：为 `ONE_SHOT_OBSERVER.md` 或 `E2E_REAL_TASK.md` 补一行「相关文件」链接到对方文档——单文件、可 diff、易回滚。

---

## 3. 十步流程

| 步 | 动作 | 角色 | 产出 / 检查 |
|----|------|------|-------------|
| **1** | Codex 写 `*-instruction.md`（低风险文档任务） | Codex | instruction 落盘；`risk: 低`；`result_path` 明确 |
| **2** | Watcher 通知 instruction | Watcher + 人工 | 人工确认通知出现（toast/控制台） |
| **3** | Cursor 按 instruction 执行并写 `*-result.md` | Cursor | 仅允许范围内文档改动 + result |
| **4** | Watcher 通知 result | Watcher + 人工 | 人工确认 result 通知出现 |
| **5** | 运行 `list-codex-cursor-queue.ps1` | 人工 / Codex | 队列中可见本 `task_id` |
| **6** | Codex 判责 `pass` / `continue` / `stop` | Codex | judgement 有记录（handoff / INDEX note / 对话回传均可，以仓库约定为准） |
| **7** | 人工授权 **commit** | 人工 | 完整授权句后才 `git commit` |
| **8** | 人工授权 **push** | 人工 | 完整授权句后才 `git push`（可与 commit 分授） |
| **9** | 运行 `suggest-codex-cursor-index.ps1` | 人工 / Codex | 输出中出现本任务建议行（或明确「已在 INDEX」） |
| **10** | 按 [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) 决定是否更新 INDEX | 人工 | 写入另授；不自动写；高风险/blocked 不写入 |

可选并行：步 5～9 前后可用 [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) R0 清单做总览。

---

## 4. 验收标准

全部满足才算本次 E2E **通过**：

1. **Watcher**：instruction 与 result 均观察到通知（或明确记录「Watcher 未开 + 原因」并记为部分通过 / 重跑）  
2. **Queue**：`list-codex-cursor-queue.ps1` 输出含本任务  
3. **Judgement**：有 pass / continue / stop 记录  
4. **Commit / Push**：各有一次人工完整授权；无授权不得执行  
5. **INDEX 建议**：suggest 脚本对本任务有可见建议或「已索引」说明  
6. **仓库**：最终 `git status` 干净（含 INDEX 若本轮选择写入，则写入已提交）  

未满足任一项 → 记 `continue` 或 `stop`，并在记录模板中写缺口。

---

## 5. 风险闸门

| 条件 | 动作 |
|------|------|
| 指令/改动命中 [`RISK_GATE.md`](RISK_GATE.md) 关键词，或 `risk: 高` / `blocked` / `need_confirm` | **立即停下**，人工确认；不得继续 commit/push/写 INDEX |
| 范围滑到脚本、协议正文、AICF 运营（抓取/发布/F4/日更等） | **停止**本 E2E；另开合规与风险审批 |
| 无人值守、自动判责、自动 commit/push | **禁止**；违反即本轮无效 |
| Documents 旁路或其它仓当作主仓 | **禁止**；主仓仍为 `三方闭环整合项目` |

低风险文档任务默认不进 Gate；一旦混入上表 → 按高风险候选处理。

---

## 6. 记录模板（建议）

试跑结束后保存一份记录（可新建 `docs/handoffs/codex-cursor/e2e-<task_id>-log.md`，或贴在对应 result 附录；**本方案不强制本轮创建**）：

```markdown
# E2E log

| 字段 | 值 |
|------|-----|
| task_id | |
| instruction path | |
| result path | |
| watcher instruction notify | yes / no / n/a（原因） |
| watcher result notify | yes / no / n/a（原因） |
| queue output 摘要 | （粘贴表头+本行或简述） |
| judgement | pass / continue / stop + 简述 |
| commit | SHA + 是否人工授权 |
| push | remote/branch + 是否人工授权 |
| index suggestion 摘要 | （建议行或「已在 INDEX」） |
| INDEX 是否按 SAFE_INDEX_APPLY 写入 | yes / no + 授权说明 |
| 最终 git status | clean / dirty（列文件） |
| 最终状态 | pass / continue / stop |
| 缺口与备注 | |
```

---

## 7. 本轮与未来执行边界

| 阶段 | 做什么 |
|------|--------|
| **本轮（Step 19 plan）** | 仅新增本文件；**不**开真实 E2E instruction |
| **未来执行** | 另开低风险 `*-instruction.md`，按 §3 十步跑；记录用 §6 |
| **观察辅助** | R0：[`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)；联动提示：[`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md) |

---

## 8. 相关文件

- [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1)  
- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`WATCHER_QUEUE_INDEX_LINK.md`](WATCHER_QUEUE_INDEX_LINK.md)  
- [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md)  
