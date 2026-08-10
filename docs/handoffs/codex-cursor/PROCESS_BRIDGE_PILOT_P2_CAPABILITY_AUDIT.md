# Option C：Pilot P2 API/UI 桥接能力审计

> **这是什么**：对「Codex ↔ Cursor 进程级 / API / UI / 插件桥接」的**只读能力审计**（纸面）。  
> **这不是什么**：不是 P2 实现授权；不写桥接代码；不装插件；不接 API；不做 UI 自动化；不自动发送/执行/判责。  
> **默认结论**：**P2 = hold**。未找到「明确、可审计、默认可关闭自动执行」的**消息桥**接口前，**不得 go**。  
> **UI 自动化 / 键鼠模拟**：默认 **reject**。  
> 服从：[`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md) · [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md) · [`RISK_GATE.md`](RISK_GATE.md)  
> 审计日：2026-08-10 · task：`option-c-p2-api-ui-capability-audit` r01

---

## 1. 审计范围与现状基线

| 已完成（非 P2） | 状态 |
|----------------|------|
| 稳定半自动闭环 + 文件接力 | 日常主通道 |
| Option B one-shot observer | 只读观察 |
| sandbox R1 + Pilot P0/P1 | 提示优化 / 草稿生成；**人工复制粘贴** |
| OpenSpace | **暂不安装**（纸面 hold） |

P1 仍是：**生成草稿 → 人复制/发送**，不是进程级自动互通。  
P2 目标语义（本路线图）：尝试 **本地 API / 插件桥接**，仍禁止自动执行高风险、自动判责、自动入库；须权限与日志审计通过后才可能 go。

---

## 2. 可用桥接路径总览

| # | 路径 | 是否存在官方面 | 对本闭环是否「消息桥」 | 本轮 verdict |
|---|------|----------------|------------------------|--------------|
| A | 文件接力 handoff（现状） | 是（仓库约定） | 是（人工驱动） | **keep**（非 P2） |
| B | 剪贴板 / 人工粘贴 | OS 能力 | 是（人工） | **keep**（P1 配套） |
| C | Watcher / Option B 通知 | 本仓脚本 | 否（只通知） | **keep**（非桥接执行） |
| D | Cursor SDK（`@cursor/sdk` / `cursor-sdk`） | 有（public beta 文档） | **否**（是 Agent **执行**面） | **hold / high** |
| E | Cursor Agent CLI（如 `agent -p` 类） | 有（与 SDK 同生态） | **否**（执行面） | **hold / high** |
| F | Cursor Cloud Agents REST（`/v1/agents` 等） | 有（public beta） | **否**（云端执行 + 触网） | **hold / high** |
| G | Cursor Hooks / extension hook | 有限（产品 hooks 面） | 不明；易变执行钩子 | **hold** |
| H | Codex 官方「投递到 Cursor 对话」API | **未确认**本仓可用、稳定、文档化接口 | — | **hold**（缺接口） |
| I | OpenSpace / 第三方编排 | 未授权安装 | 不明 | **hold**（不装） |
| J | UI 自动化 / 键鼠 / 窗口注入 | 非官方桥 | 伪桥 | **reject** |
| K | 私有协议 / DOM 窥探 / 进程注入 | 非官方 | 伪桥 | **reject** |

**关键澄清**：Cursor 侧现已存在可脚本化的 **Agent SDK/CLI/Cloud API**，但这解决的是「从代码里跑 Cursor Agent」，**不是**「Codex 与 Cursor 之间只传递 `CODEX_INSTRUCTION` / `CURSOR_RESULT` 且默认不执行」。  
把 SDK 当 P2 消息桥 = 极易滑向 **自动执行（P3 语义）** → 在本审计中 **不得标 go**。

---

## 3. 分路径评估

评分列含义：dry-run / 审计日志 / kill switch / 自动发送 / 自动执行 / 触网 / 读密钥 —— 填 **是 / 否 / 不明 / 可建设**。

### A. 文件接力（现状 · 非 P2）

| 项 | 评估 |
|----|------|
| 输入 | handoff 文件 / 粘贴块 |
| 输出 | `CURSOR_RESULT` / judgement 文件 |
| 权限范围 | 仓库文件读写（人工/Agent 会话内） |
| dry-run | 是（只写 docs 即可） |
| 审计日志 | 是（git + handoff + INDEX 人工） |
| kill switch | 是（停粘贴即停） |
| 自动发送 | 否 |
| 自动执行 | 否（默认） |
| 触网 | 否（文件层） |
| 读密钥 | 否（约定） |
| **风险级** | **low** |
| **verdict** | **keep** — 日常主通道 |

### B. 剪贴板 / 人工粘贴（P1 配套）

| 项 | 评估 |
|----|------|
| 输入 | sandbox/P1 草稿块 |
| 输出 | 粘贴进 Cursor/Codex UI |
| 权限 | 剪贴板；无进程注入 |
| dry-run / 日志 / kill | 是 / 弱（人脑） / 是 |
| 自动发送 / 自动执行 | 否 / 否 |
| 触网 / 读密钥 | 否 / 否 |
| **风险级** | **low**（若脚本写剪贴板仍须确认）→ 半自动写「待发送区」升 **medium** |
| **verdict** | **keep** |

### C. Watcher / Option B observer

| 项 | 评估 |
|----|------|
| 输入 | handoff 目录变化 |
| 输出 | 控制台/Toast 提示 |
| 自动发送 / 自动执行 | 否 / 否 |
| 触网 / 读密钥 | 否 / 否 |
| **风险级** | **low** |
| **verdict** | **keep** — 不是 P2 桥 |

### D. Cursor SDK（`Agent.create` / `Agent.prompt` / `agent.send`）

| 项 | 评估 |
|----|------|
| 输入 | 程序构造的 prompt + `CURSOR_API_KEY` + cwd/repo |
| 输出 | Agent run 流 / 结果；可改工作区文件、跑命令 |
| 权限范围 | **宽**：本地 runtime 可达 cwd；cloud runtime 触网与远端 VM |
| dry-run | **不明/默认否**（调用即倾向开跑 Agent；需自建 dry-run 包装） |
| 审计日志 | 可建设（自建）；官方是否满足本仓字段 **不明** |
| kill switch | 部分（cancel run）；**缺**「只投递不执行」一等公民模式 |
| 自动发送 | 是（对 Agent 投递 prompt） |
| 自动执行 | **是**（核心能力） |
| 触网 | local 视工具而定；cloud **是**；鉴权需 API key |
| 读密钥 | **易**（环境变量 `CURSOR_API_KEY`；若包装不当可读 `.env`） |
| **风险级** | **high** |
| **verdict** | **hold** — 存在官方面，但属执行 API，**不满足** P2「消息桥且默认可关执行」；未做权限/日志专项审计前 **no-go** |

### E. Cursor Agent CLI

| 项 | 评估 |
|----|------|
| 输入/输出 | shell 一次性 prompt → 结果 |
| 与 D 关系 | 同生态执行面，脚本友好 |
| dry-run / 自动执行 | 默认执行向；dry-run 须自建 |
| 触网 / 密钥 | 视配置；常需登录或 API key |
| **风险级** | **high** |
| **verdict** | **hold**（同 D） |

### F. Cloud Agents REST API

| 项 | 评估 |
|----|------|
| 输入/输出 | HTTP 创建/查询 agent run |
| 权限 | 云端仓库克隆与远程执行 |
| 触网 | **是** |
| 自动执行 | **是** |
| 读密钥 | API key **是** |
| **风险级** | **high** |
| **verdict** | **hold**；且与「本地低风险文档闭环」目标不匹配 |

### G. Cursor Hooks / IDE extension hook

| 项 | 评估 |
|----|------|
| 输入/输出 | 生命周期钩子（产品文档提及 hooks 能力） |
| 是否消息桥 | **不明**；更偏 Agent 生命周期扩展 |
| 自动执行 | 易变成隐式触发 |
| **风险级** | **medium → high**（取决于钩子动作） |
| **verdict** | **hold** — 未单独审计前不得用作 Codex↔Cursor 投递 |

### H. Codex → Cursor 官方 thread handoff

| 项 | 评估 |
|----|------|
| 现状 | 本仓**未确认**稳定、文档化、可脚本、可关执行的「只投递 instruction」接口 |
| 常见替代 | 人工粘贴 / 文件接力（已有） |
| **风险级** | n/a（接口未确认） |
| **verdict** | **hold** — **缺明确安全接口** |

### I. OpenSpace / 外部编排

| 项 | 评估 |
|----|------|
| 现状 | 纸面 hold；**未安装** |
| **verdict** | **hold** — 不在本审计中放行安装 |

### J. UI 自动化 / 键鼠模拟

| 项 | 评估 |
|----|------|
| 输入/输出 | 模拟点击/粘贴到 IDE 或网页 |
| 权限 | 过宽；焦点漂移即误操作 |
| dry-run / 审计 / kill | 弱 / 弱 / 弱 |
| 自动发送 / 自动执行 | 易变为是 |
| 触网 / 密钥 | 可能 / 可能（UI 含密钥面板） |
| **风险级** | **high** |
| **verdict** | **reject**（默认永久；本路线图） |

### K. 私有协议 / DOM / 进程注入

| 项 | 评估 |
|----|------|
| **verdict** | **reject**（同 [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) 硬禁止） |

---

## 4. 风险分类（对照本仓 P0–P3）

| 等级 | 含义 | 本审计命中路径 |
|------|------|----------------|
| **low** | 只读观察 / 生成草稿 | A、B（人工）、C、已完成的 P0/P1 |
| **medium** | 半自动提交到**本地待发送区**（仍须人确认才进对话/Agent） | 尚未新建；若做须另开签核，且**不得**调用 SDK send |
| **high** | 自动发送、UI 控制、API 调用、自动执行 | D、E、F、J、K；误用 G |

P2 若仅「调用 SDK 把 instruction 丢进 Agent」→ 实际是 **high / 近 P3**，不得用 P2 标签掩盖。

---

## 5. 默认结论（硬）

1. **P2 默认 hold**（与 [`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md) / Pilot 风险方案一致）。  
2. **未找到明确安全「消息桥」接口前，不得 go。**  
   - Cursor SDK/CLI/Cloud API **存在**，但定性为 **Agent 执行面**，不能当作已满足 P2 Go 的安全接口。  
   - Codex→Cursor 官方只投递、不执行的 handoff **未确认**。  
