# Option C Step 6：只读桥接 Sandbox 最小 Runner 实现方案

> **这是什么**：主仓外 sandbox 内的**本地只读提示脚本**方案——读 handoff / one-shot observer 输出，生成本地提示与可复制命令。  
> **这不是什么**：不自动执行 instruction；不控制 Cursor/Codex UI；不调用 Codex/Cursor API；不写主仓 / INDEX；不 commit/push；不联网。  
> **本轮只定方案**：不创建 sandbox 目录、不写 runner。  
> 签核：[`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md)（`go` / `readonly_hint_only`）  
> 服从：[`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)

---

## 1. 目标

实现时用**最小** PowerShell runner 验证：

1. 能只读发现近期 instruction / result  
2. 能复用主仓 one-shot observer 只读输出  
3. 能打印「下一步交给谁」的提示与可复制命令  
4. 失败或 kill switch 后主仓零写入、无残留进程  

成功 ≠ 自动跑 Agent。

---

## 2. 建议目录结构（主仓外；实现时再创建）

```text
D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\
  README.md                 # 本地用法与禁止项（sandbox 内）
  run-readonly-bridge.ps1   # 最小 runner（人工启动）
  config.example.json       # 配置样例；本地可复制为 config.json（勿提交主仓）
  DISABLED                  # 可选 kill switch 文件：存在则立即退出
  logs\                     # sandbox-local 非敏感日志
```

| 路径 | 说明 |
|------|------|
| sandbox 根 | 签核 `sandbox_path`；**不在**主仓 git 内 |
| 主仓 | `D:\AIContentFactory\三方闭环整合项目` — **只读**引用 handoff 与 observer 脚本 |
| 禁止 | Documents 旁路作锚点 |

本方案入库时**不**创建上述目录。

---

## 3. Runner 行为（建议）

### 3.1 启动

- **仅人工启动**（前台 PowerShell）；不装服务、不定时任务（除非未来另授）  
- 启动时检查 kill switch（§5）；禁用则打印 `disabled` 并 `exit 0`  
- 横幅须含：`readonly sandbox; will not execute agents; no network`

### 3.2 读取（只读）

| 输入 | 方式 |
|------|------|
| 主仓 handoff | 读 `handoff_dir` 下 `*-instruction.md` / `*-result.md` 的**文件名、mtime、task_id/round（轻量解析）**；**不**改文件 |
| one-shot observer | 子进程调用主仓 `scripts\show-codex-cursor-loop-status.ps1`（可 `-Json`），只消费 stdout |
| （可选）queue 摘要 | 已含于 observer；不必再写主仓脚本 |

禁止读取：`.env`、cookie、token、账号材料、主仓无关隐私文件正文。

### 3.3 输出提示（stdout + 可选 sandbox 文件）

| 观察 | 提示 |
|------|------|
| 有待处理 / 新 instruction | 交给 **Cursor**；附可复制「打开/粘贴 instruction」类提示（非自动打开） |
| 有 result 待判责 | 交给 **Codex** 判责；可附 `list-codex-cursor-queue.ps1` 命令行 |
| observer 含 `need_confirm` | **先看** [`RISK_GATE.md`](RISK_GATE.md)，再判责 / 写 INDEX |
| 有 INDEX suggestions | 提示按 SAFE_INDEX_APPLY（**不**自动写） |
| 无明显项 | 提示当前无待处理 |

