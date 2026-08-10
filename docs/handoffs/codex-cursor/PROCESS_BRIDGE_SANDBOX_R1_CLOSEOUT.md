# Option C Step 9：只读桥接 Sandbox R1 阶段收口

> **R1 结论**：**sandbox R1 可用**；范围仍为 **`readonly_hint_only`**；**不升级 `pilot`**。  
> **位置**：主仓外 `D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`（**不纳入**主仓 git）。  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) 稳定半自动闭环；日常观察主入口仍是 Option B [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)。  
> 相关：[`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`PROCESS_BRIDGE_SANDBOX_RUNNER_PLAN.md`](PROCESS_BRIDGE_SANDBOX_RUNNER_PLAN.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) · 验收 [`option-c-sandbox-runner-r1-acceptance-r01-result.md`](option-c-sandbox-runner-r1-acceptance-r01-result.md)

---

## 1. 阶段结论

| 项 | 值 |
|----|-----|
| 决策阶梯 | 纸面 `sandbox` → 已落地 **R1 最小 runner** |
| 可用性 | **可用**（人工启动、只读提示） |
| 范围 | `readonly_hint_only` |
| 可否升 `pilot` | **否** — 不得由本收口直接升级 |

---

## 2. 已验证（验收固化）

| 检查项 | 结果 |
|--------|------|
| 文件存在：README / `run-readonly-bridge.ps1` / `config.example.json` / `logs\` | 通过 |
| `-Once` 可运行 | 通过 |
| `-Json` 可解析（`status=ok`） | 通过 |
| `DISABLED` 存在时立即退出；验证后删除 | 通过 |
| 日志仅在 sandbox `logs\`；字段限 timestamp / task_id / file_name / hint_type | 通过 |
| 主仓 scripts / `INDEX.md` 无因 runner 产生的 diff | 通过 |
| 无 `run-readonly-bridge` 后台残留进程 | 通过 |
| 行为上无 API / UI 控制 / 自动执行 instruction | 通过（行为检查） |

验收记录：[`option-c-sandbox-runner-r1-acceptance-r01-result.md`](option-c-sandbox-runner-r1-acceptance-r01-result.md)。

---

## 3. 当前能力

| 能力 | 说明 |
|------|------|
| 读 handoff | 只读扫描主仓 `*-instruction.md` / `*-result.md`（文件名 / mtime / task_id） |
| 读 observer | 本地子进程调用主仓 `show-codex-cursor-loop-status.ps1 -Json` |
| 本地 hints | 如交给 Cursor / Codex、先看 RISK_GATE、按 SAFE_INDEX_APPLY 考虑 INDEX |
| 可复制命令 | stdout 输出 observer / queue 等一行命令 |
| sandbox-local 日志 | 非敏感；不进主仓 |

---

## 4. 当前边界（硬）

| 禁止 | 说明 |
|------|------|
| 自动执行 instruction | 不打开 / 控制 Cursor·Codex Agent |
| 自动判责 | 不替代 Codex |
| 写 INDEX / 写主仓 | 主仓只读引用 |
| commit / push | 不由 sandbox 触发 |
| API / UI / 网络外呼 | 默认禁止 |
| AICF 运营链路 | 禁止 |
| 升 `pilot` | 须另开高风险评估，**不能**由 R1 直接升级 |

签核见 [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md)。

---

## 5. 推荐使用方式

```text
日常主通道：稳定半自动（instruction → Cursor result → 判责 → 人工授权 commit/push）
日常观察主入口：Option B one-shot observer（主仓内脚本）
可选辅助：本 sandbox runner（主仓外；提示 / 可复制命令；可 DISABLED 关闭）
```

sandbox **不替代**文件接力，也**不替代** Option B。

启动示例：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\run-readonly-bridge.ps1 -Once
```

---

## 6. 下一阶段选项

| 选项 | 内容 | 注意 |
|------|------|------|
| **A（推荐默认）** | **停在 R1**，仅作日常辅助观察 | 不扩权 |
| **B** | 补 sandbox README / 备份登记（仍主仓外） | 低；另开 instruction |
| **C** | 评估 R2 **提示优化**（文案、摘要、提示优先级等） | 仍**禁止**自动执行 |
| **D** | 若要 `pilot` | **必须另开高风险评估**（RISK_GATE + PROCESS_BRIDGE_EVAL）；**不能**由 R1 直接升级 |

---

## 7. 与既有文档关系

| 文档 | 关系 |
|------|------|
| PROCESS_BRIDGE_PAPER_DECISION | 决策仍为 `sandbox`，非 `pilot` |
| PROCESS_BRIDGE_SANDBOX_PLAN / RUNNER_PLAN | R1 已按方案落地并验收 |
| PROCESS_BRIDGE_SANDBOX_SIGNOFF | Go 仍限定 readonly_hint_only |
| STABLE_SEMI_AUTO_CLOSEOUT | 主通道收口不变 |
| ONE_SHOT_OBSERVER | 日常主观察入口 |

---

## 8. 相关文件

- 验收：[`option-c-sandbox-runner-r1-acceptance-r01-result.md`](option-c-sandbox-runner-r1-acceptance-r01-result.md)  
- [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`PROCESS_BRIDGE_SANDBOX_RUNNER_PLAN.md`](PROCESS_BRIDGE_SANDBOX_RUNNER_PLAN.md)  
- [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)  
- [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`RISK_GATE.md`](RISK_GATE.md)  