3. **UI 自动化 / 键鼠模拟默认 reject。**  
4. **API / 插件 / SDK 桥接**若将来要做：必须**另开**权限模型 + 日志 + kill switch + dry-run 专项审计与**新签核**；本文件**不授权实现**。  
5. **P3（自动执行 / 自动判责 / 自动入库）仍 reject**，不得由 P2 审计「顺带」放行。

---

## 6. P2 Go 前硬门槛（全部满足才允许离开 hold）

| # | 门槛 | 说明 |
|---|------|------|
| 1 | **明确接口** | 文档化、可版本约束；职责是投递 instruction/result，**不是**默认跑 Agent |
| 2 | **明确权限模型** | 最小读 handoff / 写待发送区；禁止宽 cwd 写、禁止云端默开 |
| 3 | **不自动执行高风险任务** | 默认不触发 Agent run；高风险 / RISK_GATE → blocked |
| 4 | **dry-run 默认** | 未显式关闭 dry-run 不得产生对外副作用 |
| 5 | **人工确认点** | 发送前 / 执行前 / 入库前均须人确认（至少执行前+入库前） |
| 6 | **kill switch** | 默认关闭；一键停；停后文件接力仍可用 |
| 7 | **本地非敏感日志** | task_id / round / 时间 / 动作类型；禁密钥正文 |
| 8 | **不读** `.env` / cookie / token | API key 若必需须显式注入通道 + 不入库 |
| 9 | **不自动 commit/push** | 入库仍须用户授权句 |
| 10 | **不碰 AICF 运营链路** | 不发布/抓取/登录/F4/日更 |
| 11 | **与 P3 隔离** | 不得把「SDK 一键跑 Agent」标成 P2 go |
| 12 | **新签核** | 本审计 ≠ 签核；须独立 `PROCESS_BRIDGE_PILOT_P2_SIGNOFF`（尚未创建） |