同时输出**可复制命令**示例（进程级 Bypass），例如：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File "<repo_root>\scripts\show-codex-cursor-loop-status.ps1"
```

默认 stdout；若落盘，仅 `logs\` 或 sandbox 内 `out\`（若未来增加），**永不写主仓**。

### 3.4 模式建议

优先 **单次运行**（跑完退出）。若实现轮询，须：debounce、可 `Ctrl+C`、单实例、默认关闭；本最小方案推荐先做单次。

---

## 4. Config

建议 `config.example.json` 字段：

| 字段 | 含义 | 示例 |
|------|------|------|
| `repo_root` | 主仓根（只读） | `D:\\AIContentFactory\\三方闭环整合项目` |
| `handoff_dir` | handoff 目录 | `{repo_root}\\docs\\handoffs\\codex-cursor` |
| `log_dir` | sandbox 日志目录 | `D:\\AIContentFactory\\sandbox\\codex-cursor-bridge-readonly\\logs` |
| `disabled_file` | kill switch 文件路径 | 同目录下 `DISABLED` |

规则：

- 缺省可用上述绝对路径；`config.json` 仅存在于 sandbox（gitignore / 不进主仓）  
- runner **忽略**任何「执行 Agent / 联网 / 写主仓」类扩展字段  

---

## 5. Kill switch

| 方式 | 行为 |
|------|------|
| 停止 PowerShell 进程 | `Ctrl+C` / 结束窗口；停止后无后台残留 |
| 删除 / 重命名 runner | `run-readonly-bridge.ps1` 不存在即无法启动 |
| `DISABLED` 文件 | **存在则立即退出**（不写主仓、尽量不写日志或只记一行 disabled） |

与签核一致：`stop process / delete sandbox runner`；清理可含删除整个 sandbox 目录。

---

## 6. 日志（sandbox-local）

| 允许 | 禁止 |
|------|------|
| 时间戳 | 密钥、token、cookie、密码 |
| `task_id` / `round` | instruction/result **正文**（尤其含敏感词时） |
| 文件路径 / 文件名 | `.env` 内容 |
| 提示类型（如 `hint_cursor` / `hint_codex` / `hint_risk_gate`） | 网络请求体、账号材料 |

路径：签核 `log_path` = `D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\logs`  
编码 UTF-8；追加写入；不进主仓 git。

---

## 7. 禁止事项（硬；与签核一致）

1. 自动执行 instruction  
2. 控制 Cursor/Codex UI  
3. 调用 Codex/Cursor API / 网络外呼  
4. 写主仓文件或 INDEX  
5. git commit / push  
6. 读 `.env` / cookie / token  
7. 触碰 AICF 运营 / 发布链路  
8. Documents 旁路锚点  

---

## 8. 验收标准（实现任务用）

| # | 标准 |
|---|------|
| 1 | 不创建 / 修改**主仓**文件（实现轮主仓仅允许 handoff **result 回传**，见 §9） |
| 2 | 不读 `.env` / cookie / token |
| 3 | 不触网 |
| 4 | 停止后无后台残留进程 |
| 5 | 日志仅含 task_id、路径、时间、提示类型等，**不含**正文敏感内容 |
| 6 | `DISABLED` 存在时立即退出 |
| 7 | 能根据 instruction/result/need_confirm 打出对应提示与可复制命令 |

---

## 9. 实现门槛与改动边界

| # | 门槛 |
|---|------|
| 1 | **本方案已入库** |
| 2 | 用户**另发明确实现指令**（本文件不自动开工） |
| 3 | 实现范围**限 sandbox 目录**（创建目录、README、ps1、config.example、logs） |
| 4 | **主仓**实现轮：只允许新增/更新 handoff **result**；**不**把 runner 写进主仓 `scripts\` |
| 5 | 服从签核 [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) |

未满足 → 不得创建 sandbox、不得写 runner。

---

## 10. 建议实现后的人工命令（预告）

```powershell
# 在 sandbox 目录（实现后）
powershell -NoProfile -ExecutionPolicy Bypass -File .\run-readonly-bridge.ps1

# 禁用
New-Item -ItemType File -Path .\DISABLED -Force
# 或结束该 PowerShell 进程 / 删除 run-readonly-bridge.ps1
```

进程级 Bypass；不改系统 ExecutionPolicy。

---

## 11. 相关文件

- [`PROCESS_BRIDGE_SANDBOX_SIGNOFF.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF.md) · [`PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md`](PROCESS_BRIDGE_SANDBOX_SIGNOFF_TEMPLATE.md)  
- [`PROCESS_BRIDGE_SANDBOX_PLAN.md`](PROCESS_BRIDGE_SANDBOX_PLAN.md) · [`PROCESS_BRIDGE_SANDBOX_READINESS.md`](PROCESS_BRIDGE_SANDBOX_READINESS.md)  
- [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
- 主仓只读调用（实现时）：`scripts/show-codex-cursor-loop-status.ps1`  
