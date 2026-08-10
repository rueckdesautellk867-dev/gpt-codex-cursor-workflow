# Handoff 任务记录索引（轻量）

> **这是什么**：人工 / 半人工维护的任务索引，方便在 `*-result.md` 变多时快速定位。  
> **这不是什么**：不是自动执行器，不替代 instruction/result，不驱动 Codex/Cursor，不自动 commit/push。  
> 命名与操作顺序仍以 [`README.md`](README.md) 与 `docs/codex-cursor-loop.md` 为准。
> **`status` 字段**与状态机对齐：见 [`STATE.md`](STATE.md)（Automation Step 1）。

## 1. 维护规则

| 规则 | 说明 |
|------|------|
| 谁维护 | 任务执行者（Cursor / Codex / 人工）在关键节点补一行即可 |
| 是否必须 | 可选（对应路线图 P2）；不做不阻塞文件接力 |
| 历史回填 | **不要求**全量补齐；按需记最近活跃任务 |
| 自动生成 | 若要脚本生成 INDEX，**必须另开任务**；本文件只定方案与样例 |
| 执行模型 | 索引变更不改变「文件接力 + 人工授权入库」模型 |

## 2. 建议字段

表格列（一行一事 / 一轮）：

| 字段 | 含义 |
|------|------|
| `task_id` | 与 instruction/result 文件名前缀一致 |
| `round` | 如 `01` |
| `status` | 使用 [`STATE.md`](STATE.md) 枚举（见下节）；一行记**当前最远已达**状态 |
| `result` | 相对本目录的 result 文件名（可点链接） |
| `commit` | 已入库则填短 hash；未入库填 `-` |
| `push` | `yes` / `no` / `n/a`（相对当时 `origin/main`；与 `status=pushed` 应对齐） |
| `note` | 一句话说明 |

可选附加列（需要时再加，避免表过宽）：`mode`、`judgement`、`date`。

### 2.1 状态字段约定

- **新行推荐值**（摘自 STATE）：`draft` · `ready_for_cursor` · `cursor_done` · `needs_codex_judgement` · `passed` · `needs_continue` · `blocked` · `committed` · `pushed`
- 已 **人工授权 push** 且远端对齐：`status=pushed`，且 `push=yes`、`commit` 填短 hash
- 仅本地 commit：`status=committed`，`push=no`
- 判责通过尚未入库：`status=passed`
- **旧值映射**（历史行可不回填）：`done` ≈ 至少 `passed`；若当时已 push，视同 `pushed`；`open` ≈ `ready_for_cursor` 或 `needs_codex_judgement`；`need_confirm` ≈ `blocked`
- INDEX **不**自动推进状态；Watcher **不**改本表

## 3. 何时更新

1. **result 落盘后**：可先加一行，`status=cursor_done` 或 `needs_codex_judgement`，`commit=-`，`push=no`
2. **判责后**：改为 `passed` / `needs_continue` / `blocked`
3. **本地 commit 后**：`status=committed`，补 `commit`
4. **push 成功后**：`status=pushed`，`push=yes`
5. **判责 continue**：同一 `task_id` 可新开一行（提高 `round`）

不在索引里执行任务；Watcher 通知与索引维护无关。

## 4. 索引表（最近样例，非全量）

仅列最近 P1 真实低风险文档任务样例（截至 `c673c40`）。更早的 watcher 实现 / 冒烟 result **不强制回填**。

| task_id | round | status | result | commit | push | note |
|---------|-------|--------|--------|--------|------|------|
| p1-real-doc-task-index-roadmap | 01 | pushed | [p1-real-doc-task-index-roadmap-r01-result.md](p1-real-doc-task-index-roadmap-r01-result.md) | `674c36a` | yes | 协议 §9 补路线图入口（收窄后入库） |
| p1-real-doc-task-handoff-usage-tip | 01 | pushed | [p1-real-doc-task-handoff-usage-tip-r01-result.md](p1-real-doc-task-handoff-usage-tip-r01-result.md) | `25de00f` | yes | handoff README 补 Watcher 使用提示 |
| p1-usage-log-roadmap-note | 01 | pushed | [p1-usage-log-roadmap-note-r01-result.md](p1-usage-log-roadmap-note-r01-result.md) | `c673c40` | yes | 路线图记录 P1 使用样例 |

新行加在表**顶部**或底部均可；建议顶部（最新在上）。本轮任务待入库后再补行（勿全量回填历史）。

## 5. 行模板（复制用）

```markdown
| task_id | 01 | needs_codex_judgement | [task_id-r01-result.md](task_id-r01-result.md) | `-` | no | 一句话 |
```

## 6. 相关文件

- [`README.md`](README.md) — 目录命名与操作顺序  
- [`STATE.md`](STATE.md) — handoff 任务状态机（status 枚举与转移）
- [`_template-instruction.md`](_template-instruction.md) / [`_template-result.md`](_template-result.md)  
- `docs/codex-cursor-loop.md` — 闭环协议  
- `docs/codex-cursor-loop-status-roadmap.md` — 状态与 P1–P4 路线图  
