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
| 推送降级层 | CLI push 失败记 tip / 待 Desktop，不死等 | `docs/push-fallback.md`、`scripts/push-with-fallback.ps1` |
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
- `D:\AIContentFactory` 已完成 T022：F4 / P1-D 公开发布脚本暂缓清单 `docs/publish-script-defer-list.md`（公开发布全部暂缓；build-only 另审）
- `D:\AIContentFactory` 代码仓已本地提交 GX001 build pack 脚本：`22de269`（`Add authorized GX001 build pack script`；仅 1 文件；未推送；未含公开发布脚本）
- `D:\AIContentFactory` 已完成 T023：P1-E 临时扫描工具只读评审 `docs/p1e-temp-merge-scan-review.md`（会访问小红书并复用本地会话；执行和提交均暂缓）
- `D:\AIContentFactory` 已完成 T024：Freeze20 F1/F5/F2/F3 提交边界重排 `docs/freeze20-submit-boundary-plan.md`（只整理提交顺序、依赖关系和测试边界；未提交代码仓）
- `D:\AIContentFactory` 已完成 T025：Freeze20 包 1 提交准备 `docs/freeze20-package1-submit-prep.md`（候选 3 文件 AST 通过；F1 单测受测试环境依赖阻塞；未提交代码仓）
- `D:\AIContentFactory` 已完成 T026：Freeze20 F1 单测环境处理 `docs/freeze20-f1-test-env.md`（`.venv` 依赖存在但当前沙箱无法启动；已指定本机 PowerShell 测试命令）
- `D:\AIContentFactory` 代码仓已本地提交 Freeze20 包 1：`453b68d`（`Add Freeze20 dry-run and guarded CLI`；3 文件；本机 F1 单测 7 OK；未推送；未含 F2/F3/F4/P1/大型目录）
- `D:\AIContentFactory` 已完成 T027：Freeze20 包 2 提交准备 `docs/freeze20-package2-submit-prep.md`（F1+F2 mock 各 7 OK；真实 live 暂缓）
- `D:\AIContentFactory` 代码仓已本地提交 Freeze20 包 2：`716c73c`（`Add Freeze20 single-id live draft helpers`；仅 2 文件；未推送；未含 F3/F4/P1；不等于批准真实 live）
- `D:\AIContentFactory` 已完成 T028：Freeze20 包 3 提交准备 `docs/freeze20-package3-submit-prep.md`（F1+F2+F3 mock 22 OK；真实 batch 暂缓）
- `D:\AIContentFactory` 代码仓已本地提交 Freeze20 包 3：`c6b7b6a`（`Add Freeze20 small-batch draft helpers`；仅 2 文件；未推送；未含 F4/P1；不等于批准真实 batch）
- `D:\AIContentFactory` 已完成 T029：F1–F3 提交后状态报告 `docs/freeze20-f1f3-post-submit-status.md`（剩余未跟踪：F4 publish / P1 残留 / 临时扫描 / 大目录）
- `D:\AIContentFactory` 已完成 T030：P1-E 稳定化方案（拍板方案 A 不保留落库）
- `D:\AIContentFactory` 已完成 T031：已删除工作区 `_tmp_merge_scan.py`（未跟踪；未 git add / 未提交代码仓）
- `D:\AIContentFactory` 已完成 T032：剩余未跟踪盘点 `docs/remaining-untracked-inventory.md`（F4×3 / P1×5 / 大目录×2）
- `D:\AIContentFactory` 已完成 T033：远程策略复核 `docs/remote-repo-plan-review.md`（维持暂不配置 origin）
- `D:\AIContentFactory` 已完成 T034：P1-A 详情版只读评审 `docs/p1a-detail-crawl-review.md`（运行/提交暂缓；处置 A/B/C 须另确认）
- `D:\AIContentFactory` 已完成 T035：详情版参数化与授权门禁方案 `docs/p1a-detail-param-auth-plan.md`
- `D:\AIContentFactory` 已完成 T036：详情版门禁落地 `docs/p1a-detail-param-auth-impl.md`（脚本已改；无授权 exit 2；未抓取、未提交）
- `D:\AIContentFactory` 已完成 T037：详情版提交准备 `docs/p1a-detail-submit-prep.md`（候选 1 文件；AST 通过；无授权拒绝）
- `D:\AIContentFactory` 代码仓已本地提交 P1-A 详情版：`0672a73`（`Add authorized P1A detail crawl script`；仅 1 文件；未推送；无 origin；不等于批准真实抓取）
- `D:\AIContentFactory` 已完成 T038：P1-C 三脚本处置策略 `docs/p1c-disposition-plan.md`（推荐 K0 暂缓保留；publish 辅助单独隔离；未运行、未提交）
- `D:\AIContentFactory` 已完成 T039：大目录 ignore 声明 `docs/large-dir-ignore-plan.md`
- `D:\AIContentFactory` 代码仓已本地提交 ignore：`0d4683c`（`Ignore local Freeze20 and media working trees`；仅 `.gitignore`；未推送；未删除目录；两目录不再以 `??` 出现）
- `D:\AIContentFactory` 已完成 T040：剩余高风险冻结清单 `docs/remaining-high-risk-freeze.md`（维持 F4/P1-C/publish 禁止执行；未跟踪仅保留不提交；已入库真实动作仍冻结）
- `D:\AIContentFactory` 已完成 T041：阶段收口报告 `docs/freeze20-p1-stage-closeout.md`（Freeze20/P1 拆分→冻结；代码仓 tip=`0d4683c` 无 origin；高风险面维持冻结）
- `D:\AIContentFactory` 已完成 T042：远程落地方案；用户确认 **暂缓 B，维持无 origin**
- `D:\AIContentFactory` 已完成 T043：已删除工作区 `open_xhs_publish_page_local.py`（未提交；剩余敏感 `??` 6 项）
- `D:\AIContentFactory` 已完成 T044：P1-A feed-only 受控真跑 `docs/p1a-feed-only-controlled-run.md`（limit=8；exit 0；氛围 0 / 慢读 8 / 其他 16；输出在 ignore 目录；未提交）
- `D:\AIContentFactory` 已完成 T045：feed-only 第二轮 `docs/p1a-feed-only-controlled-run-round2.md`（limit=12 / scroll=3；exit 0；氛围 0 / 慢读 7 / 其他 29；未提交）
- `D:\AIContentFactory` 已完成 T046：F4 / 公开发布禁止执行归档 `docs/f4-publish-forbid-archive.md`（只文档与门禁说明；未运行、未改代码仓、未提交）
- `D:\AIContentFactory` 已完成 T047：feed-only 第三轮 `docs/p1a-feed-only-controlled-run-round3.md`（limit=12 / scroll=3 / pause=1500；exit 0；氛围 0 / 慢读 7 / 其他 29；与 T045 一致；未提交）
- `D:\AIContentFactory` 已完成 T048：feed-only 三轮汇总 `docs/p1a-feed-only-three-round-summary.md`（停同参；详情默认暂不升级）
- `D:\AIContentFactory` T049：**已取消（改期）** — F2 live content-id=106 因 MySQL 不可达未完成；重跑须另批；见 `docs/freeze20-f2-live-106-t049.md`
- `D:\AIContentFactory` 已完成 T050：MySQL/本地服务前置清单 `docs/mysql-local-prereq-checklist-t049.md`（只读；未启服务；满足清单 ≠ 批准重跑）
- `D:\AIContentFactory` 已完成 T051：H1 连通性检查 `docs/mysql-h1-connectivity-check-t051.md`（**未满足**：3306 不可达；未重跑 F2）
- `D:\AIContentFactory` 已完成 T052：MySQL 状态/启动备忘 `docs/mysql-service-status-startup-notes-t052.md`（约定 `ai_mysql`；本机无 Docker；未启服务）
- `D:\AIContentFactory` 已完成 T053：敏感 `??` 冻结复核 `docs/remaining-sensitive-untracked-freeze-review.md`（仍 6 项；维持冻结；无低风险可删/ignore）
- `D:\AIContentFactory` 已完成 T054：阶段二收口 `docs/phase2-closeout-t044-t053.md`（T044–T053；F2 改期；冻结维持）
- `D:\AIContentFactory` 已完成 T055：入口 **A 维持观察** `docs/phase2-maintain-observation.md`（不启服务、不重跑 F2、不动敏感 `??`）
- `D:\AIContentFactory` 已完成 T056：观察期巡检 `docs/observation-status-patrol-t056.md`（`9586d20` / `0d4683c`；`??`×6；H1 未满足；pending 无）
- `D:\AIContentFactory` 已完成 T057：阶段成果索引 `docs/phase-results-index.md`（总入口；挂 README / project-status）
- `D:\AIContentFactory` 已完成 T058：未完成与冻结任务清单 `docs/unfinished-and-frozen-task-list.md`（后续只从清单选入口；checkpoint）
- `D:\AIContentFactory` 已完成 T059：H1 复检（L1）`docs/h1-recheck-t059.md`（**仍未满足**：3306 不可达；无 Docker/`ai_mysql`；未启服务、未重跑 F2）
- `D:\AIContentFactory` 已完成 T060：P1-C 删除候选评估（L2）`docs/p1c-delete-candidate-assessment-t060.md`（两登录脚本继续 K0；真删须 L3 点名；未删文件）
- `D:\AIContentFactory` 已完成 T061：代码仓远程方案复核（L4）`docs/remote-repo-plan-recheck-t061.md`（维持暂缓 B / 无 origin；tip=`0d4683c`；`??`×6）
- `D:\AIContentFactory` 已完成 T062：P1-C 删除 `open_xhs_login_local.py`（L3）`docs/p1c-delete-open-xhs-login-local-t062.md`（未提交；`??` 现 5；`ensure_www_xhs_login.py` 仍 K0）
- `D:\AIContentFactory` 已完成 T063/T064：H1 复检仍失败（无 Docker）；见 `docs/h1-recheck-t063.md` / `docs/h1-recheck-t064.md`
- `D:\AIContentFactory` 已完成 T065：winget 安装 Docker Desktop `docs/docker-desktop-install-t065.md`
- `D:\AIContentFactory` 已完成 T066：compose 启动 `ai_mysql`/`ai_redis` `docs/compose-start-ai-mysql-t066.md`
- `D:\AIContentFactory` 已完成 T067：H1 **已满足** `docs/h1-recheck-t067.md`
- `D:\AIContentFactory` 已完成 T068–T071：H2 通路（建用户→schema/导入→GC106 approved）；见对应 `docs/*-t068`～`t071`
- `D:\AIContentFactory` 已完成 T072：F2 live content-id=106 **成功** `docs/freeze20-f2-live-106-t072.md`（暂存离开；未发布；未提交代码仓）
- `D:\AIContentFactory` 已完成 T074：L5 冻结复核 `docs/remaining-freeze-l5-review-t074.md`（**`??`=5**；冻结维持）
- `D:\AIContentFactory` 已完成 T075：删除 `ensure_www_xhs_login.py`（不提交）；`??`→**4**
- `D:\AIContentFactory` 已完成 T076：H1 复检 **未满足**（Docker 停 / 3306 不通）
- `D:\AIContentFactory` 已完成 T077：Docker + compose `ai_mysql`/`ai_redis`（3306 True；未跑 F2）
- `D:\AIContentFactory` 已完成 T078：H1 **已满足**
- `D:\AIContentFactory` 已完成 T079：H2 **已满足**（GC106 gates；未跑 F2）
- `D:\AIContentFactory` 已完成 T080：F2 live 106 **成功**（暂存离开；未发布）

## 当前限制



- 已接最小真实 CI（T006 已完成），当前覆盖文档链接、任务索引和关键文件检查
- 未接外部任务系统（仅仓库内 Markdown 任务）
- 未接云端部署
- 未接监控反馈
- 分支保护已开启；通过检查后的 PR 合并链路已验证。CI 失败时是否强制拦截尚未反向验证

## 下一步建议

1. AIContentFactory：T080 F2 live 106 成功；默认不自动 F3/发布；再跑须新 H3
2. AIContentFactory：维持代码仓无 origin（B 已暂缓；T061 复核维持）
3. 高风险（F3/F4/详情/再跑 F2）须新审批；T072 授权已消费
4. 接入任务系统（如需）

## 复制到其它项目时

1. 按 `docs/template-rollout.md` 和 `scripts/copy-workflow-template.ps1` 复制规则与骨架
2. 用 `docs/runbook.md` 跑第一个低风险任务验证
3. 再按需接入 CI、远程仓库与环境；高风险仍走 `docs/risk-approval.md`
