# Option C：Pilot P1 草稿生成阶段收口

> **P1 结论**：**Pilot P1 可用**；仅为 **`draft_generation_only`**（生成带水印的待粘贴草稿）；**不是**真正自动闭环。  
> **不可**：由本收口**自然升级**到 **P2 / P3**（API/UI、自动发送、自动执行或自动判责属高风险，须另开审计与签核；默认 **hold / reject**）。  
> 远端语境锚点：`59d9ab9`（P1 验收后 tip 可能前移；语义以「P1 已验收」为准）。  
> sandbox 仍在主仓外：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\`（**不纳入**主仓 git）。  
> 签核：[`PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md)  
> 验收：[`option-c-p1-draft-generation-acceptance-r01-result.md`](option-c-p1-draft-generation-acceptance-r01-result.md)  
> 服从：[`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md) · [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md)  
> **不替代**：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)；日常观察主入口仍是 Option B [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)

---

## 1. 阶段结论

| 项 | 值 |
|----|-----|
| Level | **P1**（`draft_generation_only`） |
| 可用性 | **可用**（人工启动 sandbox runner） |
| 本质 | 生成 `DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED` 草稿 → **人复制发送** |
| 是否自动闭环 | **否** |
| 可否升 P2/P3 | **否（默认）** — P2 **hold**；P3 **reject**；不得由 P1 自然继续 |

已完成链路（至此收口）：稳定半自动闭环 → Option B 一键观察 → sandbox R1 → Pilot P0 → Pilot P1（本文件）。

---

## 2. 已验证

| 检查项 | 结果 |
|--------|------|
| Markdown：`## Draft Paste Blocks` | 通过 |
| `CURSOR_EXECUTION_DRAFT` / `CODEX_JUDGEMENT_DRAFT` | 通过 |
| 水印：`DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED` | 通过 |
| **无**最终 `decision: pass` | 通过 |
| JSON：`draft_paste_blocks`；每块 `human_review_required=true` | 通过 |
| `DISABLED` kill switch | 通过 |
| 主仓 scripts / `INDEX.md` 无因 runner 产生的 diff | 通过 |
| 无自动发送 / 执行 / API / UI / 网络 / 自动 final pass | 通过（行为检查） |
| sandbox 日志无正文/草稿全文 | 通过 |
| 无后台残留进程 | 通过 |

详见：[`option-c-p1-draft-generation-acceptance-r01-result.md`](option-c-p1-draft-generation-acceptance-r01-result.md)。

---

## 3. 当前能力（P1）

| 能力 | 说明 |
|------|------|
| 草稿生成 | `CURSOR_EXECUTION_DRAFT`、`CODEX_JUDGEMENT_DRAFT` |
| 建议决策 | 仅 `review_needed` / `need_confirm`（高风险强制后者） |
| 发送方式 | **人工**选中复制 → 粘贴到 Cursor/Codex |
| 叠加 P0 | 仍保留 hints / NEXT_ACTION 复制块 |
| 日志 | sandbox-local；timestamp / task_id / file_name / hint_type |

关键动作（判责、commit/push、INDEX、是否真正执行）**仍由人做**。

---

## 4. 不允许（硬）

| 禁止 | 说明 |
|------|------|
| 误以为已进入真正自动闭环 | P1 ≠ 无人值守互通 |
| 由 P1 **自然升级** P2 / P3 | 触碰 API/UI、自动发送、自动执行、自动判责 → 高风险 |
| 自动发送 / 自动执行 | 禁止 |
| 自动最终 `pass` 判责 | 禁止 |
| API / UI / 网络外呼 | 禁止 |
| 写主仓 / INDEX / commit / push | 禁止 |
| 绕过 RISK_GATE | 禁止 |

---

## 5. 推荐使用方式

```text
日常主通道：稳定半自动闭环（文件接力 + 人工判责 + 授权入库）
日常观察主入口：Option B one-shot observer
可选辅助：sandbox R1 / P0 / P1 runner（主仓外）
  → 看 hints / copy blocks / draft paste blocks
  → 人工复制草稿并自行发送
  → 人工判责与入库授权
```

启动：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\run-readonly-bridge.ps1 -Once
```

---

## 6. 下一阶段选项

| 选项 | 内容 | 注意 |
|------|------|------|
| **A（强烈推荐）** | **停在 P1**，日常辅助使用；不扩权 | 默认 |
| **B** | 补 sandbox 备份 / 登记 / README 维护（仍主仓外） | 低；另开 instruction |
| **C** | 小幅优化 P1 草稿文案（仍 `draft_generation_only`） | 不得引入发送/执行 |
| **D** | P2 / P3 | **不建议继续**；P2 hold、P3 reject；若执意须另开**高风险**评估 + 新签核，**禁止**由本收口默认开工 |

---

## 7. 与既有文档关系

| 文档 | 关系 |
|------|------|
| [`PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md) | 本阶段授权依据 |
| [`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md) | P1 风险与防线 |
| [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) | P0 收口；P1 为其上已完成增量 |
| [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) | 总分级：P2 hold、P3 reject |
| [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) | 日常主通道不变 |

---

## 8. 相关文件

- [`PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md`](PROCESS_BRIDGE_PILOT_P1_SIGNOFF.md) · [`PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_P1_RISK_EVAL.md)  
- [`option-c-p1-draft-generation-acceptance-r01-result.md`](option-c-p1-draft-generation-acceptance-r01-result.md)  
- [`PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P0_CLOSEOUT.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)  
