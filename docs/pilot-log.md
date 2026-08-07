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

## T014 目标项目恢复 shell 可执行位（AIContentFactory T005）

已在 `D:\AIContentFactory` 完成第五个低风险任务：`tasks/T005-restore-shell-executable-bits.md`。确认代码仓 `backend/backup.sh`、`backend/health_check.sh`、`backend/start_dev.sh` 在 Git HEAD/index 中已是 `100755`；Windows 工作区无法持久保存 Unix +x，故对本仓设置本地 `core.filemode=false` 消除模式误报。未改 shell 内容，未碰 playwright / Freeze20 / P1 / 大型素材，未做代码仓 commit。目标项目本地 CI 通过：Required files 10，Markdown files checked 22。

## T014 目标项目限定 playwright_engine.py 复核范围（AIContentFactory T006）

已在 `D:\AIContentFactory` 完成第六个任务：`tasks/T006-review-playwright-engine-scope.md`。该任务仅制定 `backend/app/publisher/adapters/browser/playwright_engine.py` 的只读复核范围，纳入草稿箱路径、暂存离开定位/点击保护、CDP/shadow DOM 文本定位、坐标 fallback、多图上传、字段填充回读和原发布路径新增返回字段；明确不发布、不登录、不点击、不改代码、不提交代码仓业务改动。目标项目本地 CI 通过：Required files 10，Markdown files checked 23。

## T014 目标项目登记 playwright 测试补强（AIContentFactory T007）

已在 `D:\AIContentFactory` 完成第七个低风险任务：`tasks/T007-playwright-engine-test-hardening.md`。登记代码仓未跟踪测试文件 `backend/tests/test_xhs_draft_box_save.py` 的补强点（含 ambiguous、拒绝点「发布」、禁用坐标 fallback、多图不静默降级、contenteditable 仅键盘填充等 `expectedFailure`/断言）。本轮不改 `playwright_engine.py`，不登录/发布/开浏览器，不提交代码仓。语法检查通过；unittest 因系统 Python/`.venv`/缺 `sqlalchemy` 未完整跑通，约定后续逐步测试后统一出报告。目标项目本地 CI 通过。

## T014 目标项目确认测试运行环境（AIContentFactory T008）

已在 `D:\AIContentFactory` 完成第八个任务：`tasks/T008-fix-test-runtime.md`。确认代码仓 `.venv`（Python 3.10.11）可用；从仓库根跑测会因根 `.env` 字段不全触发 Settings 失败，改为在 `backend` + `PYTHONPATH=backend` 下运行。实际跑通 `tests.test_xhs_draft_box_save`：15 tests OK（expected failures=3）。新增 `docs/test-runtime.md` 与 `scripts/run-xhs-draft-box-unit-tests.ps1`。未改引擎、未改 `.env`、未提交代码仓。

## T014 目标项目单测假 Settings（AIContentFactory T009）

已在 `D:\AIContentFactory` 完成第九个低风险任务：`tasks/T009-dummy-settings-for-unit-tests.md`。新增 `backend/tests/settings_env.py`，在 `test_xhs_draft_box_save.py` import 引擎前强制注入假 `MYSQL_*`/`REDIS_*`；运行脚本同步注入。验证进程内 Settings 使用 `MYSQL_USER=test` 等假值，不再依赖真实 `backend/.env` 密钥。单测仍为 15 OK（expected failures=3）。未改引擎、未改 `.env` 文件、未提交代码仓。

## T014 目标项目引擎 draft-box 安全修复（AIContentFactory T010）

已在用户确认「引擎执行」后完成：`tasks/T010-playwright-engine-safety-fixes.md`。修改 `playwright_engine.py`：多「暂存离开」候选 → ambiguous；真实鼠标 CDP 失败不再坐标 fallback；多图上传失败不静默单图降级。对应单测去掉 `@expectedFailure`。验证 `Ran 15 tests ... OK`。未真实登录/发布；代码仓改动尚未 git commit。

## T014 目标项目统一测试报告（AIContentFactory T011）

已在 `D:\AIContentFactory` 完成：`tasks/T011-draft-box-test-report.md`。汇总 T007–T010，产出 `docs/draft-box-test-report.md`（边界、环境、修复前后 15 tests、引擎改动摘要、残留风险）。目标项目本地 CI 通过：Required files 10，Markdown files checked 30。未改引擎、未真实发布、未提交代码仓。

## T014 目标项目代码仓提交 T009–T010

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `0ae4784`：`Add draft-box safety path and unit tests`。范围仅限 `playwright_engine.py`、`backend/tests/test_xhs_draft_box_save.py`、`backend/tests/settings_env.py`。提交前复核：单测 15 OK；未纳入 Freeze20 / P1 未跟踪脚本；未推送远程。下一步：先登记本闭环文档；再决定代码仓远程 / 推送策略；Freeze20 / P1 继续拆分处理。

## T014 目标项目远程仓库策略（AIContentFactory T012）

已在 `D:\AIContentFactory` 完成：`tasks/T012-remote-repo-plan.md`，产出 `docs/remote-repo-plan.md`。已确认选择：origin=A 暂不配置；可见性 private；CI/分支保护暂缓；平台 GitHub；仓库名建议 `AIContentFactory`。未创建远程、未 `git remote add`、未 push、未修改代码仓。目标项目本地 CI 通过。

## T014 目标项目 Freeze20 / P1 拆分方案（AIContentFactory T013/T014）

已在 `D:\AIContentFactory` 完成：`tasks/T013-freeze20-split-plan.md` 与 `tasks/T014-p1-split-plan.md`，产出 `docs/freeze20-p1-split-plan.md`。Freeze20 拆为 dry-run、单条草稿箱 live、小批量草稿箱、单条公开发布和确认 CLI；P1 拆为公开资料抓取、本地目录填表、登录/打开页面辅助、GX-001 构建/发布和临时扫描工具。本轮仅静态阅读与文档拆分，未运行脚本、未打开浏览器、未登录、未点击 `暂存离开` 或 `发布`、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 35。

## T014 目标项目 Freeze20 F1 dry-run 评审（AIContentFactory T015）

已在 `D:\AIContentFactory` 完成：`tasks/T015-freeze20-f1-dry-run-review.md`，产出 `docs/freeze20-f1-dry-run-review.md`。只读确认 F1 不点「暂存离开」/「发布」、不创建 PublishTask、不写业务库；默认 `skip_browser=False` 会开会话预检；单测 `CliArgTests` 依赖 F5 确认 CLI。未运行脚本、未打开浏览器、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 P1-B 本地目录填表评审（AIContentFactory T016）

已在 `D:\AIContentFactory` 完成：`tasks/T016-p1b-local-catalog-fill-review.md`，产出 `docs/p1b-local-catalog-fill-review.md`。只读确认 `backend/scripts/fill_p1_prescan_from_catalog.py` 无网络请求、无浏览器、无登录/点赞/评论/私信动作；输入为本地 notes catalog CSV，输出为预扫 Markdown 和 summary 文本。阻塞提交点是 `NOTES_DIR` / `OUT` / `SUMMARY` 等本机绝对路径写死，提交前建议参数化。未运行脚本、未改代码仓、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 39。

## T014 目标项目 Freeze20 F2 单条草稿箱 live 评审（AIContentFactory T017）

