# Option C Step 2：只读/提示型桥接 Sandbox 方案

> **这是什么**：在**主仓外**做隔离实验，用只读监听 + 本地提示，验证能否减少手抄 instruction/result、降低漏接，同时**绝不**自动执行。  
> **这不是什么**：不是正式接入；不自动执行 instruction；不自动判责；不自动写 INDEX；不自动 commit/push；不接 AICF 运营链路。  
> **本轮只定方案**：不写 sandbox 代码、不创建 sandbox 目录、不接 API、不安装工具。  
> 服从：[`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md)（结论 `sandbox`）· [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md) · [`RISK_GATE.md`](RISK_GATE.md)  
> 日常仍用：[`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md) + [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md)

---

## 1. 目标

用最小实验回答：

1. 能否从 handoff 文件变化生成**可读提示**与**可复制命令/块**？  
2. 能否提示「下一步交给 Cursor / Codex / 人工」而不开跑 Agent？  
3. 失败或关闭后，主仓与半自动路径是否完全不受影响？  

成功 = 提示可用 + 可一键停止 + 主仓零写入；**不是**「已经自动跑任务」。

---

## 2. 建议实验位置（主仓外）

| 项 | 约定 |
|----|------|
| 推荐根目录 | `D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\` |
| 主仓 | `D:\AIContentFactory\三方闭环整合项目`（**只读引用** handoff / 脚本；sandbox **不得写回**） |
| 禁止锚点 | `Documents\ChatGPT + Cursor 工作流` 等旁路；不得当作 repo / sandbox 根 |

建议子目录（实现时再创建，本轮不建）：

```text
D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\
  README.md                 # 本地说明（可选）
  config\
    enabled.flag            # kill switch：文件存在且内容为 "1" 才允许跑；默认不存在=关闭
  logs\                     # 本地只读日志（gitignore / 勿提交主仓）
  out\                      # 生成的提示 Markdown / 可复制块（仅 sandbox 内）
  bin\                      # 未来 sandbox 脚本（另开任务才写）
