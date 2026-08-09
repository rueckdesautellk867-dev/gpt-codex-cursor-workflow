# Codex ↔ Cursor Watcher MVP 方案

> **状态**：方案已定，**未实现代码**。  
> 依据：`watcher-mvp-design` 判责通过后的入库文档。  
> 相关：[`docs/codex-cursor-loop.md`](codex-cursor-loop.md) §3B · [`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md)

## 1. 要解决什么

文件接力目录已就绪，但仍依赖人工「看见新文件 → 打开对话 → 粘贴」。  
Watcher MVP 只做一件事：**监视 handoff 目录，在 instruction / result 稳定落盘后发出通知**，降低漏接。

**不做自动执行、不自动 commit、不自动调用 Codex / Cursor API。**

## 2. 目标形态

```text
Codex/人工 写入 *-instruction.md
        ↓
Watcher 检测「稳定落盘」
        ↓
通知（日志 / 可选桌面提示）+ 打印绝对路径与建议动作
        ↓
人工或 Cursor 打开文件执行 → 写入 *-result.md
        ↓
Watcher 再通知：result 可读，交给 Codex 判责
```

与协议关系：

- 不替代 `docs/codex-cursor-loop.md`；只增强 §3B 文件接力的可发现性
- 分工不变：执行在 Cursor，判责在 Codex，授权在人工
- 命名与生命周期以 `docs/handoffs/codex-cursor/README.md` 为准

## 3. 监视范围

| 项 | MVP 约定 |
|----|----------|
| 根目录 | `D:\AIContentFactory\三方闭环整合项目\docs\handoffs\codex-cursor\` |
| 匹配 | `*-instruction.md`、`*-result.md`（可选：`*-judgement.md`） |
| 忽略 | `_template-*.md`、`README.md`、编辑器临时文件（`*.tmp`、`~*` 等） |
| 事件 | 新建；以及内容稳定后的更新（防编辑器连写抖动） |

不监视：整个仓库、`Documents\ChatGPT + Cursor 工作流` 旁路、AICF 业务仓（除非未来另开任务扩大范围）。

## 4. 稳定落盘 / 防抖

1. 文件新建或变更后，连续 **N 秒**（建议 **1～2**）内 `size` / `mtime` 无变化，才视为 ready。  
2. 可选校验：正文含 `## CODEX_INSTRUCTION` 或 `## CURSOR_RESULT`（`judgement` 含 `## CODEX_JUDGEMENT`）才发「可执行 / 可读」类通知；否则仅 debug 日志。  
3. 去重：同一 `(path, mtime 或内容 hash)` 已通知过则不再刷屏（实现见 R2）。

## 5. 通知内容与通道

### 最小通知字段

```text
[handoff] type=instruction|result|judgement
 path=<绝对路径>
 task_id=... round=...
 hint=打开 Cursor 执行 / 把 RESULT 交给 Codex 判责 / 判责已落盘
```

### 通道（MVP）

| 优先级 | 通道 | MVP |
|--------|------|-----|
| 1 | 终端 / 滚动日志 | **必做**（R1） |
| 2 | Windows Toast / 托盘提示 | 可选（R3） |
| — | 邮件、Webhook、GitHub、云端 | **不做** |

## 6. 建议进程形态（实现时参考，本轮不写代码）

- 本机脚本即可：PowerShell 轮询，或 `FileSystemWatcher` + 防抖
- **单实例**：同一监视目录只允许一个 watcher（锁文件或命名 mutex）
- 可选状态文件：如 `.watcher-state.json`，记录已通知的 `(path, mtime/hash)`；**应加入 `.gitignore`**（实现轮处理）
- 无网络外呼；不对 git 做任何写操作

## 7. 硬边界

| 做 | 不做 |
|----|------|
| 监视约定目录、防抖、去重通知 | 自动打开 Cursor Agent / 自动跑 Codex |
| 按文件名与标题分类提示 | 解析并执行 instruction 正文 |
| 本地日志 | 上传云端、跨机同步、远程触发 |
| 可选：本机 inbox 文本记下路径 | commit / push / 改业务仓 |
| 崩溃可重启、单实例 | 多仓并行监视（非 MVP） |
| — | 小红书抓取 / 发布 / F4 / 日更等任何 AICF 运营动作 |

合规：

- 不读、不转发 cookie、token、`.env`
- 高风险仍靠 instruction 内 `risk` 字段与人工确认；**watcher 不放行、不执行**

## 8. 非目标（明确砍掉）

1. 无人值守自动闭环（instruction → execute → judgement）  
2. MCP / HTTP API 双向桥  
3. 监视旁路 Documents 目录或整仓  
4. 本轮选定重型框架；MVP 以「能稳通知」为准  

## 9. 验收标准（留给实现轮）

- [ ] 新建 `foo-r01-instruction.md` 且稳定后，约 **≤3s** 内出现一条通知（含绝对路径）  
- [ ] 同文件重复保存不重复刷屏（去重生效）  
- [ ] `_template-*` / `README.md` 不触发「可执行」类通知  
- [ ] 写入 `foo-r01-result.md` 同样可通知  
- [ ] 进程重启后「已通知」行为有文档说明（有 state 则不丢；无 state 则说明可能重复一次）  
- [ ] 无网络外呼；无 git 写操作  

## 10. 落地切片

| 轮次 | 内容 | 备注 |
|------|------|------|
| **R1** | 轮询 + 控制台日志 + 防抖 + 忽略模板 | 最小可跑 |
| **R2** | 去重 state + 单实例锁 | state 勿提交密钥；建议 gitignore |
| **R3** | Windows Toast（可选） | 可不进首版 |
| **R4** | 在 `docs/codex-cursor-loop.md` 增加「Watcher（可选）」入口，链到本文 | **另开指令**；非本文任务 |

每一切片须单独 `CODEX_INSTRUCTION`，并写清「不做什么」。

## 11. 相关文件

- [`docs/codex-cursor-loop.md`](codex-cursor-loop.md) — 闭环协议  
- [`docs/handoffs/codex-cursor/README.md`](handoffs/codex-cursor/README.md) — 文件接力命名与顺序  
- [`docs/handoffs/codex-cursor/_template-instruction.md`](handoffs/codex-cursor/_template-instruction.md)  
- [`docs/handoffs/codex-cursor/_template-result.md`](handoffs/codex-cursor/_template-result.md)  
