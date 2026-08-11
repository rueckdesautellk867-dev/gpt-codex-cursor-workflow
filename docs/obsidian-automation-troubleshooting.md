# Obsidian Automation 调度排查

本文用于排查 Codex 本地 `obsidian` automation 是否按每日 06:30 自动写入 Obsidian daily review。排查范围只限调度与文件产出，不处理平台动作。

## 目标

确认以下链路是否成立：

```text
Codex automation cron
    -> 读取 AICF + Obsidian + 三方闭环上下文
    -> 写入 05_Daily_Reviews/YYYY-MM-DD_每日复盘.md
    -> 07:00 只读核对产出
```

## 正常判定

在运行日 07:00 后，以下条件同时满足才算通过：

- `D:\AIContentFactory\ObsidianMemory\05_Daily_Reviews\YYYY-MM-DD_每日复盘.md` 存在。
- 文件为 UTF-8 可读 Markdown。
- 文件包含六段结构：今日完成、当前状态、明日优先级、风险与禁止项、需要用户确认、证据入口。
- `LastWriteTime` 晚于当日 06:30。
- `C:\Users\Administrator\.codex\automations\obsidian\automation.toml` 仍为 `ACTIVE`，并绑定明确工作目录。

## 失败判定

如果 07:00 后当日复盘文件不存在，不能直接判定 prompt 或写入边界失败。已知人工等价验证通过时，问题应先收敛到调度触发层。

优先检查：

1. `automation.toml` 是否存在且 `status = "ACTIVE"`。
2. `rrule` 是否仍包含每日 06:30。
3. `target` 是否仍绑定项目，而不是 `projectless`。
4. `cwds` 是否仍指向明确工作目录。
5. Codex app 是否在预期时间具备运行 automation 的条件。
6. 是否有对应线程或 automation 历史输出。

## 禁止动作

排查时不得执行：

- 打开小红书平台。
- 登录、抓取、上传、暂存、发布。
- 运行 F4 或日更。
- 修改 AICF 业务仓。
- 写 cookie、token、`.env` 或平台凭证。
- 手动创建待验证日期的 daily review 文件来冒充 cron 产出。
- commit / push，除非用户另行明确授权。

## 人工等价验证

如果需要验证 prompt 与写入边界，可在非目标验证窗口执行人工等价写入。该验证只能说明“内容生成与写入边界可执行”，不能证明 cron 调度成功。

人工等价验证产出必须在结果中标明：

- 写入路径。
- 文件大小与编码。
- 已读取证据。
- 未触碰平台、AICF 业务仓、发布、抓取、F4、日更、commit/push。

## 当前观察点

- `obsidian`：每日 06:30 计划写入当日复盘。
- `obsidian-08-12`：2026-08-12 07:00 一次性只读核对 `2026-08-12_每日复盘.md` 是否存在。
- 08-12 06:30 前不得手动创建 `2026-08-12_每日复盘.md`，否则会污染调度验证。