已在 `D:\AIContentFactory` 完成：`tasks/T017-freeze20-f2-live-draft-review.md`，产出 `docs/freeze20-f2-live-draft-review.md`。只读确认 F2 主路径调用草稿箱保存能力，不创建 PublishTask、不回写 GeneratedContent 状态、不执行公开发布；同时明确 live 执行会打开真实浏览器并点击 `暂存离开`，验证阶段可能进入草稿箱/图文笔记页面，当前仍按 WATCH/freeze 暂停执行。未运行脚本、未打开浏览器、未登录、未点击、未改代码仓、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 41。

## T014 目标项目 P1-B 路径参数化（AIContentFactory T018）

已在 `D:\AIContentFactory` 完成：`tasks/T018-p1b-path-parameterization.md`。代码仓候选脚本 `backend/scripts/fill_p1_prescan_from_catalog.py` 增加 `--notes-dir`、`--source`、`--out`、`--summary` 参数；默认输入和输出改为代码仓内相对路径，去掉个人目录硬编码。验证使用临时输出路径运行成功，生成 `prescan.md` 与 `summary.txt`，统计为 `一页folio=2`、`谈亦默=4`、`作家蓑依=4`。未访问网络、未打开浏览器、未登录、未点击、未发布；代码仓脚本仍为未跟踪，尚未提交。目标项目本地 CI 通过：Required files 10，Markdown files checked 42。

## T014 目标项目代码仓提交 P1-B 参数化脚本

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `08de0e0`：`Add parameterized P1 catalog prescan script`。范围仅限 `backend/scripts/fill_p1_prescan_from_catalog.py`（1 file, +192）。未纳入 Freeze20 / 其它 P1 未跟踪项；未推送远程（代码仓仍无 origin）。

## T014 目标项目 Freeze20 F3 小批量草稿箱评审（AIContentFactory T019）

已在 `D:\AIContentFactory` 完成：`tasks/T019-freeze20-f3-batch-review.md`，产出 `docs/freeze20-f3-batch-review.md`。只读确认 F3 batch 复用 F2 live；每波最多 5 条；拒绝 full Freeze20 dump；CLI 需要 `--batch --i-authorize-freeze20-draft-box-batch --content-ids ...`；默认首个未确认 item 后停止。F3 不公开发布、不建 PublishTask、不改 GeneratedContent 状态，但会按 item 连续点击 `暂存离开` 写入真实草稿箱。未运行脚本、未打开浏览器、未登录、未点击、未改代码仓、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 44。

## T014 目标项目 P1-A 公开资料抓取评审（AIContentFactory T020）

已在 `D:\AIContentFactory` 完成：`tasks/T020-p1a-public-profile-crawl-review.md`，产出 `docs/p1a-public-profile-crawl-review.md`。只读确认 P1-A 属公开资料研究，但两个脚本都会打开 Playwright 持久会话并访问 3 个小红书 profile；`crawl_p1_benchmark_profiles.py` 会进入笔记详情页，`crawl_p1_profile_feed_only.py` 仅抽取主页信息流标题。未见点赞、评论、收藏、私信或业务库写入；两个脚本均写死个人输出目录，提交前建议参数化并加授权门禁。未运行脚本、未打开浏览器、未登录、未访问小红书、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 46。

## T014 目标项目代码仓提交 P1-A feed-only 脚本

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `a9a4ea2`：`Add authorized P1A feed-only crawl script`。范围仅限 `backend/scripts/crawl_p1_profile_feed_only.py`（1 file, +314）。提交前验证：`--help` 正常；无授权运行直接拒绝；AST 解析通过；未运行抓取、未打开浏览器、未登录、未访问小红书。未纳入详情版抓取、P1-C、P1-D、Freeze20 或大型目录；未推送远程（代码仓仍无 origin）。

## T014 目标项目 P1-C 登录 / 打开页面辅助评审（AIContentFactory T021）

已在 `D:\AIContentFactory` 完成：`tasks/T021-p1c-login-page-helper-review.md`，产出 `docs/p1c-login-page-helper-review.md`。只读确认三个脚本都会启动 Playwright 持久会话并复用 `platform_1`；登录脚本会等待扫码并写 status / screenshot；发布页辅助脚本会打开 creator 发布相关页面，但未见自动点击 `发布`。未运行脚本、未打开浏览器、未登录、未打开登录页/发布页、未截图、未点击、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 48。

## T014 目标项目 F4 / P1-D 公开发布脚本暂缓清单（AIContentFactory T022）

已在 `D:\AIContentFactory` 完成：`tasks/T022-publish-script-defer-list.md`，产出 `docs/publish-script-defer-list.md`。只读确认 `freeze20_publish_one.py` 与 `freeze20_publish_one_confirm.py` 会公开发布单条 Freeze20，`publish_gx001_local.py` 会公开发布 GX-001，均禁止执行；`rebuild_gx001_local.py` 不发布，但会复制素材并写发布包 / 排期 / 协查文件，需 build-only 单独审批。未运行脚本、未打开浏览器、未登录、未打开发布页、未上传图片、未点击 `暂存离开` 或 `发布`、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 50。

## T014 目标项目代码仓提交 GX001 build pack 脚本

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `22de269`：`Add authorized GX001 build pack script`。范围仅限 `backend/scripts/rebuild_gx001_local.py`（1 file, +326）。提交前验证：`--help` 正常；无授权运行直接拒绝；AST 解析通过。未运行真实构建、未复制素材、未打开浏览器、未登录、未发布。未纳入 `publish_gx001_local.py`、F4 publish-one、P1-C、Freeze20 或大型目录；未推送远程（代码仓仍无 origin）。

## T014 目标项目 P1-E 临时扫描工具只读评审（AIContentFactory T023）

已在 `D:\AIContentFactory` 完成：`tasks/T023-p1e-temp-merge-scan-review.md`，产出 `docs/p1e-temp-merge-scan-review.md`。只读确认 `_tmp_merge_scan.py` 会启动 Playwright、复用 `xiaohongshu/platform_1`、访问两个小红书 profile、滚动抽取 `/explore/` 链接，并写入个人目录下的合并清单。当前不应提交该临时脚本；如保留需重命名、参数化、授权门禁和低频公开资料审批。未运行脚本、未打开浏览器、未登录、未访问小红书、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 52。

## T014 目标项目 Freeze20 F1/F5/F2/F3 提交边界重排（AIContentFactory T024）

已在 `D:\AIContentFactory` 完成：`tasks/T024-freeze20-submit-boundary-plan.md`，产出 `docs/freeze20-submit-boundary-plan.md`。只读整理提交顺序、依赖关系和测试边界，建议拆为三包：F1 dry-run + F5 基础 CLI；F2 单条 live；F3 小批量 batch。F4 publish-one 继续暂缓，不进入本轮提交边界。未运行脚本、未打开浏览器、未登录、未点击 `暂存离开` 或 `发布`、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 54。

## T014 目标项目 Freeze20 包 1 提交准备（AIContentFactory T025）

已在 `D:\AIContentFactory` 完成：`tasks/T025-freeze20-package1-submit-prep.md`，产出 `docs/freeze20-package1-submit-prep.md`。包 1 候选为 3 个未跟踪文件：`freeze20_draft_box_dry_run.py`、`test_freeze20_draft_box_dry_run.py`、`freeze20_draft_box_upload_confirm.py`。3 文件 AST 解析通过；F1 单测未跑通（项目 `.venv` 启动失败；Codex 内置 Python 缺 `sqlalchemy`）。未运行 Freeze20 业务脚本、未打开浏览器、未登录、未点击、未提交代码仓。包 1 进入代码提交前须先修复或指定可用测试环境。

## T014 目标项目 Freeze20 F1 单测环境处理（AIContentFactory T026）

