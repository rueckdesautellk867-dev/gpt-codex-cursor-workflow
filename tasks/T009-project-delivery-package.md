# T009 建立项目交付包

- **编号**：T009
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Cursor

## 任务标题

建立项目交付包

## 背景

v0.1–v0.5 已形成规则、任务、验证、审批与运行手册；需要一份状态与版本归档，便于复制到其它项目与对外说明当前能力边界。

## 目标

新增 `docs/project-status.md` 与 `docs/release-notes.md`，登记 T009，并小幅更新 README / pilot-log。本任务只做归档，不改业务代码。

## 影响范围

- 模块 / 目录：`docs/`、`tasks/`、根 `README.md`
- 预计改动文件：`docs/project-status.md`、`docs/release-notes.md`、`tasks/T009-project-delivery-package.md`、`tasks/backlog.md`、`README.md`、`docs/pilot-log.md`
- 可能波及的调用方：无（纯文档）

## 不做什么

- 不改业务代码
- 不新增依赖、不接真实 CI
- 不执行 T004，不修改 T004 状态
- 不接入远程仓库、云端或监控（仅写入「下一步建议」）

## 验收标准

- [x] 存在项目状态与版本记录文档
- [x] T009 已完成；T004 仍为 `待确认`
- [x] 本任务只做归档，不改业务代码

## 测试命令

```text
无需运行测试，仅检查 Markdown 链接和格式；核对 git log 与 release-notes 中 v0.1–v0.5 hash 一致
```

## 完成后需要说明的内容

- 变更总结：已建立项目交付包归档
- 验证：文档检查 + hash 对照
- 风险：无；v0.6 commit hash 在提交后回填
