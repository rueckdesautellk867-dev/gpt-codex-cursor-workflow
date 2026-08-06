# CI 配置

本仓库使用 GitHub Actions 跑最小真实 CI，目标是把 `docs/verification.md` 的文档类门槛落到自动检查。

## 当前检查项

工作流文件：

- `.github/workflows/ci.yml`

本地复现脚本：

- `scripts/ci-check.ps1`

检查内容：

- 关键项目文件必须存在
- Markdown 相对链接必须可解析
- Markdown 中不得出现误写的字面量换行转义
- `tasks/backlog.md` 必须引用所有 `tasks/T*.md` 任务单
- backlog 中引用的任务单必须真实存在
- 高风险样例 `T004` 必须保持 `待确认`

## 本地运行

在仓库根目录执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

或使用 PowerShell 7：

```powershell
pwsh -NoProfile -File ./scripts/ci-check.ps1
```

## CI 触发

当前在以下场景触发：

- 推送到 `main`
- 面向 `main` 的 pull request

## 与风险门禁的关系

CI 只覆盖自动化可判断的基础门槛，不替代人工审批。

高风险任务仍必须遵守：

- `docs/risk-approval.md`
- `docs/verification.md`
- `tasks/T004-high-risk-gate-sample.md`

也就是说，CI 绿不等于高风险任务可以自动执行。

## 回滚方式

如 CI 配置误伤，可回退本次 CI 相关提交，或临时修改 `.github/workflows/ci.yml` 的触发条件。修改 CI 门禁前应在任务单和 PR 描述中写明原因。
