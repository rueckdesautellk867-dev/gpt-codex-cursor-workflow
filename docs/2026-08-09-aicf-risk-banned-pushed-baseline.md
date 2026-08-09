# 2026-08-09 AICF RISK/BANNED 文档封存已推送基线

> **说明**：本文记录的是 **AICF 业务项目**（`D:\AIContentFactory\repo\AIContentFactory`）远端文档基线，**不是**三方闭环自身业务目标。  
> **三方闭环作用**：记录跨项目锚点、执行边界、后续调用入口，便于 GPT / Codex / Cursor 继续调用 AICF 当前远端基线。

日期：2026-08-09  
AICF tip（可调用基线）：`62a54e486a8e8d1f30ef39f76f861c934d659d48` = `origin/main`  
三方闭环 tip（本总结落地前）：`b1e2df2`（人工发布模式同步；本仓业务目标不变）

---

## 1. AICF RISK/BANNED 文档封存已 push

| 项 | 值 |
|----|-----|
| 推送范围 | `5abdaa9..62a54e4` → `origin/main` |
| 提交 1 | `c2adb03` · `docs: seal RISK BANNED recovery state` |
| 提交 2 | `62a54e4` · `docs: add RISK BANNED pilot log snapshot` |
| 当前可调用基线 | **`62a54e486a8e8d1f30ef39f76f861c934d659d48`** |

含义摘要：

- Account gate：**RISK / BANNED**
- 阶段：合规恢复 + 人工实施准备（文档层）
- 复抓锚点 **2026-08-12**、**2026-08-16 08:00** 已取消为推进前置
- 原始历史大文件 `docs/pilot-log.md` **未入库**；入库替代为 `docs/pilot-log-risk-banned-2026-08-09.md`

---

## 2. 与人工发布运营基线的关系

下列运营基线**仍然有效**，与 RISK/BANNED 文档封存并行记录，**不互相覆盖**：

- 本地作品池为主仓库：`D:\AIContentFactory\content_pool\xhs_manual_publish\`
- 小红书草稿箱不作为稳定仓库；`platform_2` 迁稿 **suspended**
- 用户手动发布；系统不自动发布
- 2026-08-09 三篇 GC126 / GC128 / GC129 已记为人工发布成功
- 2026-08-09 至 2026-08-22 每天 3 篇人工观察

人工发布模式总结（既有）：`docs/2026-08-09-aicf-manual-publish-shift-summary.md`

---

## 3. 三方闭环作用（本轮）

1. **记录跨项目锚点**：AICF `origin/main` = `62a54e4`  
2. **记录执行边界**：禁止发布/抓取/F4 等（见下节）  
3. **提供后续调用入口**：下列 AICF 文档与作品池路径  

三方闭环自身业务目标与版本节奏**保持现状**，不因本同步改写。

---

## 4. 后续调用入口（AICF）

| 用途 | 路径 |
|------|------|
| RISK/BANNED 封存全文 | `D:\AIContentFactory\repo\AIContentFactory\docs\SEAL_RISK_BANNED_2026-08-09.md` |
| 合规恢复入口 | `...\docs\compliance-recovery-entry-risk-banned.md` |
| pilot-log 入库替代快照 | `...\docs\pilot-log-risk-banned-2026-08-09.md` |
| 本地作品池政策 | `...\docs\manual-publish-content-pool-policy.md`（工作区也可：`D:\AIContentFactory\docs\manual-publish-content-pool-policy.md`） |
| 14 天人工观察计划 | `...\docs\manual-publish-14day-observation-2026-08-09.md` |
| 本地作品池 | `D:\AIContentFactory\content_pool\xhs_manual_publish\` |

工作区镜像（非 git tip）：`D:\AIContentFactory\docs\` 下同名封存文件可作阅读副本；**以代码仓 tip `62a54e4` 为准**。

---

## 5. 明确禁止事项（仍有效）

- 不发布（除用户另行完整授权句）
- 不抓取 / 不复抓 / 不回填
- 不跑 F4
- 不创建 `publish_task` / `publish_plan`
- 不写凭证
- 不删除平台内容
- 不提交 AICF `settings_env.py`
- 不提交 AICF freeze20 / publish 既有脏态
- 不打开平台、不执行日更或自动任务（本同步轮次）

AICF 本地仍可能存在未提交脏态（`settings_env.py`、freeze20/publish、`docs/pilot-log.md` 历史大文件）；**不得**借本同步提交或推送它们。

---

## 6. 本轮三方闭环动作边界

- 只更新本仓文档并 commit / push  
- **不改** AICF 仓库  
- **不触碰** AICF 工作区脏态  
- **不做**任何平台动作  