```

---

## 3. 输入（只读）

| 输入 | 来源 | 约束 |
|------|------|------|
| handoff instruction / result | 主仓 `docs/handoffs/codex-cursor/*-instruction.md` / `*-result.md` | **只读**打开；不改、不删 |
| one-shot observer 输出 | 人工或子进程跑主仓 `scripts/show-codex-cursor-loop-status.ps1`（可 `-Json`） | 只消费 stdout |
| queue / INDEX 建议 | `list-codex-cursor-queue.ps1` / `suggest-codex-cursor-index.ps1` | 只读；**不** apply INDEX |

可选：指向主仓路径的配置项（如 `RepoRoot`），默认上述主仓绝对路径。

---

## 4. 输出（仅 sandbox 内 / stdout）

| 输出 | 说明 |
|------|------|
| 本地提示 | 人类可读：发现了哪个 task_id、instruction 还是 result、建议下一步 |
| 可复制命令 | 例如 observer / queue 的 PowerShell 一行命令（进程级 Bypass） |
| 可复制 CODEX / CURSOR 块 | 从文件摘录或生成粘贴用摘要（非自动投递） |
| 本地只读日志 | 见 §7；**不得**含敏感内容 |

默认打印到 stdout；若写文件，**仅**写在 sandbox 的 `logs\` / `out\`，永不写主仓。

---

## 5. 禁止事项（硬）

1. 打开 / 控制 Cursor 或 Codex **自动执行**  
2. 调用 Codex / Cursor **API**（含未授权网络 MCP）  
3. 读取 `.env` / cookie / token / 账号材料  
4. **写主仓任何文件**（含 INDEX、handoff、watcher state/lock）  
5. `git commit` / `git push`（主仓或 sandbox 均不由本实验触发）  
6. 网络外呼（除非未来另开任务并完整授权；本方案默认 **禁网**）  
7. UI 点击、键鼠模拟、非官方进程注入  
8. 接 AICF 运营链路（抓取 / 发布 / F4 / 日更等）  
9. 将 Documents 旁路当锚点  

---

## 6. Kill switch

| 项 | 约定 |
|----|------|
| 默认 | **关闭**；无人工启动则不跑 |
| 文件开关 | `config\enabled.flag`：仅当存在且首行 trim 后为 `1` 时允许启动；删除或改为 `0` = 禁用 |
| 进程停止 | 前台运行；`Ctrl+C` 退出；**禁止**安装成常驻 Windows 服务；若用轮询，须单实例 + 退出即停 |
| 预期 | 停止后 **无残留后台进程**；不改主仓；sandbox 日志可保留或按 §9 清理 |

实现时须在启动横幅打印：`readonly sandbox; kill switch=...; will not execute agents`。

---

## 7. 日志与隐私

| 允许记录 | 禁止记录 |
|----------|----------|
| task_id、round、文件名、mtime、事件类型（instruction/result） | 密钥、token、cookie、密码 |
| 生成的提示摘要（截断） | `.env` 全文、账号 cookie 路径内容 |
| 时间戳、是否因 kill switch 拒绝启动 | 完整仓库无关隐私文件内容 |

日志路径（建议）：`D:\AIContentFactory\sandbox\codex-cursor-bridge-readonly\logs\YYYYMMDD.log`  
编码 UTF-8；仅追加；不进主仓 git。

---

## 8. 建议最小行为（未来实现时）

```text
1. 检查 kill switch → 关闭则退出 0 并提示
2. 只读扫描主仓 handoff（或监听文件变更，仍只读）
3. （可选）调用主仓 observer / queue / suggest，捕获 stdout
4. 在 stdout 与 sandbox\out\ 生成提示 + 可复制命令/块
5. 写 sandbox\logs\ 一行审计
6. 不打开 Agent；不写主仓；不触网
```

轮询间隔若需要：≥ 数秒级；须 debounce；**默认人工单次运行**优先于常驻轮询。

---

## 9. 验收标准（sandbox 实现任务用）

全部满足才算 sandbox R1 通过：

1. 能读 handoff 文件并生成提示  
2. 能显示下一步建议（Cursor / Codex / 人工 / RISK_GATE / SAFE_INDEX_APPLY 指向）  
3. **不写主仓**（`git status` 在主仓无因本实验产生的改动）  
4. **不触网**（默认配置下无外呼）  
5. 停止后无残留后台进程  
6. kill switch 默认关闭；关闭时不生成副作用（或仅打印「disabled」）  

---

## 10. 进入实现门槛（全部满足才可另开 implement）

| # | 门槛 |
|---|------|
| 1 | 本方案已入库（本文件进主仓 docs） |
| 2 | **单独授权**创建/使用 sandbox 目录（本轮明确：**不**自动创建） |
| 3 | 实现 instruction 写明：**只读命令**示例与工作目录 |
| 4 | 明确日志位置（§7）与 **清理方式**（删 `logs\` / `out\`；关 flag；杀进程） |
| 5 | 重申禁止项与「非 pilot」；命中 [`RISK_GATE.md`](RISK_GATE.md) 则只提示 blocked，不执行 |
| 6 | 不改主仓脚本为「正式桥接」；若需薄封装，代码只落在 sandbox `bin\` |

未满足 → 不得写桥接/sandbox 代码。

---

## 11. 与纸面决策的关系

| 决策文件 | 本方案 |
|----------|--------|
| PAPER：`sandbox` | 本文件 = 最小实验范围定义 |
| 不可跳级到 `pilot` | 即使 sandbox 做完，正式互通仍须新评估 |
| Option B | 仍是主仓内推荐日常入口；sandbox 为可选加速验证 |

---

## 12. 清理方式（实现后人工可做）

```text
1. 删除或改写 config\enabled.flag → 0
2. 结束相关 powershell 进程（确认无残留）
3. 可选删除 logs\ 与 out\
4. 主仓 git status 应与实验前一致（无本实验写入）
```

---

## 13. 相关文件

- [`PROCESS_BRIDGE_PAPER_DECISION.md`](PROCESS_BRIDGE_PAPER_DECISION.md) · [`PROCESS_BRIDGE_EVAL.md`](PROCESS_BRIDGE_EVAL.md)  
- [`ONE_SHOT_OBSERVER.md`](ONE_SHOT_OBSERVER.md) · [`RISK_GATE.md`](RISK_GATE.md) · [`SAFE_INDEX_APPLY.md`](SAFE_INDEX_APPLY.md)  
- [`STABLE_SEMI_AUTO_CLOSEOUT.md`](STABLE_SEMI_AUTO_CLOSEOUT.md)  
- 主仓脚本（只读调用，未来）：`scripts/show-codex-cursor-loop-status.ps1` · `list-codex-cursor-queue.ps1` · `suggest-codex-cursor-index.ps1`  
