# Option C Step 14：Pilot P0 提示优化阶段收口

> **P0 结论**：**Pilot P0 可用**；仅为**只读提示优化**（hints + 可复制块）；**不是**真正自动闭环。  
> **不可**：由本收口直接升级 **P1 / P2 / P3**。  
> sandbox 仍在主仓外：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`（**不纳入**主仓 git）。  
> 签核：[`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md)（P0 Go）  
> 验收：[`option-c-p0-hint-optimization-acceptance-r01-result.md`](option-c-p0-hint-optimization-acceptance-r01-result.md)  
> 服从：[`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)；日常观察主入口仍是 Option B [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)

---

## 1. 阶段结论

| 项 | 值 |
|----|-----|
| Level | **P0**（`P0_readonly_hint_optimization`） |
| 可用性 | **可用**（人工启动 sandbox runner） |
| 本质 | 提示优化 + 可复制 NEXT_ACTION 块 |
| 是否自动闭环 | **否** |
| 可否升 P1/P2/P3 | **否** — 须新签核 / 高风险审计（见 RISK_EVAL） |

---

## 2. 已验证

| 检查项 | 结果 |
|--------|------|
| Markdown：`## Hints` / `## Copy Blocks` / `## Safety` | 通过 |
| `CURSOR_NEXT_ACTION` / `CODEX_NEXT_ACTION` 可复制块 | 通过 |
| JSON：`copy_blocks` / `safety_summary`；`pilot_level=P0` | 通过 |
| `DISABLED` kill switch；验证后可删除 | 通过 |
| 主仓 scripts / `INDEX.md` 无因 runner 产生的 diff | 通过 |
| 无自动发送 / 执行 / API / UI / 网络 | 通过（行为检查） |
| sandbox-local 非敏感日志（无正文） | 通过 |
| 无后台残留进程 | 通过 |

详见验收 result：[`option-c-p0-hint-optimization-acceptance-r01-result.md`](option-c-p0-hint-optimization-acceptance-r01-result.md)。

---

## 3. 当前能力（P0）

| 能力 | 说明 |
|------|------|
| 更明确 hints | instruction → 复制 CURSOR 块；result → 复制 CODEX 块；RISK_GATE / SAFE_INDEX_APPLY 提示 |
| 可复制块 | `CURSOR_NEXT_ACTION` / `CODEX_NEXT_ACTION`（含 path、task_id、建议动作；`auto_send: no`） |
| Markdown / JSON 增强 | 分区输出；JSON 含 `copy_blocks`、`safety_summary` |
| sandbox-local 日志 | timestamp / task_id / file_name / hint_type |

**人工**：选中复制 → 粘贴到 Cursor/Codex；关键授权（判责、commit/push、INDEX）仍由人做。

---

## 4. 不允许（硬）

| 禁止 | 说明 |
|------|------|
| 由 P0 **直接升级** P1 / P2 / P3 | 须 [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) + 新签核 |
| 自动发送给 Cursor / Codex | 禁止 |
| 自动执行 instruction | 禁止 |
| 自动判责 | 禁止 |
| 自动写 INDEX / commit / push | 禁止 |
| API / UI 控制 / 网络外呼 | 禁止 |
| 绕过 RISK_GATE | 禁止 |

---

## 5. 推荐使用方式

```text
日常主通道：稳定半自动闭环（文件接力 + 人工判责 + 授权入库）
日常观察主入口：Option B one-shot observer（主仓脚本）
可选辅助：sandbox R1/P0 runner（主仓外；提示 + 可复制块；可 DISABLED）
关键动作：人工复制粘贴、人工授权
```

启动：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\run-readonly-bridge.ps1 -Once
```

---

## 6. 下一阶段选项

| 选项 | 内容 | 注意 |
|------|------|------|
| **A（推荐默认）** | **停在 P0**，日常辅助使用 | 不扩权 |
| **B** | 补 sandbox 备份 / 登记方案（仍主仓外） | 低；另开 instruction |
| **C** | 评估 **P1**（半自动生成待粘贴内容，**人工发送**） | **须重新签核**；见 RISK_EVAL |
| **D** | **P2 hold / P3 reject** | 除非另开高风险 API·权限·审计；不得由 P0 直升 |

---

## 7. 与既有文档关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md) | 本阶段授权依据（P0 Go） |
| [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) | P1+ 门槛；P2 hold、P3 reject |
| [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) | R1 底座；P0 为其上增量 |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | 日常主通道与观察入口不变 |

---

## 8. 相关文件

- [`PROCESS_BRIDGE_PILOT_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_SIGNOFF.md) · [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)  
- [`option-c-p0-hint-optimization-acceptance-r01-result.md`](option-c-p0-hint-optimization-acceptance-r01-result.md)  
- [`PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md`](PROCESS_BRIDGE_SANDBOX_R1_CLOSEOUT.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)  