已在 `D:\AIContentFactory` 完成：`tasks/T026-freeze20-f1-test-env.md`，产出 `docs/freeze20-f1-test-env.md`。确认 `.venv` 中已有 `sqlalchemy`，但当前沙箱无法启动 `.venv` Python；Codex 内置 Python 可启动但不能混用 `.venv` 的 Python 3.10 原生依赖，卡在 `pydantic_core`。已给出本机 PowerShell 推荐测试命令。未安装依赖、未重建 `.venv`、未运行 Freeze20 业务脚本、未打开浏览器、未登录、未点击、未提交代码仓。目标项目本地 CI 通过：Required files 10，Markdown files checked 58。

## T014 目标项目代码仓提交 Freeze20 包 1

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `453b68d`：`Add Freeze20 dry-run and guarded CLI`。范围仅限 `backend/app/public_account_research/freeze20_draft_box_dry_run.py`、`backend/tests/test_freeze20_draft_box_dry_run.py`、`scripts/freeze20_draft_box_upload_confirm.py`（3 files, +1121）。提交前本机 PowerShell 跑通 F1 单测：`Ran 7 tests ... OK`。未纳入 F2 / F3 / F4 / P1 / `tmp_freeze20/` / 大型目录；未推送远程（代码仓仍无 origin）。

## T014 目标项目 Freeze20 包 2 提交准备（AIContentFactory T027）

已在 `D:\AIContentFactory` 完成：`tasks/T027-freeze20-package2-submit-prep.md`，产出 `docs/freeze20-package2-submit-prep.md`。候选仅 2 个未跟踪文件（F2 live + 单测）；F5 CLI 已在包 1。本机 mock 单测：F1 7 OK、F2 7 OK。未运行 live、未打开浏览器、未登录、未点击、未提交代码仓。真实 live / VERIFY 继续暂缓。

## T014 目标项目代码仓提交 Freeze20 包 2

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `716c73c`：`Add Freeze20 single-id live draft helpers`。范围仅限 `backend/app/public_account_research/freeze20_draft_box_live.py`、`backend/tests/test_freeze20_draft_box_live.py`（2 files, +652）。未纳入 F3 / F4 / P1 / 大型目录；未推送远程。代码落库不等于批准真实 live 执行。

## T014 目标项目 Freeze20 包 3 提交准备（AIContentFactory T028）

已在 `D:\AIContentFactory` 完成：`tasks/T028-freeze20-package3-submit-prep.md`，产出 `docs/freeze20-package3-submit-prep.md`。候选仅 2 个未跟踪文件（F3 batch + 单测）；F5 CLI 已在包 1。本机 mock 单测合计 22 OK（F1+F2+F3）。未运行 batch、未打开浏览器、未登录、未点击、未提交代码仓。真实 batch 继续暂缓。

## T014 目标项目代码仓提交 Freeze20 包 3

用户确认后，在代码仓 `D:\AIContentFactory\repo\AIContentFactory` 本地提交 `c6b7b6a`：`Add Freeze20 small-batch draft helpers`。范围仅限 `backend/app/public_account_research/freeze20_draft_box_batch.py`、`backend/tests/test_freeze20_draft_box_batch.py`（2 files, +412）。未纳入 F4 / P1 / 大型目录；未推送远程。代码落库不等于批准真实 batch 执行。

## T014 目标项目 Freeze20 F1–F3 提交后状态报告（AIContentFactory T029）

已在 `D:\AIContentFactory` 完成：`tasks/T029-freeze20-f1f3-post-submit-status.md`，产出 `docs/freeze20-f1f3-post-submit-status.md`。确认 F1–F3 草稿箱链路（含 CLI）已本地提交收口；剩余未跟踪为 F4 publish、P1 残留（详情抓取 / 登录开页辅助 / GX 公开发布）、`_tmp_merge_scan.py`、以及 `tmp_freeze20/` 与大型中文目录。未运行脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 P1-E 稳定化方案与删除（AIContentFactory T030/T031）

已在 `D:\AIContentFactory` 完成：`tasks/T030-p1e-temp-scan-stabilization-plan.md`（方案 A 不保留落库）与 `tasks/T031-p1e-delete-tmp-merge-scan.md`。用户确认后删除工作区未跟踪文件 `backend/scripts/_tmp_merge_scan.py`；未 `git add`、未 commit、未 push；未动 F4 / 其它 P1 / 大目录。未运行脚本、未打开浏览器。目标项目本地 CI 通过。

## T014 目标项目剩余未跟踪盘点（AIContentFactory T032）

已在 `D:\AIContentFactory` 完成：`tasks/T032-remaining-untracked-inventory.md`，产出 `docs/remaining-untracked-inventory.md`。P1-E 删除后剩余未跟踪 10 项：F4×3、P1×5、大目录×2。未运行脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目代码仓远程策略复核（AIContentFactory T033）

已在 `D:\AIContentFactory` 完成：`tasks/T033-remote-repo-plan-review.md`，产出 `docs/remote-repo-plan-review.md`。复核结论维持 T012：暂不配置 origin、GitHub private、CI/分支保护暂缓。未创建远程、未 `git remote add`、未 push、未改代码仓。当前 tip=`c6b7b6a`，仍无 `origin` / `.github`。目标项目本地 CI 通过。

## T014 目标项目 P1-A 详情版只读评审（AIContentFactory T034）

已在 `D:\AIContentFactory` 完成：`tasks/T034-p1a-detail-crawl-review.md`，产出 `docs/p1a-detail-crawl-review.md`。仅评审未跟踪文件 `crawl_p1_benchmark_profiles.py`：会开浏览器、复用 `platform_1`、进笔记详情（每号最多 12）、无授权门禁、输出写死个人目录；未见点赞/评论/私信/业务库写入。结论：只读通过，运行与提交暂缓。处置建议 A 暂缓保留 / B 改造 / C 删除，未执行。未运行脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 P1-A 详情版参数化方案与落地（AIContentFactory T035/T036）

已在 `D:\AIContentFactory` 完成：`tasks/T035-p1a-detail-param-auth-plan.md` 与 `tasks/T036-p1a-detail-param-auth-impl.md`，产出 `docs/p1a-detail-param-auth-plan.md`、`docs/p1a-detail-param-auth-impl.md`。按方案 B 改造未跟踪脚本 `crawl_p1_benchmark_profiles.py`：独立授权 `--i-authorize-p1a-detail-crawl`、默认输出 `backend/data/public_research/p1_profile_detail/`、保守默认 limit=5；`py_compile` 通过，无授权 exit 2。未打开浏览器、未登录、未真实抓取、未提交代码仓。目标项目本地 CI 通过。

## T015 推送失败降级策略（CLI → Desktop）

已完成：`docs/push-fallback.md`、`scripts/push-with-fallback.ps1`、`.gitignore`（忽略 `.pending-desktop-push.json`），并在 `docs/runbook.md` 增加远程推送降级入口。约定：push 失败最多短试 1～2 次，记本地 tip，标「待人工 Desktop 推送」，不死等；网络恢复后用户发「同意推送三方闭环」。本地 CI 通过。

## T014 目标项目 P1-A 详情版提交准备与代码仓提交（AIContentFactory T037）

已在 `D:\AIContentFactory` 完成：`tasks/T037-p1a-detail-submit-prep.md`，产出 `docs/p1a-detail-submit-prep.md`。用户确认后，代码仓本地提交 `0672a73`：`Add authorized P1A detail crawl script`。范围仅限 `backend/scripts/crawl_p1_benchmark_profiles.py`（1 file）。未推送远程（代码仓无 origin）；未运行真实抓取；不等于批准真实抓取。F4 / P1-C / 大目录仍未跟踪。

