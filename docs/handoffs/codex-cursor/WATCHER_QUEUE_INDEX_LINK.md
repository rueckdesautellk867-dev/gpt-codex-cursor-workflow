# Watcher ↔ Queue / Index 联动方案（Automation Step 17）

> **这是什么**：Watcher 发现稳定落盘的 instruction/result 后，在**通知文案**里提示人工可运行的下一步**只读**命令（队列 / INDEX 建议）。  
> **这不是什么**：不自动跑 queue/index 脚本；不自动打开 Cursor/Codex；不自动判责；不自动改 INDEX；不自动 commit/push。  
> **本轮只落方案**；不改 [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1) 行为。  
> 安全边界服从 [`RISK_GATE.md`](RISK_GATE.md)、[`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)；脚本只读见 [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md)、[`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md)。

---

## 1. 联动目标

在「有通知」与「知道下一步跑哪条命令」之间补一层文档约定，减少人工遗忘，同时保持人在环内。

| 事件 | 建议人工下一步 |
|------|----------------|
| 新 `*-result.md` 稳定落盘 | 跑待判责队列脚本，再按 [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md) 判责 |
| 新 `*-instruction.md` 稳定落盘 | 按 [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md) 接收执行；并可跑 INDEX 建议脚本检查是否漏记 |

---

## 2. 推荐提示命令（给人 / 未来塞进通知文案）

在主仓根目录：

**result 通知后：**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\list-codex-cursor-queue.ps1
```

**instruction 通知后：**

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1
```

可选补充（不替代上两者）：

```powershell
# 需要桌面提示时再加 -Toast（仍只通知）
powershell -NoProfile -File scripts\watch-codex-cursor-handoff.ps1 -Toast
```

`-ExecutionPolicy Bypass` 为进程级，不改系统策略。

---

## 3. 明确不是什么

| 禁止 | 说明 |
|------|------|
| Watcher 子进程调用 queue/index | R0/R1 均默认禁止自动 spawn |
| 自动打开 Cursor / Codex | 仅提示命令 |
| 自动判责 / 写 judgement | 人触发 |
| 自动 apply INDEX | 须走 SAFE_INDEX_APPLY |
| 自动 commit/push | 须用户明确授权 |

---

## 4. R0 / R1 / R2

| 阶段 | 方式 | 改 watcher？ |
|------|------|----------------|
| **R0（当前）** | 本文档化：人看到通知后**自己**复制 §2 命令 | 否 |
| **R1（未来）** | Watcher 在 `[handoff]` 通知中**追加**建议命令字符串；仍不执行 | 是（另开任务） |
| **R2（未来）** | 可选本地「一键观察」脚本（串联打印 queue+index 建议）；**仍由人工运行**；不写 INDEX | 新脚本另开；watcher 可不改 |

R1 实现时须保持：去重、防抖、单实例、只读 handoff；失败不得阻断原通知。

---

## 5. 触发策略

| 触发 | 条件 | 提示侧重 |
|------|------|----------|
| result | Watcher 已对 `*-result.md` 发出稳定落盘通知 | queue 脚本 |
| instruction | Watcher 已对 `*-instruction.md` 发出通知 | Cursor 接收 + index 建议脚本 |
| judgement（若使用） | 可选提示更新 INDEX / 移出队列 | 人工；非必须 |

去重、防抖、state/lock：**仍由现有 watcher 负责**；本联动不另建去重层。

模板 / README / 方案文：watcher 已忽略则不提示。

---

## 6. 与安全边界的关系

| 文件 | 关系 |
|------|------|
| RISK_GATE | 联动提示不放行高风险；queue 的 `risk_hint` / `need_confirm` 仍须人工 |
| SAFE_INDEX_APPLY | index 建议输出后，写入 INDEX 仍走人工确认流程 |
| READONLY_QUEUE_SCRIPT / list 脚本 | 只读；联动只「推荐运行」 |
| INDEX_UPDATE_HELPER / suggest 脚本 | 只读；联动只「推荐运行」 |
| CURSOR_RECEIVE / CODEX_JUDGEMENT_SEMI_AUTO | 执行与判责半自动流程不变 |

---

## 7. R0 操作清单（现在就能用）

1. （可选）启动 watcher 通知  
2. 见 result 通知 → 运行 `list-codex-cursor-queue.ps1` → 选一条交给 Codex 判责  
3. 见 instruction 通知 → 打开/粘贴到 Cursor 执行 →（可选）跑 `suggest-codex-cursor-index.ps1` → 按 SAFE_INDEX_APPLY 决定是否改 INDEX  
4. 入库另授  

---

## 8. 风险闸门

1. 提示 ≠ 执行  
2. 不自动写 INDEX / judgement  
3. 不自动 commit/push  
4. 不扩展监视到 Documents 旁路或其它仓（跨仓观察见 CROSS_REPO_OBSERVER，与本联动分离）  

---

## 9. 相关文件

- [`scripts/watch-codex-cursor-handoff.ps1`](../../../scripts/watch-codex-cursor-handoff.ps1)  
- [`scripts/list-codex-cursor-queue.ps1`](../../../scripts/list-codex-cursor-queue.ps1)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`READONLY_QUEUE_SCRIPT.md`](READONLY_QUEUE_SCRIPT.md) · [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
- [`RISK_GATE.md`](RISK_GATE.md) · [`CURSOR_RECEIVE.md`](CURSOR_RECEIVE.md) · [`CODEX_JUDGEMENT_SEMI_AUTO.md`](CODEX_JUDGEMENT_SEMI_AUTO.md)  
