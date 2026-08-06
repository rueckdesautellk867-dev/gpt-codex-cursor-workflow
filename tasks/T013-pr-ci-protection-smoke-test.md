# T013 PR + CI + 分支保护冒烟验证

- **编号**：T013
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Codex / 人工

## 任务标题

用低风险文档 PR 验证 `main` 分支保护后的日常闭环。

## 背景

T006 已接入 `Docs validation`，T012 已开启 `main` 分支保护。需要用一次真实 PR 验证分支、CI、合并和本地同步链路。

## 目标

验证以下流程可用：

```text
本地分支 -> push 分支 -> PR -> Docs validation -> merge -> 本地 main 同步
```

## 影响范围

- GitHub PR 流程
- CI 检查展示
- 本地 main 同步确认

## 不做什么

- 不执行 T004 高风险样例
- 不修改 CI 逻辑
- 不修改分支保护规则
- 不接外部任务系统、部署或监控

## 完成记录

- 测试分支：`branch-protection-record`
- 测试提交：`0ab8a6c docs: add branch protection PR test`
- PR：`#1`
- 合并提交：`a372df6 Merge pull request #1 from rueckdesautellk867-dev/branch-protection-record`
- CI 结果：`1 check passed`
- 检查项：`Docs validation`
- 本地 `main` 已同步到 `a372df6`
- T004 仍保持 `待确认`

## 验收标准

- [x] 测试分支可推送
- [x] PR 可创建并合并到 `main`
- [x] `Docs validation` 在 PR 中通过
- [x] 本地 `main` 可同步到合并提交
- [x] 高风险人工审批门禁未被绕过

## 测试命令

```text
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

## 风险与待确认

- 本次验证的是 CI 通过后的合并链路。
- 分支保护在 CI 失败时是否强制禁用 Merge，仍可另开失败 PR 做反向验证；当前不主动制造失败检查。