## T014 目标项目 P1-C 三脚本处置策略（AIContentFactory T038）

已在 `D:\AIContentFactory` 完成：`tasks/T038-p1c-disposition-plan.md`，产出 `docs/p1c-disposition-plan.md`。只读整理 `ensure_www_xhs_login.py`、`open_xhs_login_local.py`、`open_xhs_publish_page_local.py`：均会开浏览器并复用 `platform_1`、无授权 flag；未见自动点发布。推荐默认 K0 暂缓保留未跟踪；publish 辅助单独隔离。未运行、未改脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目大目录 ignore 落地（AIContentFactory T039）

已在 `D:\AIContentFactory` 完成：`tasks/T039-large-dir-ignore-plan.md`，产出 `docs/large-dir-ignore-plan.md`。用户确认后，代码仓本地提交 `0d4683c`：`Ignore local Freeze20 and media working trees`。范围仅限 `.gitignore` 追加 `tmp_freeze20/` 与 `小红书阅读视频生产系统/`。未删除目录、未推送（无 origin）；`git status` 中二者不再以 `??` 出现。剩余未跟踪：F4×3、P1-C×3、`publish_gx001_local`。

## T014 目标项目剩余高风险冻结清单复核（AIContentFactory T040）

已在 `D:\AIContentFactory` 完成：`tasks/T040-remaining-high-risk-freeze.md`，产出 `docs/remaining-high-risk-freeze.md`。只读复核：F4 三件套与 `publish_gx001_local` 禁止执行且不提交；P1-C 三脚本禁止执行、K0 不提交；已入库 F2/F3/详情抓取禁止真实跑。当前代码仓 `??` 共 7 项。无解除冻结项。未运行、未改代码仓。目标项目本地 CI 通过。

## T014 目标项目 Freeze20/P1 阶段收口报告（AIContentFactory T041）

已在 `D:\AIContentFactory` 完成：`tasks/T041-freeze20-p1-stage-closeout.md`，产出 `docs/freeze20-p1-stage-closeout.md`。汇总拆分→冻结完成度：F1–F3 / P1-A / P1-B / GX build / 大目录 ignore 已本地落库；F4 / P1-C 运行 / publish / 真实 live·batch·详情抓取维持冻结。代码仓 tip=`0d4683c`、无 origin；三方闭环当时对齐 `4b3d2f5`。未解除冻结、未改代码仓。目标项目本地 CI 通过。

## T014 目标项目远程落地暂缓与删除 publish 开页辅助（AIContentFactory T042/T043）

已在 `D:\AIContentFactory` 完成 T042 远程落地方案后，用户确认 **暂缓 B，维持无 origin**（不建仓、不 remote add、不 push）。随后确认选项 A：删除工作区未跟踪文件 `backend/scripts/open_xhs_publish_page_local.py`（T043）；未 git add、未提交代码仓；未动其余 P1-C / F4 / `publish_gx001_local`。当前敏感 `??` 为 6 项。目标项目本地 CI 通过。

## T014 目标项目 P1-A feed-only 受控真跑（AIContentFactory T044）

用户确认选项 1 后，在代码仓执行已提交脚本 `crawl_p1_profile_feed_only.py`：`--i-authorize-p1a-feed-crawl --limit-per-profile 8 --scroll-rounds 2`。先补装 Playwright Chromium，再跑通 exit 0。汇总 atmosphere=0 / slow=8 / other=16；输出在 ignore 的 `backend/data/public_research/p1_profile_feed/`。未进详情、未发布、未提交代码仓。见 `D:\AIContentFactory\docs\p1a-feed-only-controlled-run.md`。目标项目本地 CI 通过。

## T014 目标项目 P1-A feed-only 第二轮（AIContentFactory T045）

用户确认 `limit=12`、`scroll=3` 后重跑同脚本。exit 0；atmosphere=0 / slow=7 / other=29；输出覆盖同一 ignore 目录。未进详情、未发布、未提交代码仓。见 `D:\AIContentFactory\docs\p1a-feed-only-controlled-run-round2.md`。目标项目本地 CI 通过。

## T014 目标项目 F4 / 公开发布禁止执行归档强化（AIContentFactory T046）

已在 `D:\AIContentFactory` 完成：`tasks/T046-f4-publish-forbid-archive.md`，产出 `docs/f4-publish-forbid-archive.md`。强化禁止对象、脚本内授权 flag ≠ 任务审批、解冻最低门槛与 Agent 禁令；交叉链接 T022/T040/收口文档。未运行发布脚本、未改代码仓、未提交代码仓、未解除冻结。目标项目本地 CI 通过。

## T014 目标项目 P1-A feed-only 第三轮（AIContentFactory T047）

用户确认选 A：`limit=12`、`scroll=3`、`pause=1500`；不进详情、不发布、不提交。执行 `crawl_p1_profile_feed_only.py --i-authorize-p1a-feed-crawl`。exit 0；atmosphere=0 / slow=7 / other=29（与 T045 同参一致）；输出覆盖 ignore 目录。未进详情、未发布、未提交代码仓。见 `D:\AIContentFactory\docs\p1a-feed-only-controlled-run-round3.md`。目标项目本地 CI 通过。

## T014 目标项目 P1-A feed-only 三轮汇总（AIContentFactory T048）

已在 `D:\AIContentFactory` 完成：`tasks/T048-p1a-feed-only-three-round-summary.md`，产出 `docs/p1a-feed-only-three-round-summary.md`。对照 T044/T045/T047：同参第三轮无增量；建议停止同参 feed-only；详情默认暂不升级，升级须另开高敏感审批。未真跑、未改代码仓、未解除冻结。目标项目本地 CI 通过。

## T014 目标项目 F2 live 改期（AIContentFactory T049）

用户批准 F2 live（content-id=106、session-key=platform_1、仅「暂存离开」）后尝试执行；在连接 MySQL `127.0.0.1:3306` 时失败（连接被拒绝）。未开浏览器、未点「暂存离开」/「发布」、未提交代码仓。用户确认选择 **取消或改期**：等 MySQL 明确可用后再单独批准重跑；本次审批不自动延续。见 `D:\AIContentFactory\docs\freeze20-f2-live-106-t049.md`。目标项目本地 CI 通过。

## T014 目标项目 MySQL 前置清单（AIContentFactory T050）

已在 `D:\AIContentFactory` 完成：`tasks/T050-mysql-local-prereq-checklist.md`，产出 `docs/mysql-local-prereq-checklist-t049.md`。只读列出重跑 T049 前硬前置（MySQL 可连、GC 106、新审批、禁止发布）及服务/素材自检项。未启动服务、未改配置、未重跑 F2。满足清单 ≠ 批准重跑。目标项目本地 CI 通过。

## T014 目标项目 MySQL H1 连通性检查（AIContentFactory T051）

已在 `D:\AIContentFactory` 完成：`tasks/T051-mysql-h1-connectivity-check.md`，产出 `docs/mysql-h1-connectivity-check-t051.md`。只读检查：`127.0.0.1:3306` TCP 失败；无 MySQL/MariaDB 服务；无 Docker；`backend/.env` 含 MYSQL_* 键名（未读密钥）。H1 **未满足**；未开浏览器、未重跑 F2、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 MySQL 状态/启动备忘（AIContentFactory T052）

