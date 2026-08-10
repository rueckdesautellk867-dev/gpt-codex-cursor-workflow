# Handoff 任务状态机（Automation Step 1）

> **这是什么**：文件接力任务的状态枚举与转移规则，供后续自动汇总、判责提示、高风险 gate 共用。  
> **这不是什么**：不是执行器；不驱动 Cursor/Codex 自动改代码；不自动 commit/push。  
> Watcher 仍只做通知。命名与操作顺序见 [`README.md`](README.md)；轻量索引见 [`INDEX.md`](INDEX.md)。

---

## 1. 状态枚举

| 状态 | 含义 |
|------|------|
| `draft` | instruction 草稿未就绪（缺目标/验收/不做什么等） |
| `ready_for_cursor` | instruction 已完整落盘，等待 Cursor 执行 |
| `cursor_done` | Cursor 已写完同轮 `*-result.md`（或对话等价 RESULT） |
| `needs_codex_judgement` | 等待 Codex 输出 `CODEX_JUDGEMENT` |
| `passed` | 判责 `pass`，本轮切片验收通过（尚未要求入库） |
| `needs_continue` | 判责 `continue`，需下一 round instruction |
| `blocked` | `blocked` / `need_confirm` / 缺授权 / 环境阻塞 |
| `committed` | 相关改动已本地 commit（人工授权后） |
| `pushed` | 已推送到 `origin`（人工授权后） |

说明：

- 一轮 = 一对 `…-rNN-instruction.md` + `…-rNN-result.md`（judgement 可选）。  
- `needs_continue` 通常伴随 **新 round**（如 r02），新轮从 `draft` 或直接 `ready_for_cursor` 开始。  
- `passed` ≠ 已入库；入库是后续 `committed` / `pushed`。

---

## 2. 谁推进

| 角色 | 可推进的典型转移 |
|------|------------------|
| **Codex** | → `ready_for_cursor`（instruction 写完）；`needs_codex_judgement` → `passed` / `needs_continue` / `blocked` |
| **Cursor** | `ready_for_cursor` → `cursor_done`（result 落盘）→ 通常进入 `needs_codex_judgement` |
| **人工** | 任意进入/解除 `blocked`；**唯一**可授权 → `committed`、→ `pushed`；高风险放行 |
| **Watcher** | **不推进状态**；仅在文件稳定落盘时通知（见 §5） |

---

## 3. 状态转移规则

```text
draft
  └─(Codex/人工补全 instruction)──► ready_for_cursor
                                      │
                                      ├─(Cursor 执行并写 result)──► cursor_done
                                      │                               │
                                      │                               └─► needs_codex_judgement
                                      │                                      │
                                      │                    ┌─────────────────┼─────────────────┐
                                      │                    ▼                 ▼                 ▼
                                      │                 passed        needs_continue        blocked
                                      │                    │                 │                 │
                                      │                    │                 └─► 新 round: draft/ready_for_cursor
                                      │                    │
                                      │                    └─(人工授权 commit)──► committed
                                      │                                              │
                                      │                                              └─(人工授权 push)──► pushed
                                      │
                                      └─(缺上下文/高风险未确认等)──► blocked ──(人工解除)──► ready_for_cursor 或 needs_codex_judgement
```

### 允许的转移（简表）

| 从 | 到 | 推进者 | 条件（摘要） |
|----|----|--------|----------------|
| `draft` | `ready_for_cursor` | Codex/人工 | 含目标、不做什么、验收标准 |
| `ready_for_cursor` | `cursor_done` | Cursor | 同轮 result 落盘且可验收 |
| `ready_for_cursor` | `blocked` | Cursor/人工 | 无法执行或需确认 |
| `cursor_done` | `needs_codex_judgement` | Cursor/惯例 | result 就绪待判（可与 cursor_done 合并理解，索引里可直接记后者） |
| `needs_codex_judgement` | `passed` | Codex | judgement = pass |
| `needs_codex_judgement` | `needs_continue` | Codex | judgement = continue |
| `needs_codex_judgement` | `blocked` | Codex | judgement = stop / 高风险 / 缺授权 |
| `needs_continue` | `draft` 或 `ready_for_cursor` | Codex | 新 round instruction |
| `blocked` | `ready_for_cursor` / `needs_codex_judgement` | 人工 | 阻塞解除 |
| `passed` | `committed` | **仅人工** | 明确授权 commit |
| `committed` | `pushed` | **仅人工** | 明确授权 push |
| `passed` | `pushed` | — | **不允许跳过** `committed`（无本地 tip 不声明已 push） |

