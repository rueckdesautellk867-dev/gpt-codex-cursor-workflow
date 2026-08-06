# T015 推送失败降级策略（CLI → Desktop）

- **编号**：T015
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Cursor

## 任务标题

把「push 失败 → 记 tip / 标待 Desktop 推送 / 不死等」写成可执行策略与脚本。

## 目标

1. Agent 遇 443 / curl 28 等失败时不阻塞会话
2. 本地 tip 与待推送状态可查询
3. 人工 Desktop 或稍后「同意推送」可收口

## 产出

- `docs/push-fallback.md`
- `scripts/push-with-fallback.ps1`
- `.gitignore`（忽略 `.pending-desktop-push.json`）
- `docs/runbook.md` 增加推送降级入口

## 不做什么

- [x] 未改防火墙
- [x] 未强制 push
- [x] 未把 pending 标记纳入版本库

## 验收标准

- [x] 策略文档写清失败降级与回报句式
- [x] 脚本支持推送 / StatusOnly / ProbeOnly
- [x] 本地 CI 通过