已在 `D:\AIContentFactory` 完成：`tasks/T052-mysql-service-status-startup-notes.md`，产出 `docs/mysql-service-status-startup-notes-t052.md`。确认记录（H1 未满足、H2 未检、F2 不重跑、T049 授权不沿用）与仓库约定（compose/`ai_mysql`、`start_dev.sh`）；本机无 Docker CLI。未启服务、未改配置。目标项目本地 CI 通过。

## T014 目标项目敏感 `??` 冻结复核（AIContentFactory T053）

已在 `D:\AIContentFactory` 完成：`tasks/T053-remaining-sensitive-untracked-freeze-review.md`，产出 `docs/remaining-sensitive-untracked-freeze-review.md`。用户选 C 维持 F2 改期后只读复核：敏感 `??` 仍为 6 项（F4×3 + P1-C×2 + publish_gx001）；维持冻结执行/不提交；无低风险可删或 ignore 项。未运行、未改配置、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目阶段二收口（AIContentFactory T054）

已在 `D:\AIContentFactory` 完成：`tasks/T054-phase2-closeout.md`，产出 `docs/phase2-closeout-t044-t053.md`。汇总 T044–T053、feed-only 同参结论、F2 MySQL 阻塞与改期、剩余冻结与下一入口；执行面冻结维持。未启服务、未重跑高风险、未提交代码仓。目标项目本地 CI 通过。三方闭环当时远程 tip=`e910df2`。

## T014 目标项目维持观察（AIContentFactory T055）

用户确认阶段二后入口 **A — 维持观察**：不启服务、不重跑 F2、不动敏感 `??`，高风险面继续冻结。见 `D:\AIContentFactory\docs\phase2-maintain-observation.md`。未改代码仓、未运行脚本。目标项目本地 CI 通过。三方闭环当时远程 tip=`3e2b635`。

## T014 目标项目观察期巡检（AIContentFactory T056）

已在 `D:\AIContentFactory` 完成：`tasks/T056-observation-status-patrol.md`，产出 `docs/observation-status-patrol-t056.md`。只读确认：三方闭环 `9586d20` 对齐且 pending 无；代码仓 `0d4683c` 无 origin；敏感 `??` 仍 6；H1 TCP 失败；H2 未检；观察边界无漂移。未启服务、未跑业务脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目阶段成果索引（AIContentFactory T057）

已在 `D:\AIContentFactory` 完成：`tasks/T057-phase-results-index.md`，产出 `docs/phase-results-index.md`。低风险总入口，链接 T041/T054/T055–T056、冻结清单、feed-only 报告、F2/MySQL 改期文档、远程策略；并挂到目标项目 `README.md` 与 `project-status.md`。索引 ≠ 执行授权。未启服务、未解除冻结。目标项目本地 CI 通过。三方闭环当时远程 tip=`1a0e39d`。

## T014 目标项目未完成与冻结清单（AIContentFactory T058）

已在 `D:\AIContentFactory` 完成：`tasks/T058-unfinished-and-frozen-task-list.md`，产出 `docs/unfinished-and-frozen-task-list.md`。只读汇总：已完成不再重复（T041/T048/T054–T057）、H1/H2/H3 前置阻塞、冻结项与低风险可选入口。形成观察期后 checkpoint；未启服务、未重跑高风险、未提交代码仓。目标项目本地 CI 通过。三方闭环当时远程 tip=`a03bd42`。

## T014 目标项目 H1 复检（AIContentFactory T059 / L1）

用户确认 L1。已在 `D:\AIContentFactory` 完成：`tasks/T059-h1-recheck.md`，产出 `docs/h1-recheck-t059.md`。只读：`127.0.0.1:3306` 仍不可达；无 Windows MySQL/MariaDB 服务；无 Docker/`ai_mysql`。**H1 仍未满足**（与 T051 一致）；不得进入 H2 / F2 live。未启服务、未重跑 F2、未提交代码仓。目标项目本地 CI 通过。三方闭环当时远程 tip=`51b9f3b`。

## T014 目标项目 P1-C 删除候选评估（AIContentFactory T060 / L2）

用户确认 L2。已在 `D:\AIContentFactory` 完成：`tasks/T060-p1c-delete-candidate-assessment.md`，产出 `docs/p1c-delete-candidate-assessment-t060.md`。只评估：`ensure_www_xhs_login.py` / `open_xhs_login_local.py` 建议继续 K0；`open_xhs_publish_page_local.py` 已在 T043 删除。真删须 L3 另批点名文件。未删文件、未运行脚本、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目代码仓远程方案复核（AIContentFactory T061 / L4）

用户确认 L4。已在 `D:\AIContentFactory` 完成：`tasks/T061-remote-repo-plan-recheck.md`，产出 `docs/remote-repo-plan-recheck-t061.md`。只读复核：代码仓 tip=`0d4683c`；仍无 origin / `.github`；敏感 `??` 现 6 项；大目录 ignore 仍有效。结论 **维持暂缓 B / 无 origin**（T042 选项 4 仍有效）。未建仓、未 remote add、未 push、未改代码仓。目标项目本地 CI 通过。三方闭环当时本地 tip=`df4e84b`。

## T014 目标项目 P1-C 删除 open_xhs_login_local.py（AIContentFactory T062 / L3）

用户确认 L3 点名删除。已在 `D:\AIContentFactory` 完成：`tasks/T062-p1c-delete-open-xhs-login-local.md`，产出 `docs/p1c-delete-open-xhs-login-local-t062.md`。已删除代码仓工作区未跟踪文件 `backend/scripts/open_xhs_login_local.py`；`ensure_www_xhs_login.py` 保留（K0）；敏感 `??` 现 5；代码仓 tip 仍为 `0d4683c`（**未提交**）。未运行脚本、未改 remote。目标项目本地 CI 通过。三方闭环当时远程 tip=`47d1d16`。

## T014 目标项目 Docker / MySQL 通路与 H1–H2（AIContentFactory T063–T071）

已在 `D:\AIContentFactory` 完成 T063–T071 链路：T063/T064 H1 仍失败（无 Docker）→ T065 winget 安装 Docker Desktop → T066 compose 起 `ai_mysql`/`ai_redis` → T067 H1 满足 → T068 H2 初败（1045/空库）→ T069 创建 `aicontent` 用户 → T070 schema+导入 GC 106–125 → T071 将 GC 106 设为 approved（H2 满足）。文档见各 `docs/*-t06x` / `docs/*-t07x`。未跑 F2（至 T071）、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=106（AIContentFactory T072）

用户确认 H3：`--live` content-id=106 / session=`platform_1` / 仅暂存离开 / 禁止发布等。已完成：`tasks/T072-f2-live-106.md`，产出 `docs/freeze20-f2-live-106-t072.md` 与 `tmp_freeze20/reports/freeze20_t072_draft_box_live_106.*`。结果：**成功**（exit 0）；已点「暂存离开」、4 图、草稿箱校验命中；**未点发布**、无 PublishTask、未提交代码仓。本次 H3 授权已消费；F3/再跑须新审批。目标项目本地 CI 通过。三方闭环当时远程 tip=`71c7524`。

## T014 目标项目剩余冻结项复核（AIContentFactory T074 / L5）

用户确认稳态优先走 L5（L3 暂缓）。已在 `D:\AIContentFactory` 完成：`tasks/T074-remaining-freeze-l5-review.md`，产出 `docs/remaining-freeze-l5-review-t074.md`。只读：敏感 `??` **仍为 5**；F4/GX/P1-C 冻结维持；未删 `ensure_www_xhs_login.py`、未解除冻结、未提交代码仓。旁注：复核时点 MySQL 3306 不可达、Docker 引擎未起。目标项目本地 CI 通过。三方闭环 tip=`937a974`（已推送对齐）。

