# 试跑记录

归档 GPT + Codex + Cursor 三方闭环前三次试跑结果。

## 试跑 1：新增低风险示例任务

- **目标**：在 `docs/examples/` 下按任务模板新建低风险示例，验证规则可填写、可分流
- **执行结果**：已新建 `docs/examples/low-risk-doc-update-task.md`（主题：更新 README 中的项目目标描述；风险：低；执行者：Cursor 或 Codex）
- **影响范围**：仅新增该示例文件；未改业务代码与已有文档
- **验证结果**：模板字段齐全；测试为「无需运行测试，仅检查 Markdown 链接和格式」— 通过
- **风险结论**：低；示例本身无执行风险

## 试跑 2：按低风险示例润色 README

- **目标**：依据试跑 1 的任务单，实际更新 `README.md`「项目目标」表述
- **执行结果**：仅润色项目目标一句，明确为「以代码仓库、任务系统、CI 和评审规则为中心的 GPT + Codex + Cursor 三方 AI 研发闭环」；结构未大改
- **影响范围**：仅 `README.md`「项目目标」小节
- **验证结果**：Markdown 链接与格式检查通过；其它章节未动
- **风险结论**：低；纯文案，可随时回滚该段

## 试跑 3：新增高风险数据库迁移示例

- **目标**：新增高风险任务示例，验证规则能否把高风险事项停在人工确认前
- **执行结果**：已新建 `docs/examples/high-risk-db-migration-task.md`（主题：修改用户表结构以支持新的会员等级字段；风险：高；推荐：人工确认后由 Codex 或人工执行）
- **影响范围**：仅新增该示例文件；未改库、未改码、未生成迁移
- **验证结果**：验收标准含「必须人工确认后才能进入执行阶段」；测试「不适用」— 示例文档创建通过
- **风险结论**：示例文档本身低风险；所描述真实改动为高风险且**未执行**，门禁有效

## 阶段结论

当前闭环已验证低风险任务可执行，高风险任务可识别并停在人工确认前。

## v0.2 启动

启动任务执行层：新增 `tasks/` 目录、`backlog.md` 与 T001–T004；T001–T003 已完成（文档与入口），T004 高风险门禁样例保持 `待确认`、未执行。

## v0.3 启动

建立验证层设计，不接真实 CI：新增 `docs/verification.md` 与 T005（已完成）；预留 T006（待办）；T004 仍为 `待确认`。

## v0.4 启动

建立风险与人工审批层，不执行高风险任务：新增 `docs/risk-approval.md` 与 T007（已完成）；T004 仍为 `待确认`。

## v0.5 启动

建立运行手册层，用于重复执行任务流程：新增 `docs/runbook.md` 与 T008（已完成）；T004 仍为 `待确认`。

## v0.6 启动

建立项目交付包，归档阶段成果：新增 `docs/project-status.md`、`docs/release-notes.md` 与 T009（已完成）；T004 仍为 `待确认`。

## v0.7 启动

建立远程仓库准备方案，不实际推送：新增 `docs/remote-repo-plan.md` 与 T010（已完成）；预留 T011（`待确认`）；T004 仍为 `待确认`。
## T011 远程仓库推送

已在人工授权后连接 GitHub private 仓库并推送 main 分支：https://github.com/rueckdesautellk867-dev/gpt-codex-cursor-workflow.git。T011 已完成；T004 仍保持 待确认；未接真实 CI；未执行高风险任务。分支保护建议后续在 GitHub 网页单独配置。

## T006 真实 CI 接入

已接入最小真实 CI：`.github/workflows/ci.yml` 调用 `scripts/ci-check.ps1`，检查名为 `Docs validation`。本地复现命令见 `docs/ci.md`。T006 已完成；T004 仍保持 `待确认`；CI 不替代高风险人工审批。

## T012 main 分支保护

已由人工在 GitHub 网页开启 `main` 分支保护，并将 `Docs validation` 设为必选检查。后续日常闭环调整为：本地改动 → 新分支 commit → push 分支 → 开 PR → `Docs validation` 通过 → 合并。T012 已完成；T004 仍保持 `待确认`。

## T013 PR + CI + 分支保护冒烟验证

已用低风险文档变更验证日常闭环：测试分支 `branch-protection-record` 推送成功，PR #1 合并到 `main`，页面显示 `1 check passed`，检查项为 `Docs validation`。本地 `main` 已同步到合并提交 `a372df6`。本次验证确认 PR + CI + merge + sync 链路可用；T004 仍保持 `待确认`，未执行任何高风险任务。

## T014 复制到其它项目模板化落地

已建立复制到其它项目的模板化落地包：新增 `docs/template-rollout.md` 和 `scripts/copy-workflow-template.ps1`。脚本默认跳过目标项目已有文件，避免误覆盖；具体目标项目路径需执行时显式提供。T014 已完成；T004 仍保持 `待确认`。

## T014 首次真实目标项目复制

已选择 `D:\AIContentFactory` 作为首次真实目标项目，并执行模板复制。复制结果：14 个模板文件复制，4 个 starter 文件创建；未使用覆盖模式。目标项目本地 CI 通过：Required files 10，Markdown files checked 15。由于 AIContentFactory 包含 `repo`、`tools`、`ObsidianMemory` 等大型目录，已将目标项目的 `scripts/ci-check.ps1` 扫描范围收窄到模板入口目录，避免全量递归。

## T014 目标项目首个任务试跑

已在 `D:\AIContentFactory` 创建首个项目专用低风险任务：`tasks/T001-customize-project-status.md`。该任务定制了 `docs/project-status.md`、登记 `tasks/backlog.md`、记录 `docs/pilot-log.md`，不涉及内容生产、发布、账号风控、数据库、权限或生产配置。目标项目本地 CI 通过：Required files 10，Markdown files checked 16。

## T014 目标项目 Git 锚点确认

已在 `D:\AIContentFactory` 创建第二个低风险任务：`tasks/T002-confirm-git-anchor.md`。确认 `D:\AIContentFactory` 和 `D:\AIContentFactory\repo` 不是 Git 仓库，实际代码仓库为 `D:\AIContentFactory\repo\AIContentFactory`。该代码仓库已有大量未提交和未跟踪改动，后续不得擅自清理、提交或覆盖。目标项目本地 CI 通过：Required files 10，Markdown files checked 17。

## T014 目标项目未提交改动盘点

已在 `D:\AIContentFactory` 创建第三个低风险任务：`tasks/T003-inventory-code-repo-working-tree.md`。输出盘点文档 `docs/git-working-tree-inventory.md`，记录实际代码仓库 `D:\AIContentFactory\repo\AIContentFactory` 的已跟踪改动、未跟踪项、大型产物目录和后续处理建议。目标项目本地 CI 通过：Required files 10，Markdown files checked 19。

## T014 目标项目未提交改动分组方案

已在 `D:\AIContentFactory` 创建第四个低风险任务：`tasks/T004-working-tree-group-plan.md`。输出 `docs/working-tree-group-plan.md`，将未提交改动拆为 shell 文件模式变化、`playwright_engine.py`、Freeze20、P1 脚本和大型产物目录等处理组。目标项目本地 CI 通过：Required files 10，Markdown files checked 21。
