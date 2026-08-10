# 高风险 Gate 校验器方案（Automation Step 4）

> **这是什么**：针对 handoff `*-instruction.md` / `*-result.md` 的**只读 / 提示型**风险规则，用于识别应进入或保持 [`STATE.md`](STATE.md) 中 `blocked` 的任务，并在 [`QUEUE.md`](QUEUE.md) 中置顶。  
> **这不是什么**：不是自动执行器；不是自动审批器；不改状态文件；不自动 commit/push；不改 Watcher。  
> **服从**：仓库级风险审批 [`docs/risk-approval.md`](../../risk-approval.md) 与 `AGENTS.md` 高风险人工确认原则。

---

## 1. 目标

在自动化闭环继续加深之前，先固定「什么叫高风险、默认怎么拦、谁能放行」：

1. 从指令正文的 `risk` 字段与关键词/范围提示潜在高风险  
2. 默认建议状态：`blocked`（对应 CURSOR_RESULT 的 `need_confirm` / `blocked`）  
3. **仅人工**可解除 `blocked` 并授权继续执行或入库  

Gate 的输出是**提示与建议**，不是强制进程拦截（脚本化校验属未来 Step，另开任务）。

---

## 2. Gate 不是什么（硬边界）

| 禁止 | 说明 |
|------|------|
| 自动审批 | 不得把「关键词未命中」当成已批准 |
| 自动改状态 | 不写 INDEX / 不改 result 里的 status |
| 自动执行 | 不打开 Agent、不跑业务脚本 |
| 自动 commit / push | 永远需要用户明确授权句 |
| 替代 risk-approval | 详细分级与审批流程以 `docs/risk-approval.md` 为准 |

---

## 3. 高风险范围与关键词（提示表）

命中任一类 → 视为**高风险候选**，建议 `blocked`，直至人工确认。

### 3.1 通用工程高风险

| 类别 | 提示词 / 范围（示例，非穷尽） |
|------|------------------------------|
| 权限 | 权限、RBAC、角色提升、ACL、admin |
| 支付 | 支付、收银、退款、清分、webhook 密钥 |
| 数据库 | 数据库、库表、schema、migration、迁移、DROP、ALTER |
| 用户数据 | 用户数据、PII、导出用户、删除账号、隐私 |
| 鉴权 / 安全 | 鉴权、认证、JWT 密钥、密码哈希、加密密钥、安全漏洞利用 |
| 生产配置 / 发布 | 生产、production、密钥轮转、发布到生产、线上配置 |

指令中 `risk: 高` **直接**视为高风险候选（即使正文未写关键词）。

### 3.2 AICF / 小红书运营链路（本仓协作硬禁默认）

下列内容在 handoff 中出现且意图为**真实执行**时，一律高风险 + 默认 `blocked`，并指向合规入口（不在本文件展开抓取/发布步骤）：

| 类别 | 提示词 / 范围（示例） |
|------|----------------------|
| 发布 | 小红书发布、公开发布、上传笔记 |
| 抓取 | 抓取、复抓、回填、批量平台访问 |
| 账号 | 账号 gate、登录态、cookie、风控账号 |
| 自动化运营 | F4、日更、Freeze30+、P1-A 真跑 |

无完整用户授权句时：**不得**建议执行；Gate 建议保持 `blocked`。

---

## 4. 与 STATE.md 的关系

| 规则 | 说明 |
|------|------|
| 默认状态 | 高风险候选 → `blocked`（不得自动进 `ready_for_cursor` 后「悄悄做完」） |
| 已在执行中发现 | Cursor 应 `status: need_confirm` / `blocked`，INDEX 记 `blocked` |
| 解除 | **仅人工**确认（必要时按 `docs/risk-approval.md` 留痕）后，才可回到 `ready_for_cursor` 或继续判责 |
| 禁止 | 任何脚本/Watcher 自动 `blocked` → `passed` / `committed` / `pushed` |

低风险文档任务（如纯 Markdown）不强制进 Gate；但若混入上表范围，仍按高风险候选处理。

---

## 5. 与 QUEUE.md 的关系

| 规则 | 说明 |
|------|------|
| 优先级 | `blocked`（含高风险待确认）排在待判责队列**最高**档 |
| `suggested_action` | 应为「人工确认风险 / 读 risk-approval」类，**禁止**写「直接执行」 |
| `risk` 列 | 填 `高`；未知但关键词命中可填 `高?` 并在 note 说明 |
| 出队 | 人工放行并更新 INDEX `status` 后，按 STATE 转移，不再因同一未处理风险留在顶栏 |

---

## 6. 与 docs/risk-approval.md 的关系

1. **分级与审批流程**：以 [`docs/risk-approval.md`](../../risk-approval.md) 为准。  
2. **本 Gate**：只提供 handoff 场景下的**识别提示 + 默认 blocked 策略**，不另造一套审批等级。  
3. 冲突时：以 `risk-approval.md` + 用户明文授权为准；Gate 不得放宽。  
4. `AGENTS.md` / Cursor rules 中的「高风险先停」与本文件一致。

---

## 7. 建议检查点（人工或未来只读脚本）

对即将 `ready_for_cursor` 或已落盘的 instruction：

1. 读 `risk:` 字段  
2. 扫 §3 关键词 / AICF 运营范围  
3. 若命中 → 提示「保持/写入 `blocked`，等待人工」  
4. 若不命中 → **不表示批准**，仅表示未触发本表启发式  

未来只读脚本（**另开任务**）应：stdout / 报告 Markdown；默认不改 INDEX；无网络；不引入重依赖。

---

## 8. R0 / R1

| 阶段 | 方式 |
|------|------|
| **R0（当前）** | Codex/Cursor/人工写 instruction 时对照本表；QUEUE 人工置顶高风险 |
| **R1（未来）** | 只读扫描 `risk` + 关键词，生成提示报告；**另开任务**；仍不自动审批 |

---

## 9. 风险闸门（自指）

1. Gate 失败或不确定 → **偏保守**，当 `blocked`  
2. 不自动执行、不自动 commit/push  
3. 不处理 Documents 旁路为锚点  
4. 不给出可绕过合规的「操作步骤」替代授权  

---

## 10. 相关文件

- [`STATE.md`](STATE.md)  
- [`QUEUE.md`](QUEUE.md)  
- [`INDEX.md`](INDEX.md)  
- [`README.md`](README.md)  
- [`docs/risk-approval.md`](../../risk-approval.md)  
- `AGENTS.md`  
- AICF 仓内合规入口（如 RISK/BANNED 文档）：仅原则引用，不在本仓展开执行步骤  