## T014 目标项目 P1-C 删除 ensure_www_xhs_login.py（AIContentFactory T075 / L3）

用户确认句删除。已在 `D:\AIContentFactory` 完成：`tasks/T075-p1c-delete-ensure-www-xhs-login.md`，产出 `docs/p1c-delete-ensure-www-xhs-login-t075.md`。已删除代码仓工作区未跟踪 `backend/scripts/ensure_www_xhs_login.py`；敏感 `??`→**4**（F4×3 + publish_gx001）；代码仓 tip 仍 `0d4683c`（**未提交**）。未运行脚本、未删 F4/GX。目标项目本地 CI 通过。

## T014 目标项目 H1 复检（AIContentFactory T076 / L1）

用户确认只读不启服务。已在 `D:\AIContentFactory` 完成：`tasks/T076-h1-recheck.md`，产出 `docs/h1-recheck-t076.md`。`3306` 不通；`com.docker.service` Stopped；Docker 引擎未起。**H1 未满足**（相对 T067 回退）。未启服务、未跑 F2、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目启动 Docker + compose（AIContentFactory T077）

用户确认启动 Docker Desktop 并 compose up `ai_mysql`/`ai_redis`（不跑 F2）。已完成：`tasks/T077-docker-compose-start.md`，产出 `docs/docker-compose-start-t077.md`。引擎就绪；两容器 Running；3306/6379 TCP True；未改 `.env`、未跑 F2、未提交代码仓。正式 H1 须另开 L1。目标项目本地 CI 通过。

## T014 目标项目 H1 复检（AIContentFactory T078 / L1）

用户确认只读不启服务。已在 `D:\AIContentFactory` 完成：`tasks/T078-h1-recheck.md`，产出 `docs/h1-recheck-t078.md`。`3306` TCP True；`ai_mysql`/`ai_redis` Up。**H1 已满足**。未启新服务、未跑 F2、未检 H2、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 106（AIContentFactory T079）

用户确认只读检 GC 106 与 F2 gate（不启服务、不跑 F2、不发布）。已完成：`tasks/T079-h2-gc106-check.md`，产出 `docs/h2-gc106-check-t079.md`。连库 ok；GC 106 approved；images 4/4；**gate_ok=True → H2 已满足**。未跑 F2、未开浏览器、未发布、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=106（AIContentFactory T080）

用户确认 H3：`--live` content-id=106 / session=`platform_1` / 仅暂存离开 / 禁止发布/F3/F4/提交。已完成：`tasks/T080-f2-live-106.md`，产出 `docs/freeze20-f2-live-106-t080.md` 与 `tmp_freeze20/reports/freeze20_t080_draft_box_live_106.*`。结果：**成功**（exit 0）；已点「暂存离开」、4 图、草稿箱校验命中；**未点发布**、无 PublishTask、未提交代码仓。本次 H3 授权已消费；F3/再跑须新审批。目标项目本地 CI 通过。

## T014 目标项目剩余冻结项复核（AIContentFactory T081 / L5）

用户确认只读不改文件。已在 `D:\AIContentFactory` 完成：`tasks/T081-remaining-freeze-l5-review.md`，产出 `docs/remaining-freeze-l5-review-t081.md`。敏感 `??` **=4**（F4×3+GX）；冻结维持；未删未跑未提交。目标项目本地 CI 通过。三方闭环 tip=`746e7ad`。

## T014 目标项目 F2 live content-id=106（AIContentFactory T082）

用户确认 H3：`--live` content-id=106 / session=`platform_1` / 仅暂存离开 / 禁止发布/F3/F4/提交。已完成：`tasks/T082-f2-live-106.md`，产出 `docs/freeze20-f2-live-106-t082.md` 与 `tmp_freeze20/reports/freeze20_t082_draft_box_live_106.*`。结果：**成功**（exit 0）；已点「暂存离开」、4 图、草稿箱命中；**未点发布**、未提交代码仓。本次 H3 授权已消费。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=106（AIContentFactory T083）

用户确认 H3 同参再跑。已完成：`tasks/T083-f2-live-106.md`，产出 `docs/freeze20-f2-live-106-t083.md` 与 `tmp_freeze20/reports/freeze20_t083_draft_box_live_106.*`。**成功**；暂存离开；未发布；未提交。H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 107（AIContentFactory T084）

用户确认只读检 content_id=107。已完成：`tasks/T084-h2-gc107-check.md`，产出 `docs/h2-gc107-check-t084.md`。GC 107 可读、images 4/4，但 **quality=pending** → **H2 未满足**。未改库、未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 GC 107 设为 approved（AIContentFactory T085）

用户确认。已完成：`tasks/T085-gc107-quality-approved.md`，产出 `docs/gc107-quality-approved-t085.md`。quality pending→**approved**；**gate_ok=True → H2(107) 已满足**；PublishTask=0；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=107（AIContentFactory T086）

用户确认 H3：content-id=107 / session=`platform_1` / 仅暂存离开 / 禁止发布/F3/F4/提交。已完成：`tasks/T086-f2-live-107.md`，产出 `docs/freeze20-f2-live-107-t086.md` 与 `tmp_freeze20/reports/freeze20_t086_draft_box_live_107.*`。**成功**；暂存离开；未发布；未提交。H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 108（AIContentFactory T087）

用户确认只读检 content_id=108。已完成：`tasks/T087-h2-gc108-check.md`，产出 `docs/h2-gc108-check-t087.md`。GC 108 / CAR-03；images 4/4；**quality=pending → H2 未满足**。未改库、未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 GC 108 设为 approved（AIContentFactory T088）

用户确认。已完成：`tasks/T088-gc108-quality-approved.md`，产出 `docs/gc108-quality-approved-t088.md`。pending→**approved**；**H2(108) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=108（AIContentFactory T089）

用户确认 H3：content-id=108 / platform_1 / 仅暂存离开。已完成：`tasks/T089-f2-live-108.md`，产出 `docs/freeze20-f2-live-108-t089.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 109（AIContentFactory T090）

用户确认只读检 content_id=109。已完成：`tasks/T090-h2-gc109-check.md`，产出 `docs/h2-gc109-check-t090.md`。GC 109 / CAR-04；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 109 设为 approved（AIContentFactory T091）

用户确认。已完成：`tasks/T091-gc109-quality-approved.md`，产出 `docs/gc109-quality-approved-t091.md`。pending→**approved**；**H2(109) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=109（AIContentFactory T092）

用户确认 H3：content-id=109 / platform_1 / 仅暂存离开。已完成：`tasks/T092-f2-live-109.md`，产出 `docs/freeze20-f2-live-109-t092.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 110（AIContentFactory T093）

用户确认只读检 content_id=110。已完成：`tasks/T093-h2-gc110-check.md`，产出 `docs/h2-gc110-check-t093.md`。GC 110 / CAR-05；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 110 设为 approved（AIContentFactory T094）

用户确认。已完成：`tasks/T094-gc110-quality-approved.md`，产出 `docs/gc110-quality-approved-t094.md`。pending→**approved**；**H2(110) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=110（AIContentFactory T095）

