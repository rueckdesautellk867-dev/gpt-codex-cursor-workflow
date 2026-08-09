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
- `D:\AIContentFactory` 已完成 T081：L5 确认 **`??`=4**、冻结维持
- `D:\AIContentFactory` 已完成 T082：F2 live 106 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T083：F2 live 106 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T084：H2(107) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T085：GC 107 approved；**H2(107) 已满足**
- `D:\AIContentFactory` 已完成 T086：F2 live 107 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T087：H2(108) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T088：GC 108 approved；**H2(108) 已满足**
- `D:\AIContentFactory` 已完成 T089：F2 live 108 **成功**
- `D:\AIContentFactory` 已完成 T090：H2(109) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T091：GC 109 approved；**H2(109) 已满足**
- `D:\AIContentFactory` 已完成 T092：F2 live 109 **成功**
- `D:\AIContentFactory` 已完成 T093：H2(110) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T094：GC 110 approved；**H2(110) 已满足**
- `D:\AIContentFactory` 已完成 T095：F2 live 110 **成功**
- `D:\AIContentFactory` 已完成 T096：H2(111) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T097：GC 111 approved；**H2(111) 已满足**
- `D:\AIContentFactory` 已完成 T098：F2 live 111 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T099：H2(112) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T100：GC 112 approved；**H2(112) 已满足**
- `D:\AIContentFactory` 已完成 T101：F2 live 112 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T102：H2(113) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T103：GC 113 approved；**H2(113) 已满足**
- `D:\AIContentFactory` 已完成 T104：F2 live 113 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T105：H2(114) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T106：GC 114 approved；**H2(114) 已满足**
- `D:\AIContentFactory` 已完成 T107：F2 live 114 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T108：H2(115) **未满足**（quality=pending）
- `D:\AIContentFactory` 已完成 T109：GC 115 approved；**H2(115) 已满足**
- `D:\AIContentFactory` 已完成 T110：F2 live 115 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T111：H2(116) **未满足**（quality=pending；`LIT-01`）
- `D:\AIContentFactory` 已完成 T112：GC 116 approved；**H2(116) 已满足**
- `D:\AIContentFactory` 已完成 T113：F2 live 116 **成功**（`LIT-01`；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T114：H2(117) **未满足**（quality=pending；`LIT-02`）
- `D:\AIContentFactory` 已完成 T115：GC 117 approved；**H2(117) 已满足**
- `D:\AIContentFactory` 已完成 T116：F2 live 117 **成功**（`LIT-02`；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T117：H2(118) **未满足**（quality=pending；`LIT-03`）
- `D:\AIContentFactory` 已完成 T118：GC 118 approved；**H2(118) 已满足**
- `D:\AIContentFactory` 已完成 T119：F2 live 118 **成功**（`LIT-03`；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T120：H2(119) **未满足**（quality=pending；`LIT-04`）
- `D:\AIContentFactory` 已完成 T121：GC 119 approved；**H2(119) 已满足**
- `D:\AIContentFactory` 已完成 T122：F2 live 119 **成功**（`LIT-04`；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T123：H2(120) **未满足**（quality=pending；`LIT-05`）
- `D:\AIContentFactory` 已完成 T124：GC 120 approved；**H2(120) 已满足**
- `D:\AIContentFactory` 已完成 T125：F2 live 120 **成功**（`LIT-05`；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T126：H2(121) **未满足**（quality=pending；`LIT-06`）
- `D:\AIContentFactory` 已完成 T127：F3 batch 116–120 **成功**（5/5；未发布）
- `D:\AIContentFactory` 已完成 T128：GC 121 approved；**H2(121) 已满足**；F3 121–125 **未跑**（122–125 pending）
- `D:\AIContentFactory` 已完成 T129：GC 122–125 approved
- `D:\AIContentFactory` 已完成 T130：F2 live 121 **成功**
- `D:\AIContentFactory` 已完成 T131：F3 batch 121–125 **成功**（5/5）
- `D:\AIContentFactory` 已完成 T132：Freeze20 106–125 草稿箱路径收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T133：L5 冻结复核（**`??`=4**；冻结维持）
- `D:\AIContentFactory` 已完成 T134：超 125 素材盘点（**无候选**）
- `D:\AIContentFactory` 已完成 T135：观察期巡检（稳态；H1 通；`??`=4）
- `D:\AIContentFactory` 已完成 T136：L4 远程方案复核（**维持无 origin**）
- `D:\AIContentFactory` 已完成 T137：settings_env 提交评估（**无实质 diff，未 commit**）
- `D:\AIContentFactory` 已完成 T138：crawl_p1 diff 只读（**无实质 diff**）
- `D:\AIContentFactory` 已完成 T139：维持观察
- `D:\AIContentFactory` 已完成 T140：退出观察逐条报告（卡点=缺新包参数）
- `D:\AIContentFactory` 已完成 T141：LIT-11–15 立项任务单（**主题占位待填**）
- `D:\AIContentFactory` 已完成 T142：主题候选×5（未定稿；ChatGPT429→DeepSeek）
- `D:\AIContentFactory` 已完成 T143：主题定稿方案A（泡书不啃书）
- `D:\AIContentFactory` 已完成 T144：LIT-11–15 标题+hook大纲
- `D:\AIContentFactory` 已完成 T145：LIT-11–15 小红书正文×5
- `D:\AIContentFactory` 已完成 T146：LIT-11–15 配图需求表（未生成真图）
- `D:\AIContentFactory` 已完成 T147：freeze21 资产目录骨架（仅 README）
- `D:\AIContentFactory` 已完成 T148：freeze21 CSV 骨架（图路径占位）
- `D:\AIContentFactory` 已完成 T149：freeze21 ingest preview（gates 通过；未写库）
- `D:\AIContentFactory` 已完成 T150：freeze21 真图落盘（20/20 jpg → `D:\tmp\freeze21_phase31_assets`；未写库）
- `D:\AIContentFactory` 已完成 T151：freeze21 ingest confirm（LIT-11…15 → GC **126–130**；quality=pending）
- `D:\AIContentFactory` 已完成 T152：GC 126–130 quality approved
- `D:\AIContentFactory` 已完成 T153：F2 live 126 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T154：F2 live 127 **成功**
- `D:\AIContentFactory` 已完成 T155：F3 batch 126–130 **成功**（5/5）
- `D:\AIContentFactory` 已完成 T156：Freeze21 126–130 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T157：F2 live 128 **成功**
- `D:\AIContentFactory` 已完成 T158：F2 live 129 **成功**
- `D:\AIContentFactory` 已完成 T159：F2 live 130 **成功**（126–130 单条已齐）
- `D:\AIContentFactory` 已完成 T160：Freeze21 收口后状态同步（tip=`d78fd96`；库 max=130）
- `D:\AIContentFactory` 已完成 T161：维持观察
- `D:\AIContentFactory` 已完成 T162：LIT-16–20 立项任务单（**主题占位待填**）
- `D:\AIContentFactory` 已完成 T163：主题候选×5（未定稿；ChatGPT429→DeepSeek）
- `D:\AIContentFactory` 已完成 T164：主题定稿方案A（重读小时候课文）
- `D:\AIContentFactory` 已完成 T165：LIT-16–20 标题+hook大纲
- `D:\AIContentFactory` 已完成 T166：LIT-16–20 小红书正文×5
- `D:\AIContentFactory` 已完成 T167：LIT-16–20 配图需求表（未生成真图）
- `D:\AIContentFactory` 已完成 T168：freeze22 资产目录骨架（仅 README）
- `D:\AIContentFactory` 已完成 T169：freeze22 CSV 骨架（LIT-16…20；正文 T166）
- `D:\AIContentFactory` 已完成 T170：freeze22 真图 20/20（`D:\tmp\freeze22_phase31_assets`）
- `D:\AIContentFactory` 已完成 T171：freeze22 ingest preview（gates 通过；未写库）
- `D:\AIContentFactory` 已完成 T172：freeze22 ingest confirm（GC **131–135**；quality=pending）
- `D:\AIContentFactory` 已完成 T173：GC 131–135 quality approved
- `D:\AIContentFactory` 已完成 T174：F2 live 131 **成功**（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T175：F2 live 132 **成功**
- `D:\AIContentFactory` 已完成 T176：F3 batch 131–135 **成功**（5/5）
- `D:\AIContentFactory` 已完成 T177：F2 live 133 **成功**
- `D:\AIContentFactory` 已完成 T178：Freeze22 131–135 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T179：维持观察
- `D:\AIContentFactory` 已完成 T180：LIT-21–25 立项任务单（主题已定稿见 T183）
- `D:\AIContentFactory` 已完成 T181：主题候选×5（未定稿；ChatGPT429→DeepSeek）
- `D:\AIContentFactory` T182：主题定稿**已拒绝**（主题仍占位）
- `D:\AIContentFactory` 已完成 T183：主题定稿方案A（借出去的书，就是泼出去的水）
- `D:\AIContentFactory` 已完成 T184：LIT-21–25 标题+hook大纲
- `D:\AIContentFactory` 已完成 T185：LIT-21–25 小红书正文×5
- `D:\AIContentFactory` 已完成 T186：LIT-21–25 配图需求表（未生成真图）
- `D:\AIContentFactory` 已完成 T187：freeze23 资产目录骨架（仅 README）
- `D:\AIContentFactory` 已完成 T188：freeze23 CSV 骨架（LIT-21…25；正文 T185）
- `D:\AIContentFactory` 已完成 T189：freeze23 真图 20/20（`D:\tmp\freeze23_phase31_assets`）
- `D:\AIContentFactory` 已完成 T190：freeze23 ingest preview（gates 通过；未写库）
- `D:\AIContentFactory` 已完成 T191：freeze23 ingest confirm（GC **136–140**；quality=pending）
- `D:\AIContentFactory` 已完成 T192：GC 136–140 → **approved**（PublishTask=0）
- `D:\AIContentFactory` 已完成 T193：F2 live 136 **成功**（LIT-21；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T194：F2 live 137 **成功**（LIT-22；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T195：F3 batch 136–140 **成功**（5/5；未发布）
- `D:\AIContentFactory` 已完成 T196：Freeze23 136–140 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T197：维持观察
- `D:\AIContentFactory` 已完成 T198：Freeze24 立项（LIT-26…30 / GC 141–145；主题见 T200）
- `D:\AIContentFactory` 已完成 T199：主题候选×5（ChatGPT403→DeepSeek）
- `D:\AIContentFactory` 已完成 T200：主题定稿（**书籍未来的路-AI会代替书籍吗？**）
- `D:\AIContentFactory` 已完成 T201：LIT-26…30 标题+hook大纲（ChatGPT403→DeepSeek）
- `D:\AIContentFactory` 已完成 T202：LIT-26…30 小红书正文×5（ChatGPT429→DeepSeek）
- `D:\AIContentFactory` 已完成 T203：LIT-26…30 配图需求表（未生成真图）
- `D:\AIContentFactory` 已完成 T204：freeze24 资产目录骨架（仅 README）
- `D:\AIContentFactory` 已完成 T205：freeze24 CSV 骨架（LIT-26…30；正文 T202）
- `D:\AIContentFactory` 已完成 T206：freeze24 真图 20/20（`D:\tmp\freeze24_phase31_assets`）
- `D:\AIContentFactory` 已完成 T207：freeze24 ingest preview（gates 通过；未写库）
- `D:\AIContentFactory` 已完成 T208：freeze24 ingest confirm（GC **141–145**；quality=pending）
- `D:\AIContentFactory` 已完成 T209：GC 141–145 → **approved**（PublishTask=0）
- `D:\AIContentFactory` 已完成 T210：F2 live 141 **成功**（LIT-26；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T211：F2 live 142 **成功**（LIT-27；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T212：F3 batch 141–145 **成功**（5/5；未发布）
- `D:\AIContentFactory` 已完成 T213：Freeze24 141–145 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T214：维持观察
- `D:\AIContentFactory` 已完成 T215：Freeze25 立项（LIT-31…35 / GC 146–150）
- `D:\AIContentFactory` 已完成 T216：主题定稿（**建立知识库的重要性**）
- `D:\AIContentFactory` 已完成 T217：LIT-31…35 标题+hook大纲（ChatGPT403→DeepSeek）
- `D:\AIContentFactory` 已完成 T218：LIT-31…35 小红书正文×5（ChatGPT429→DeepSeek）
- `D:\AIContentFactory` 已完成 T219：LIT-31…35 配图需求表（未生成真图）
- `D:\AIContentFactory` 已完成 T220：freeze25 资产目录骨架（仅 README）
- `D:\AIContentFactory` 已完成 T221：freeze25 CSV 骨架（LIT-31…35；正文 T218）
- `D:\AIContentFactory` 已完成 T222：真图 20/20 → `D:\tmp\freeze25_phase31_assets`
- `D:\AIContentFactory` 已完成 T223：ingest preview（gates 通过；未写库）
- `D:\AIContentFactory` 已完成 T224：ingest confirm（GC **146–150**；quality=pending）
- `D:\AIContentFactory` 已完成 T225：GC 146–150 → **approved**（PublishTask=0）
- `D:\AIContentFactory` 已完成 T226：F2 live 146 **成功**（LIT-31；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T227：F2 live 147 **成功**（LIT-32；暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T228：F3 batch 146–150 **成功**（5/5；未发布）
- `D:\AIContentFactory` 已完成 T229：Freeze25 146–150 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T230：任务封存 / 维持观察（存盘退出）
- `D:\AIContentFactory` 已完成 T231–T242：Obsidian 纠偏、WATCH、复抓暂停至 09-07；分步清单见目标项目 `docs/stepwise-remaining-checklist-t242.md`
- `D:\AIContentFactory` 已完成 T243：09-07 复抓改到现在仍 **WATCH**；其后锚点链至 08-09，由 T335 执行
- `D:\AIContentFactory` 已完成 T244–T249：S6–S11 点名确认（GX 观察 / HOLD / 日更禁用）
- `D:\AIContentFactory` 已完成 T250–T264：Freeze26 LIT-36…40 → GC **151–155**（approved；F2 151–152；F3 **5/5**；未发布）
- `D:\AIContentFactory` 已完成 T265–T268：S13–S16 点名确认（本波消费 / F4·P1-A 冻结 / origin 策略）
- `D:\AIContentFactory` 已完成 T269–T271：S16 §8 建仓→remote→首推；代码仓 `0d4683c`=`origin/main`（private；敏感 `??`×4 未推）
- `D:\AIContentFactory` 已完成 T272：Freeze26 151–155 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T273–T283：Freeze27 LIT-41…45 至 CSV/真图就绪（主题「重读一本书…」）
- `D:\AIContentFactory` 已完成 T284：freeze27 ingest preview（gates 通过；图 20/20；未写库）
- `D:\AIContentFactory` 已完成 T285：freeze27 ingest confirm（LIT-41…45 → GC **156–160**；quality=pending）
- `D:\AIContentFactory` 已完成 T286：GC 156–160 → **approved**（PublishTask=0；未跑 F2）
- `D:\AIContentFactory` 已完成 T287：F2 live **156**（LIT-41；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T288（失败）：F2 live **157**（`ERR_CONNECTION_CLOSED`；未点击）
- `D:\AIContentFactory` 已完成 T289：重跑 F2 live **157**（LIT-42；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T290（部分失败）：F3 **156–160**（confirmed 156–157；failed 158；skipped 159–160）
- `D:\AIContentFactory` 已完成 T291：续跑 F3 **158–160**（3/3；合 T290 → **156–160** 全覆盖）
- `D:\AIContentFactory` 已完成 T292：Freeze27 156–160 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T293：曾维持观察至 09-14；锚点其后提前至 08-09（历史）
- `D:\AIContentFactory` 已完成 T294：Freeze28 LIT-46–50 立项骨架（主题待定稿；未写库）
- `D:\AIContentFactory` 已完成 T295：Freeze28 主题候选×5（不定稿）
- `D:\AIContentFactory` 已完成 T296：Freeze28 主题定稿（候选1「把书架当「社交圈」来整理」）
- `D:\AIContentFactory` 已完成 T297：Freeze28 LIT-46…50 标题+hook大纲
- `D:\AIContentFactory` 已完成 T298：通道打通 A1+B1+C1+D1（F4冻；P1-A前置过；DeepSeek默认；CI-only）
- `D:\AIContentFactory` 已完成 T299：Freeze28 LIT-46…50 小红书正文（不定配图）
- `D:\AIContentFactory` 已完成 T300：Freeze28 LIT-46…50 配图需求表（不定真图）
- `D:\AIContentFactory` 已完成 T301–T302：Freeze28 资产目录 + 真图 **20/20**
- `D:\AIContentFactory` 已完成 T303：Freeze28 editor export CSV（5 行；资产 missing=0）
- `D:\AIContentFactory` 已完成 T304：Freeze28 ingest preview（gates 全过；20/20 图；未写库）
- `D:\AIContentFactory` 已完成 T305：Freeze28 ingest confirm（LIT-46…50 → GC **161–165**；quality=pending）
- `D:\AIContentFactory` 已完成 T306：GC 161–165 → **approved**（PublishTask=0；未跑 F2）
- `D:\AIContentFactory` 已完成 T307：F2 live **161**（LIT-46；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T308：F2 live **162**（LIT-47；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T309：F2 live **163**（LIT-48；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T310：F2 live **164**（LIT-49；暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T311：F2 live **165**（LIT-50；暂存离开；images=4；未发布；F2 **161–165** 全覆盖）
- `D:\AIContentFactory` 已完成 T312（部分失败）：F3 **161–165**（failed 161；skipped 162–165；未发布）
- `D:\AIContentFactory` 已完成 T313：续跑 F3 **161–165**（5/5；合 T312 → 全覆盖；未发布）
- `D:\AIContentFactory` 已完成 T314：Freeze28 161–165 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T315：Freeze29 LIT-51–55 立项骨架（主题待定稿；期望 GC **166–170**；未写库）
- `D:\AIContentFactory` 已完成 T316：Freeze29 主题候选×5（不定稿）
- `D:\AIContentFactory` 已完成 T317：Freeze29 主题定稿（候选3「读不懂也没关系，先「混个眼熟」」）
- `D:\AIContentFactory` 已完成 T318：Freeze29 LIT-51…55 标题+hook大纲
- `D:\AIContentFactory` 已完成 T319：Freeze29 LIT-51…55 小红书正文（不定配图）
- `D:\AIContentFactory` 已完成 T320：Freeze29 LIT-51…55 配图需求表（不定真图）
- `D:\AIContentFactory` 已完成 T321–T322：Freeze29 资产目录 + 真图 **20/20**
- `D:\AIContentFactory` 已完成 T323：Freeze29 editor export CSV（5 行；资产 missing=0）
- `D:\AIContentFactory` 已完成 T324：Freeze29 ingest preview（gates 全过；图 20/20；未写库）
- `D:\AIContentFactory` 已完成 T325：Freeze29 ingest confirm LIT-51…55 → GC **166–170**（quality=pending）
- `D:\AIContentFactory` 已完成 T326：GC 166–170 → approved（PublishTask=0；未跑 F2）
- `D:\AIContentFactory` 已完成 T327：F2 live **166**（暂存离开；images=4；未发布）
- `D:\AIContentFactory` T328 **失败**：F2 live **167**（goto 超时；失败报告保留）
- `D:\AIContentFactory` 已完成 T329：重跑 F2 live **167**（暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T330：F2 live **168**（暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T331：F2 live **169**（暂存离开；images=4；未发布）
- `D:\AIContentFactory` 已完成 T332：F2 live **170**；F2 **166–170** 全覆盖（暂存离开；未发布）
- `D:\AIContentFactory` 已完成 T333：F3 batch **166–170**（5/5 confirmed；未发布）
- `D:\AIContentFactory` 已完成 T334：Freeze29 166–170 草稿箱收口（只文档；F4 仍冻结）
- `D:\AIContentFactory` 已完成 T335：08-09 观察节点 formal 复抓仍记 **WATCH**（未发布、未跑 F4）
- `D:\AIContentFactory` **策略变更**：T335 后 **复抓环节取消为推进前置**；**项目进入实施状态**；见目标项目 `docs/implementation-entry-after-t335.md`
- `D:\AIContentFactory` T336 **失败**：LIT-51/GC166 发布被拒（**因违反社区规范禁止发笔记**）；已停发；见 `docs/manual-publish-gc166-blocked-t336.md`
- `D:\AIContentFactory` T337：账号限制只读观察（「账号状态异常」）；维持停发
- `D:\AIContentFactory` **合规采集降级已推送** `a983c79` → `origin/main`（自动抓取默认禁用；见 `docs/xhs-compliant-data-collection-mode.md`）
- `D:\AIContentFactory` **发布账号隔离 A 已推送** `c031e3d` → `origin/main`（显式账号 + `manual_confirm`；禁默认 `platform_1`/`id=1`；见 `docs/publisher-account-isolation-impl-a.md`）
- `D:\AIContentFactory` **建档/session 隔离能力已推送** `eb4b5d3` → `origin/main`
- `D:\AIContentFactory` **恢复发布号A 已建档**：`platform_account_id=2` / session=`platform_2` / ledger=`session:publisher_recovery_001`；凭证 NULL；未进采集。见 `docs/publisher-account-session-isolation.md`
- `D:\AIContentFactory` **`platform_2` 浏览器登录态已建立**；本地 profile 继续承载人工登录态；DB 不保存明文凭证
- `D:\AIContentFactory` **`platform_account_id=2` 已激活为 `active`**：保留为备用发布账号，**但不使用**；**不再执行首发测试**
- `D:\AIContentFactory` **策略切换**：停止新笔记生产与发布；目标改为存量图文维护、复盘与账号安全观察（原账号约 80 篇图文为存量资产）；见 `docs/existing-note-maintenance-mode.md`
- `D:\AIContentFactory` **当前进入存量图文盘点 / 复盘 / 风险观察**：约 80 篇为主要资产；每次只做人工记录与分析；见 `docs/existing-note-inventory-review.md`；batch-01 空模板 `docs/existing-note-inventory-batch-01.md`
- `D:\AIContentFactory` 合规采集降级与发布账号隔离 A **继续保留为安全底座**；**不新增笔记，不首发 platform_2**；**不自动采集，不发布，不跑 F4**；不创建 publish_task / publish_plan
- `D:\AIContentFactory` 代码仓当前 **tip=`85da274`=`origin/main`**（`0 0`，本轮盘点文档未提交前工作区另有 docs 改动）；残留另含 `settings_env.py` + 冻结 `??`×4（不提交）

## 当前限制



- 已接最小真实 CI（T006 已完成），当前覆盖文档链接、任务索引和关键文件检查
- 未接外部任务系统（仅仓库内 Markdown 任务）
- 未接云端部署
- 未接监控反馈
- 分支保护已开启；通过检查后的 PR 合并链路已验证。CI 失败时是否强制拦截尚未反向验证

## 下一步建议

1. **停止新笔记生产与发布**：不重试、不换发、不跑 F4；不创建 publish_task / publish_plan；`platform_2` 备用不用、不做首发
2. **AICF tip=`85da274`**：当前进入存量图文盘点 / 复盘 / 风险观察；约 80 篇为主要资产；每次只做人工记录与分析
3. **下一入口**：人工填 batch-01（10 篇）→ `docs/existing-note-inventory-batch-01.md`；总册 `docs/existing-note-inventory-review.md`
4. 若重新发布：**重新立项并单独确认**；Freeze30+ 默认不立项

## 复制到其它项目时

1. 按 `docs/template-rollout.md` 和 `scripts/copy-workflow-template.ps1` 复制规则与骨架
2. 用 `docs/runbook.md` 跑第一个低风险任务验证
3. 再按需接入 CI、远程仓库与环境；高风险仍走 `docs/risk-approval.md`
