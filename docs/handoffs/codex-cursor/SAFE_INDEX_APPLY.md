# 安全写入 INDEX：人工确认流程方案（Automation Step 16）

> **这是什么**：把「`suggest-codex-cursor-index.ps1` 只读建议 → 人工挑选 → 安全写入 [`INDEX.md`](INDEX.md)」的门槛与检查写死。  
> **这不是什么**：不是自动 apply 器；不自动判责；不自动 commit/push；不绕过 [`RISK_GATE.md`](RISK_GATE.md)。  
> 输入来自 [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md) / [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)；状态服从 [`STATE.md`](STATE.md)。  
> **本轮只定方案，不写 apply 脚本、不改 INDEX。**

---

## 1. 端到端流程

```text
1. 运行只读建议：
   powershell -NoProfile -ExecutionPolicy Bypass -File scripts\suggest-codex-cursor-index.ps1
2. 人工阅读 suggestions + warnings
3. 勾选「允许写入」的行（默认识别：宁少勿错）
4. 写入前检查（§4）——全部通过才可改 INDEX
5. 按 R0/R1/R2 方式写入（§3）
6. 写入后检查（§5）
7. 若需入库：另要用户明确授权 commit / push（本流程不包含）
```

---

## 2. 明确不是什么

| 禁止 | 说明 |
|------|------|
| 静默全量 apply | 不得把脚本全部 `add` 行一次性写入 |
| 自动判责 | 写入 INDEX ≠ `CODEX_JUDGEMENT` |
| 自动 commit/push | INDEX 变更后仍须另授 |
| 绕过 RISK_GATE | 高风险行默认不写入，或仅以 `blocked` 记且经人工确认 |
| 脚本改业务代码 | apply 范围仅限 `INDEX.md`（未来 R2 亦然） |

---

## 3. R0 / R1 / R2

| 阶段 | 方式 | 写文件？ |
|------|------|----------|
| **R0（当前）** | 人工从建议表复制选中行到 [`INDEX.md`](INDEX.md) | 人工编辑 |
| **R1（未来）** | 脚本生成 **patch preview**（stdout / gitignore 临时文件）；**不写** INDEX | 否 |
| **R2（未来）** | 在用户明确确认清单后，脚本**仅**写入 `INDEX.md`；仍不 commit/push | 仅 INDEX |

R1/R2 实现均须**另开 instruction**；默认参数应 fail-closed（无确认列表则退出）。

---

## 4. 写入前检查（强制）

任一项失败 → **整批或该行**不得写入。

### 4.1 状态与路径

| 检查 | 规则 |
|------|------|
| `status` | 必须属于 [`STATE.md`](STATE.md) 枚举 |
| `result` / `result_path` | 若非 `-`，对应文件须在 handoff 目录存在 |
| `task_id` + `round` | 非空；与文件名一致为佳 |
| 重复键 | 同 `task_id|round` 不得在 INDEX 出现第二行（更新则改原行，不叠行） |

### 4.2 commit / push 字段

| 字段 | 允许值 |
|------|--------|
| `commit` | `-`，或短/长 hex hash（建议 `[0-9a-f]{7,40}`）；勿填随意中文 |
| `push` | `yes` / `no` / `n/a`（与 INDEX 既有约定一致；勿发明新枚举） |

无 tip 证据时：`commit=-`，`push=no`。

### 4.3 必须人工确认才能写入的场景

出现任一情形，须**单独口头/书面确认**（不能批量默许）：

1. 高风险任务（[`RISK_GATE.md`](RISK_GATE.md) 命中或 `risk: 高`）  
2. 试图把 `status` **从 `blocked` 改出**  
3. 重复 `task_id`（含跨 round 的异常重复意图）  
4. 缺字段（无 result、无验收相关 note 等）  
5. 单次写入超过 **N=10** 行（拆批或二次确认）  

---

## 5. 写入后检查（强制）

```powershell
git diff -- docs/handoffs/codex-cursor/INDEX.md
git status --short
```

通过标准：

- diff **仅**涉及 `INDEX.md`（本步骤）  
- 无脚本被改、无 `.watcher-*` / 临时 runtime 被加入  
- 表格式未破坏（表头/分隔行仍在）  
- 抽查：新行 status 合法、链接可点  

未通过 → `git restore -- docs/handoffs/codex-cursor/INDEX.md` 回退后再议。

---

## 6. 与已有文件的关系

| 文件 | 关系 |
|------|------|
| STATE | 合法 status 唯一来源 |
| RISK_GATE | 高风险写入门槛；不批准执行运营动作 |
| INDEX_UPDATE_HELPER + suggest 脚本 | 只读输入；本文件管「如何安全落盘」 |
| QUEUE / 判责半自动 | INDEX 更新不替代判责 |
| Watcher | 不参与 apply |

---

## 7. R0 操作清单（当前可用）

1. 跑 `suggest-codex-cursor-index.ps1`，保存输出到笔记（可选）  
2. 删除/忽略不想写入的 `add` 行  
3. 对 §4.3 场景逐条确认  
4. 手工编辑 INDEX（建议新行置顶）  
5. 跑 §5 检查  
6. 需要入库时另要「同意 commit / 同意 push」  

---

## 8. 风险闸门

1. 无人工确认清单 → 禁止 R2 写入  
2. 禁止自动 commit/push  
3. 禁止 Documents 旁路、跨仓静默 apply  
4. AICF 运营相关行默认不写入，除非合规授权且 status 合理（多为 `blocked`）  

---

## 9. 相关文件

- [`INDEX.md`](INDEX.md) · [`STATE.md`](STATE.md) · [`RISK_GATE.md`](RISK_GATE.md)  
- [`INDEX_UPDATE_HELPER.md`](INDEX_UPDATE_HELPER.md)  
- [`scripts/suggest-codex-cursor-index.ps1`](../../../scripts/suggest-codex-cursor-index.ps1)  
- [`AUTOMATION_STEPS_CLOSEOUT.md`](AUTOMATION_STEPS_CLOSEOUT.md)  