用户确认 H3：content-id=110 / platform_1 / 仅暂存离开。已完成：`tasks/T095-f2-live-110.md`，产出 `docs/freeze20-f2-live-110-t095.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 111（AIContentFactory T096）

用户确认只读检 content_id=111。已完成：`tasks/T096-h2-gc111-check.md`，产出 `docs/h2-gc111-check-t096.md`。GC 111 / CAR-06；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 111 设为 approved（AIContentFactory T097）

用户确认。已完成：`tasks/T097-gc111-quality-approved.md`，产出 `docs/gc111-quality-approved-t097.md`。pending→**approved**；**H2(111) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=111（AIContentFactory T098）

用户确认 H3：content-id=111 / platform_1 / 仅暂存离开。已完成：`tasks/T098-f2-live-111.md`，产出 `docs/freeze20-f2-live-111-t098.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 112（AIContentFactory T099）

用户确认只读检 content_id=112。已完成：`tasks/T099-h2-gc112-check.md`，产出 `docs/h2-gc112-check-t099.md`。GC 112 / CAR-07；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 112 设为 approved（AIContentFactory T100）

用户确认。已完成：`tasks/T100-gc112-quality-approved.md`，产出 `docs/gc112-quality-approved-t100.md`。pending→**approved**；**H2(112) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=112（AIContentFactory T101）

用户确认 H3：content-id=112 / platform_1 / 仅暂存离开。已完成：`tasks/T101-f2-live-112.md`，产出 `docs/freeze20-f2-live-112-t101.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 113（AIContentFactory T102）

用户确认只读检 content_id=113。已完成：`tasks/T102-h2-gc113-check.md`，产出 `docs/h2-gc113-check-t102.md`。GC 113 / CAR-08；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 113 设为 approved（AIContentFactory T103）

用户确认。已完成：`tasks/T103-gc113-quality-approved.md`，产出 `docs/gc113-quality-approved-t103.md`。pending→**approved**；**H2(113) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=113（AIContentFactory T104）

用户确认 H3：content-id=113 / platform_1 / 仅暂存离开。已完成：`tasks/T104-f2-live-113.md`，产出 `docs/freeze20-f2-live-113-t104.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 114（AIContentFactory T105）

用户确认只读检 content_id=114。已完成：`tasks/T105-h2-gc114-check.md`，产出 `docs/h2-gc114-check-t105.md`。GC 114 / CAR-09；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 114 设为 approved（AIContentFactory T106）

用户确认。已完成：`tasks/T106-gc114-quality-approved.md`，产出 `docs/gc114-quality-approved-t106.md`。pending→**approved**；**H2(114) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=114（AIContentFactory T107）

