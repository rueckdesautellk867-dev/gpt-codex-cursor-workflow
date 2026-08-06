# 项目状态

便于把本仓库作为模板复制到其它项目时，先看清能力、限制与下一步。

| 项 | 内容 |
|----|------|
| 项目名称 | 三方闭环整合项目 |
| 当前版本 | v0.11 已完成，模板化复制落地包已建立 |
| 当前工作区 | `D:\三方闭环整合项目\` |
| 远程仓库 | `https://github.com/rueckdesautellk867-dev/gpt-codex-cursor-workflow.git` |

版本明细见 [`docs/release-notes.md`](release-notes.md)；操作顺序见 [`docs/runbook.md`](runbook.md)。

## 当前能力

| 层级 | 说明 | 入口 |
|------|------|------|
| 规则层 | GPT / Codex / Cursor 分工与仓库规则 | `AGENTS.md`、`.cursor/rules/ai-workflow.mdc`、`docs/ai-workflow.md` |
| 任务层 | 可复用任务单与 backlog | `tasks/`、`docs/task-template.md` |
| 验证层 | 风险对应的最低验证与交付字段 | `docs/verification.md` |
| CI 层 | GitHub Actions 与本地复现脚本 | `.github/workflows/ci.yml`、`docs/ci.md` |
| 风险审批层 | 高风险禁止动作与审批记录 | `docs/risk-approval.md` |
| 运行手册层 | 启动→归档的固定操作顺序 | `docs/runbook.md` |
| 模板复制层 | 复制到其它项目的说明与脚本 | `docs/template-rollout.md`、`scripts/copy-workflow-template.ps1` |

## 已验证事项

- 低风险任务可执行（文档类试跑与 T001–T003、T005、T007–T009 类任务）
- 高风险任务可识别并停在人工确认前（T004 保持 `待确认`）
- 任务可归档（`tasks/backlog.md`、`docs/pilot-log.md`）
- 提交记录清晰（v0.1–v0.8 均有独立记录，见 release-notes）
- 真实 CI 已接入：`Docs validation`
- `main` 分支保护已在 GitHub 网页开启
- PR #1 已验证分支推送、`Docs validation`、合并和本地同步链路
- 复制到其它项目的模板说明和本地复制脚本已建立
- 首次真实目标项目 `D:\AIContentFactory` 已完成模板复制和本地 CI 验证
- `D:\AIContentFactory` 已完成首个低风险项目任务 T001 并通过本地 CI
- `D:\AIContentFactory` 已完成 T002，确认实际代码仓库锚点为 `D:\AIContentFactory\repo\AIContentFactory`
- `D:\AIContentFactory` 已完成 T003，输出代码仓库未提交改动盘点
- `D:\AIContentFactory` 已完成 T004，输出未提交改动分组处理方案
- `D:\AIContentFactory` 已完成 T005：三 shell 保持 Git `100755`，本仓 `core.filemode=false` 消除 Windows 模式误报
- `D:\AIContentFactory` 已完成 T006 限定范围：只读复核 `playwright_engine.py`，不发布、不登录、不点击、不改代码
- `D:\AIContentFactory` 已完成 T007：登记 playwright 测试补强（不改发布行为）
- `D:\AIContentFactory` 已完成 T008：测试环境确认；`test_xhs_draft_box_save` 15 OK（3 expectedFailure）
- `D:\AIContentFactory` 已完成 T009：单测假 Settings，不依赖真实 `backend/.env` 密钥
- `D:\AIContentFactory` 已完成 T010：引擎 draft-box 安全修复；单测 15 OK
- `D:\AIContentFactory` 已完成 T011：统一测试报告 `docs/draft-box-test-report.md`
- `D:\AIContentFactory` 代码仓已本地提交 T009–T010：`0ae4784`（`Add draft-box safety path and unit tests`；3 文件；未推送）
- `D:\AIContentFactory` 已完成 T012：远程策略 `docs/remote-repo-plan.md`（origin 暂不配置；GitHub private；CI/保护暂缓；仓库名建议 AIContentFactory）
- `D:\AIContentFactory` 已完成 T013/T014：Freeze20 / P1 未跟踪脚本拆分方案 `docs/freeze20-p1-split-plan.md`
- `D:\AIContentFactory` 已完成 T015：F1 dry-run 只读评审 `docs/freeze20-f1-dry-run-review.md`（未运行、未提交代码仓）
- `D:\AIContentFactory` 已完成 T016：P1-B 本地目录填表只读评审 `docs/p1b-local-catalog-fill-review.md`（无网络/浏览器；硬编码路径阻塞提交）
- `D:\AIContentFactory` 已完成 T017：Freeze20 F2 单条草稿箱 live 只读评审 `docs/freeze20-f2-live-draft-review.md`（不运行；会点击 `暂存离开` 的执行风险已登记）
- `D:\AIContentFactory` 已完成 T018：P1-B 路径参数化（去掉个人目录硬编码；临时输出验证通过）
- `D:\AIContentFactory` 代码仓已本地提交 P1-B 脚本：`08de0e0`（`Add parameterized P1 catalog prescan script`；仅 1 文件；未推送；未含 Freeze20 / 其它 P1）
- `D:\AIContentFactory` 已完成 T019：Freeze20 F3 小批量草稿箱只读评审 `docs/freeze20-f3-batch-review.md`（不运行；会连续写入真实草稿箱，执行暂缓）
- `D:\AIContentFactory` 已完成 T020：P1-A 公开资料抓取只读评审 `docs/p1a-public-profile-crawl-review.md`（会访问小红书并复用本地会话；运行暂缓）
- `D:\AIContentFactory` 代码仓已本地提交 P1-A feed-only 脚本：`a9a4ea2`（`Add authorized P1A feed-only crawl script`；仅 1 文件；未推送；未含详情版抓取）
- `D:\AIContentFactory` 已完成 T021：P1-C 登录 / 打开页面辅助只读评审 `docs/p1c-login-page-helper-review.md`（会打开登录/发布相关页面；执行暂缓）

## 当前限制



- 已接最小真实 CI（T006 已完成），当前覆盖文档链接、任务索引和关键文件检查
- 未接外部任务系统（仅仓库内 Markdown 任务）
- 未接云端部署
- 未接监控反馈
- 分支保护已开启；通过检查后的 PR 合并链路已验证。CI 失败时是否强制拦截尚未反向验证

## 下一步建议

1. AIContentFactory：P1-C 授权门禁参数化方案（须确认）
2. AIContentFactory：T022 F4 / P1-D 公开发布脚本暂缓清单
3. AIContentFactory：若改远程策略（配置 origin / 首次推送 / CI·保护），另开任务并确认
4. 接入任务系统（如需与看板 / Issue 同步）

## 复制到其它项目时

1. 按 `docs/template-rollout.md` 和 `scripts/copy-workflow-template.ps1` 复制规则与骨架
2. 用 `docs/runbook.md` 跑第一个低风险任务验证
3. 再按需接入 CI、远程仓库与环境；高风险仍走 `docs/risk-approval.md`
