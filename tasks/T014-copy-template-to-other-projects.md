# T014 复制到其它项目模板化落地

- **编号**：T014
- **状态**：已完成
- **风险等级**：低
- **推荐执行者**：Codex / Cursor / 人工

## 任务标题

把三方闭环能力整理成可复制到其它项目的模板化落地包。

## 背景

T006、T012、T013 已验证 CI、分支保护和 PR 链路。下一步需要让这套规则能安全复制到其它项目，而不是手工挑文件。

## 目标

提供：

- 复制说明
- 本地复制脚本
- 明确的复制清单
- 明确的不复制清单
- 复制后的验证步骤

## 影响范围

- `docs/template-rollout.md`
- `scripts/copy-workflow-template.ps1`
- `tasks/backlog.md`
- `docs/project-status.md`
- `docs/pilot-log.md`

## 不做什么

- 不直接修改其它项目
- 不覆盖任何目标项目文件
- 不初始化目标项目 Git
- 不配置目标项目 GitHub 分支保护
- 不执行高风险任务

## 完成记录

- 新增复制说明：`docs/template-rollout.md`
- 新增复制脚本：`scripts/copy-workflow-template.ps1`
- 脚本默认跳过目标项目已有文件，避免误覆盖
- 脚本会为目标项目生成干净 starter 文件，不复制本仓库历史 backlog
- 目标项目路径仍需执行时显式提供
- 首次真实复制目标：`D:\AIContentFactory`
- 复制结果：14 个模板文件复制，4 个 starter 文件创建
- 目标项目本地 CI：通过（Required files: 10；Markdown files checked: 15）
- 针对 AIContentFactory 调整：目标项目 `scripts/ci-check.ps1` 扫描范围收窄到模板入口目录，避免递归扫描大型项目目录
- 首个目标项目专用任务：`D:\AIContentFactory\tasks\T001-customize-project-status.md`
- 首个任务验证：通过（Required files: 10；Markdown files checked: 16）
- 第二个目标项目专用任务：`D:\AIContentFactory\tasks\T002-confirm-git-anchor.md`
- 第二个任务验证：通过（Required files: 10；Markdown files checked: 17）
- AIContentFactory 实际代码仓库锚点：`D:\AIContentFactory\repo\AIContentFactory`

## 验收标准

- [x] 复制清单写清
- [x] 不复制清单写清
- [x] 脚本默认不覆盖已有文件
- [x] 本地 CI 通过
- [x] 已在真实目标项目 `D:\AIContentFactory` 完成首次复制验证
- [x] 已在目标项目完成首个低风险任务试跑
- [x] 已确认目标项目实际 Git 仓库锚点

## 测试命令

```text
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

## 风险与待确认

- 对具体目标项目执行复制前，仍需确认目标项目路径。
- 如果目标项目已有同名规则文件，应先人工比较后再决定是否用 `-Force` 覆盖。