用户确认 H3：content-id=114 / platform_1 / 仅暂存离开。已完成：`tasks/T107-f2-live-114.md`，产出 `docs/freeze20-f2-live-114-t107.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 115（AIContentFactory T108）

用户确认只读检 content_id=115。已完成：`tasks/T108-h2-gc115-check.md`，产出 `docs/h2-gc115-check-t108.md`。GC 115 / CAR-10；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 115 设为 approved（AIContentFactory T109）

用户确认。已完成：`tasks/T109-gc115-quality-approved.md`，产出 `docs/gc115-quality-approved-t109.md`。pending→**approved**；**H2(115) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=115（AIContentFactory T110）

用户确认 H3：content-id=115 / platform_1 / 仅暂存离开。已完成：`tasks/T110-f2-live-115.md`，产出 `docs/freeze20-f2-live-115-t110.md` 与 reports。**成功**；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 116（AIContentFactory T111）

用户确认只读检 content_id=116。已完成：`tasks/T111-h2-gc116-check.md`，产出 `docs/h2-gc116-check-t111.md`。GC 116 / LIT-01；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 116 设为 approved（AIContentFactory T112）

用户确认。已完成：`tasks/T112-gc116-quality-approved.md`，产出 `docs/gc116-quality-approved-t112.md`。pending→**approved**；**H2(116) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=116（AIContentFactory T113）

用户确认 H3：content-id=116 / platform_1 / 仅暂存离开。已完成：`tasks/T113-f2-live-116.md`，产出 `docs/freeze20-f2-live-116-t113.md` 与 reports。**成功**（`LIT-01`）；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 117（AIContentFactory T114）

用户确认只读检 content_id=117。已完成：`tasks/T114-h2-gc117-check.md`，产出 `docs/h2-gc117-check-t114.md`。GC 117 / LIT-02；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 117 设为 approved（AIContentFactory T115）

用户确认。已完成：`tasks/T115-gc117-quality-approved.md`，产出 `docs/gc117-quality-approved-t115.md`。pending→**approved**；**H2(117) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=117（AIContentFactory T116）

用户确认 H3：content-id=117 / platform_1 / 仅暂存离开。已完成：`tasks/T116-f2-live-117.md`，产出 `docs/freeze20-f2-live-117-t116.md` 与 reports。**成功**（`LIT-02`）；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 118（AIContentFactory T117）

用户确认只读检 content_id=118。已完成：`tasks/T117-h2-gc118-check.md`，产出 `docs/h2-gc118-check-t117.md`。GC 118 / LIT-03；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 118 设为 approved（AIContentFactory T118）

用户确认。已完成：`tasks/T118-gc118-quality-approved.md`，产出 `docs/gc118-quality-approved-t118.md`。pending→**approved**；**H2(118) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=118（AIContentFactory T119）

用户确认 H3：content-id=118 / platform_1 / 仅暂存离开。已完成：`tasks/T119-f2-live-118.md`，产出 `docs/freeze20-f2-live-118-t119.md` 与 reports。**成功**（`LIT-03`）；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 119（AIContentFactory T120）

用户确认只读检 content_id=119。已完成：`tasks/T120-h2-gc119-check.md`，产出 `docs/h2-gc119-check-t120.md`。GC 119 / LIT-04；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 119 设为 approved（AIContentFactory T121）

用户确认。已完成：`tasks/T121-gc119-quality-approved.md`，产出 `docs/gc119-quality-approved-t121.md`。pending→**approved**；**H2(119) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=119（AIContentFactory T122）

用户确认 H3：content-id=119 / platform_1 / 仅暂存离开。已完成：`tasks/T122-f2-live-119.md`，产出 `docs/freeze20-f2-live-119-t122.md` 与 reports。**成功**（`LIT-04`）；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 120（AIContentFactory T123）

用户确认只读检 content_id=120。已完成：`tasks/T123-h2-gc120-check.md`，产出 `docs/h2-gc120-check-t123.md`。GC 120 / LIT-05；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 GC 120 设为 approved（AIContentFactory T124）

用户确认。已完成：`tasks/T124-gc120-quality-approved.md`，产出 `docs/gc120-quality-approved-t124.md`。pending→**approved**；**H2(120) 已满足**；未跑 F2。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=120（AIContentFactory T125）

用户确认 H3：content-id=120 / platform_1 / 仅暂存离开。已完成：`tasks/T125-f2-live-120.md`，产出 `docs/freeze20-f2-live-120-t125.md` 与 reports。**成功**（`LIT-05`）；未发布；H3 已消费。目标项目本地 CI 通过。

## T014 目标项目 H2 只读检 GC 121（AIContentFactory T126）

用户确认只读检 content_id=121。已完成：`tasks/T126-h2-gc121-check.md`，产出 `docs/h2-gc121-check-t126.md`。GC 121 / LIT-06；**quality=pending → H2 未满足**。目标项目本地 CI 通过。

## T014 目标项目 F3 batch 116-120（AIContentFactory T127）

用户确认完整 F3。已完成：`tasks/T127-f3-batch-116-120.md`，产出 `docs/freeze20-f3-batch-116-120-t127.md` 与 reports。**wave_ok=true；5/5 confirmed**；未发布。目标项目本地 CI 通过。

## T014 目标项目 GC 121 设为 approved（AIContentFactory T128）

用户确认。已完成：`tasks/T128-gc121-quality-approved.md`，产出 `docs/gc121-quality-approved-t128.md`。pending→**approved**；**H2(121) 已满足**。122–125 仍 pending → **F3 121–125 未执行**。目标项目本地 CI 通过。

## T014 目标项目 GC 122–125 设为 approved（AIContentFactory T129）

用户确认。已完成：`tasks/T129-gc122-125-quality-approved.md`，产出 `docs/gc122-125-quality-approved-t129.md`。4 条 pending→**approved**；本步未跑 F2/F3。目标项目本地 CI 通过。

## T014 目标项目 F2 live content-id=121（AIContentFactory T130）

用户确认 H3。已完成：`tasks/T130-f2-live-121.md`，产出 `docs/freeze20-f2-live-121-t130.md`。**成功**（`LIT-06`）；未发布。目标项目本地 CI 通过。

## T014 目标项目 F3 batch 121-125（AIContentFactory T131）

用户确认完整 F3。已完成：`tasks/T131-f3-batch-121-125.md`，产出 `docs/freeze20-f3-batch-121-125-t131.md`。**wave_ok=true；5/5 confirmed**；未发布。目标项目本地 CI 通过。

## T014 目标项目 Freeze20 阶段收口 106-125（AIContentFactory T132）

用户确认只文档收口。已完成：`tasks/T132-freeze20-106-125-closeout.md`，产出 `docs/freeze20-106-125-draft-box-closeout-t132.md`。覆盖单条 F2 106–121 + F3 两波 116–125；**未跑 F4、未发布、未提交代码仓**。目标项目本地 CI 通过。

## T014 目标项目剩余冻结项复核 L5（AIContentFactory T133）

用户确认只读 L5。已完成：`tasks/T133-remaining-freeze-l5-review.md`，产出 `docs/remaining-freeze-l5-review-t133.md`。敏感 `??` **仍为 4**；冻结维持；未跑 F4、未发布、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目新素材段盘点 >125（AIContentFactory T134）

用户确认只读盘点。已完成：`tasks/T134-new-material-segment-inventory-gt125.md`，产出 `docs/new-material-segment-inventory-gt125-t134.md`。结论：**无 >125 可 ingest 候选**（CSV/资产/库均止于 125）。未写库、未跑 F2/F3/F4。目标项目本地 CI 通过。

## T014 目标项目观察期巡检（AIContentFactory T135）

用户确认只读巡检。已完成：`tasks/T135-observation-status-patrol.md`，产出 `docs/observation-status-patrol-t135.md`。tip=`db90a59` 齐平；`??`=4；H1 通；GC 106–125 全 approved；PublishTask=0。未启服务、未跑 F2/F3/F4。目标项目本地 CI 通过。

## T014 目标项目远程方案复核 L4（AIContentFactory T136）

用户确认只文档 L4。已完成：`tasks/T136-remote-repo-plan-recheck.md`，产出 `docs/remote-repo-plan-recheck-t136.md`。**维持无 origin**；tip=`0d4683c`；`??`=4。未 remote add、未 push、未改代码仓。目标项目本地 CI 通过。

## T014 目标项目评估提交 settings_env（AIContentFactory T137）

用户确认仅提交 `backend/tests/settings_env.py`。已完成：`tasks/T137-code-commit-settings-env.md`，产出 `docs/code-commit-settings-env-t137.md`。`git diff` 为空；**未创建 commit**；tip 仍 `0d4683c`。未配 origin、未推送、未碰 F4。目标项目本地 CI 通过。

## T014 目标项目只读检查 crawl_p1（AIContentFactory T138）

用户确认只读。已完成：`tasks/T138-crawl-p1-diff-check.md`，产出 `docs/crawl-p1-diff-check-t138.md`。`git diff` 为空；未提交、未改文件。目标项目本地 CI 通过。

## T014 目标项目维持观察（AIContentFactory T139）

用户确认维持观察。已完成：`tasks/T139-maintain-observation.md`，产出 `docs/maintain-observation-t139.md`。不启服务、不跑 F2/F3/F4、不提交代码仓、不配 origin。目标项目本地 CI 通过。

## T014 目标项目退出观察逐条报告（AIContentFactory T140）

用户要求逐条完成给报告。已完成：`tasks/T140-exit-observation-itemized-report.md`，产出 `docs/exit-observation-itemized-report-t140.md` 与重开 B 梯子。结论：1–2 阻塞、3 无提交目标、4 只文档、5–6 维持观察。未写库、未配 origin、未跑 F4。目标项目本地 CI 通过。

## T014 目标项目超125包立项 LIT-11-15（AIContentFactory T141）

用户发立项句（主题仍为占位 `<一句话>`）。已完成：`tasks/T141-freeze21-lit11-15-package-brief.md`，产出 `docs/freeze21-lit11-15-package-brief-t141.md`（任务单+目录约定；期望 126–130）。未写库、未作文案、未跑 F2/F3/F4。目标项目本地 CI 通过。

## T014 目标项目 LIT-11-15 主题候选（AIContentFactory T142）

用户确认候选列表。ChatGPT 429 → DeepSeek 顶上；产出 `docs/freeze21-lit11-15-theme-candidates-t142.md`（5 候选；**不定稿**）。未写库、未跑 F2/F3/F4。目标项目本地 CI 通过。

## T014 目标项目主题定稿方案A（AIContentFactory T143）

用户确认方案A。整包主题：**别急着打卡，书是拿来「泡」的不是「啃」的**。产出 `docs/freeze21-theme-locked-t143.md`；已回写立项表。未写正文、未写库。目标项目本地 CI 通过。

## T014 目标项目 LIT-11-15 标题hook大纲（AIContentFactory T144）

用户确认大纲制作。ChatGPT 429 → DeepSeek；产出 `docs/freeze21-lit11-15-title-hook-outlines-t144.md`。不定配图、未写库。目标项目本地 CI 通过。

## T014 目标项目 LIT-11-15 小红书正文（AIContentFactory T145）

用户确认扩正文并回写推送。ChatGPT 429 → DeepSeek；产出 `docs/freeze21-lit11-15-xhs-bodies-t145.md`（标题+hook+正文+3标签×5）。不定配图、未写库。目标项目本地 CI 通过。

## T014 目标项目 LIT-11-15 配图需求表（AIContentFactory T146）

用户确认配图需求表。ChatGPT 429 → DeepSeek；产出 `docs/freeze21-lit11-15-image-briefs-t146.md`（封面+正文×3×5；未生成真图）。未写库。目标项目本地 CI 通过。

## T014 目标项目 freeze21 资产目录骨架（AIContentFactory T147）

用户确认建骨架并回写推送。已创建 `D:\tmp\freeze21_phase31_assets\LIT-11`…`LIT-15`（仅 README）；产出 `docs/freeze21-asset-dirs-t147.md`。未生成图片、未写库、未提交代码仓。目标项目本地 CI 通过。

## T014 目标项目 freeze21 CSV 骨架（AIContentFactory T148）

用户确认写 CSV。已写本地 `freeze21_phase32_editor_export.csv`（LIT-11…15；正文 T145；图路径占位）；产出 `docs/freeze21-editor-export-csv-t148.md`。未写库、未跑 F2/F3/F4。目标项目本地 CI 通过。

## T014 目标项目 freeze21 ingest preview（AIContentFactory T149）

用户确认 dry-run 并回写推送。产出 `docs/freeze21-ingest-preview-t149.md`；**all_gates_pass=true**；5/5；图片 0/20；未写库。目标项目本地 CI 通过。