禁止：

- Watcher / 脚本自动：`passed` → `committed` / `pushed`  
- 任何角色在无授权下自动 push  
- 高风险任务从 `ready_for_cursor` 自动滑到执行完成而无 `blocked`/`need_confirm` 闸门  

---

## 4. 必须人工授权的节点

| 节点 | 原因 |
|------|------|
| → `committed` | 写入 Git 历史 |
| → `pushed` | 更新远端 |
| 高风险从 `blocked` 放行 | 权限/支付/库表/用户数据/鉴权/生产等 |
| AICF 运营相关 | 发布/抓取/账号/F4/日更等（本状态机默认不覆盖这些任务） |

`passed` 只表示「本轮任务切片判责通过」，**不包含**入库授权。

---

## 5. Watcher 与通知

Watcher **只通知、不改状态机、不执行**：

| 文件事件 | 建议理解为 | Watcher |
|----------|------------|---------|
| `*-instruction.md` 稳定落盘 | 常对应进入 / 处于 `ready_for_cursor` | 可通知 |
| `*-result.md` 稳定落盘 | 常对应 `cursor_done` / `needs_codex_judgement` | 可通知 |
| `*-judgement.md` 稳定落盘（若使用） | 常对应 `passed` / `needs_continue` / `blocked` | 可通知 |
| `_template-*` / `README` / `STATE` / `INDEX` | 非任务轮次 | 忽略或不作「可执行」通知 |

状态落盘方式（本 Step 约定，**不强制改文件格式**）：

- 优先：在 `INDEX.md` 的 `status` 列使用上表枚举（或可映射的短别名）  
- 可选：在 result / judgement 正文注明 `handoff_state: …`  
- 不要求本轮改 INDEX 历史行  

---

## 6. 与 CURSOR_RESULT.status 的映射（参考）

| CURSOR_RESULT `status` | 建议 handoff 状态 |
|------------------------|-------------------|
| `done` | `cursor_done` → 再由 Codex 判到 `passed` / `needs_continue` / `blocked` |
| `blocked` | `blocked` |
| `need_confirm` | `blocked`（待人工） |

Codex `decision`：`pass` → `passed`；`continue` → `needs_continue`；`stop` → `blocked`；`reassign` → `blocked` 或新任务 `draft`（人工/Codex 标明）。

---

## 7. 高风险闸门

- 指令 `risk: 高` 或触及权限/支付/库表/用户数据/鉴权/生产配置 → 默认进入或保持 `blocked`，直至人工确认。  
- 状态机**不得**规定自动解除高风险 `blocked`。  
- 文档类低风险任务可正常 `ready_for_cursor` → … → `passed`。  

---

## 8. 非目标（后续 Step 另开）

- 自动改 INDEX / 自动写 STATE 旁路文件  
- 自动打开 Cursor Agent / 自动跑 Codex  
- 自动 commit / push  
- OpenSpace 技能库（P3 = hold）  
- 进程级桥接（P4）  

---

## 9. 相关文件

- [`README.md`](README.md)  
- [`INDEX.md`](INDEX.md)  
- [`_template-instruction.md`](_template-instruction.md) / [`_template-result.md`](_template-result.md)  
- `docs/codex-cursor-loop.md`  
- `docs/codex-cursor-loop-phase-closeout.md`  
