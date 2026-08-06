# T006 接入真实 CI 配置

- **编号**：T006
- **状态**：已完成
- **风险等级**：中
- **推荐执行者**：Codex 或 Cursor（配置合并前建议人工抽查）

标准见 [`docs/verification.md`](../docs/verification.md) 与 [`docs/ci.md`](../docs/ci.md)。

## 任务标题

接入真实 CI 配置

## 背景

验证层设计已就绪；后续需要把最低检查落到自动流水线。当前仅占位，避免与 v0.3「只做设计」混淆。

## 目标

在仓库中接入与项目匹配的 CI（如文档链接检查、lint、测试等），使 PR 能自动反映 `docs/verification.md` 的门槛。

## 影响范围

- 模块 / 目录：CI 配置目录、可能的脚本
- 预计改动文件：（执行时再定）如 `.github/workflows/*` 或等价配置
- 可能波及的调用方：PR 合并门禁

## 不做什么

- v0.3 阶段不创建、不合并任何真实 CI 配置
- 不借本任务修改业务逻辑
- 不降低高风险「先人工确认」要求

## 验收标准

- [x] CI 配置可运行，并与验证类型映射关系写清
- [x] 文档说明本地如何复现同一组检查
- [x] 未把高风险人工确认替换为「仅 CI 绿」

## 测试命令

```text
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

## 完成后需要说明的内容

- 变更总结、启用的检查项、如何关闭/回滚 CI 门禁
- 是否需要人工确认：建议是（合并 CI 门禁前）

## 完成记录

- 新增 GitHub Actions：`.github/workflows/ci.yml`
- 新增本地复现脚本：`scripts/ci-check.ps1`
- 新增说明文档：`docs/ci.md`
- 当前检查项：关键文件存在、Markdown 相对链接、任务索引一致性、高风险样例状态
- 高风险人工确认仍由 `docs/risk-approval.md` 和 `docs/verification.md` 约束，CI 不替代审批