任一不满足 → **继续 hold / no-go**。

---

## 7. 可行 vs 不可行（摘要）

### 可行（继续用，非 P2 go）

- 文件接力 + 半自动人工粘贴  
- Option B / Watcher 通知  
- sandbox P0/P1 草稿生成（`DRAFT_ONLY` + `HUMAN_REVIEW_REQUIRED`）

### 暂不可行（hold）

- 以 Cursor SDK/CLI/Cloud API 充当 Codex↔Cursor 消息桥（缺「只投递不执行」一等模式与权限/日志审计）  
- Codex 官方 thread handoff（接口未确认）  
- OpenSpace / 未授权插件  
- Hooks 投递（未专项审计）

### 不可行（reject）

- UI 自动化、键鼠模拟、窗口/DOM/进程注入  
- 任何默认自动执行 / 自动判责 / 自动入库（P3）

---

## 8. 建议下一动作

| 优先级 | 动作 |
|--------|------|
| **1（默认）** | **保持 P2 hold**；日常继续半自动 + Option B + 可选 P1 草稿 |
| 2 | 若产品侧出现「只投递文件/剪贴板、默认不 run Agent」的官方桥 → **另开**接口对照审计（仍不自动实现） |
| 3 | 若有人提议接入 SDK → **先**权限/日志/kill-switch 专项，**默认仍 hold** |
| 停 | 不装插件、不接 API、不做 UI 自动化、不写 P2 实现、不升 P3 |

---

## 9. 相关文件

- [`FINAL_LOOP_AUTOMATION_CLOSEOUT.md`](FINAL_LOOP_AUTOMATION_CLOSEOUT.md)  
- [`PROCESS_BRIDGE_PILOT_RISK_EVAL.md`](PROCESS_BRIDGE_PILOT_RISK_EVAL.md)  
- [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
- [`PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md`](PROCESS_BRIDGE_PILOT_P1_CLOSEOUT.md)  
- [`docs/p3-openspace-paper-eval-report.md`](../../p3-openspace-paper-eval-report.md)  
- 公开参考（审计引用，非安装授权）：[Cursor TypeScript SDK](https://cursor.com/docs/sdk/typescript) · [SDK 发布说明](https://cursor.com/blog/typescript-sdk)

---

## 10. 审计签字栏（纸面）

| 项 | 值 |
|----|-----|
| decision | **hold** |
| UI 自动化 | **reject** |
| 实现授权 | **无** |
| 可标 P2 go？ | **否** |
