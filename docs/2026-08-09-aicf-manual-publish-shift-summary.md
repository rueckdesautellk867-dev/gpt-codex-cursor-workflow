# 2026-08-09 AICF 本地作品池与人工发布模式切换总结

> **说明**：本文记录的是 **AICF 业务项目**（`D:\AIContentFactory`）状态，**不是**三方闭环自身业务目标。  
> **三方闭环作用**：记录跨项目锚点、执行边界、后续调用入口，便于 GPT / Codex / Cursor 继续调用。

日期：2026-08-09  
AICF tip（文档同步时）：`18b3408`=`origin/main`  
三方闭环 tip（本总结落地前）：`04b5dff`

---

## 1. AICF 发布策略重大调整

- **放弃**小红书草稿箱作为稳定内容仓库。  
- **原因**：草稿箱保存后再次打开，原图无法稳定显示（`draft_image_persistence_failed`）。  
- **当前可信基础**改为本地作品池：  
  `D:\AIContentFactory\content_pool\xhs_manual_publish\`  
- **用户手动发布**；系统不自动发布、不上传草稿箱、不跑 F4。  

AICF 政策：`D:\AIContentFactory\docs\manual-publish-content-pool-policy.md`  
（代码仓副本：`repo/AIContentFactory/docs/manual-publish-content-pool-policy.md`）

---

## 2. 本地作品池建立

| 项 | 值 |
|----|-----|
| ready | **42** 篇 |
| queued（建池时今日槽） | **3** 篇（现已人工发布） |
| 根目录 | `D:\AIContentFactory\content_pool\xhs_manual_publish\` |
| 今日发布包 | `...\daily_queue\2026-08-09\` |

今日三篇编号：

| 编号 | GC | 标题（建包时） |
|------|-----|----------------|
| XHS-20260809-001 | 126 | 书翻得慢，反而记得住 |
| XHS-20260809-002 | 128 | 别再问「这本书多久能读完」了 |
| XHS-20260809-003 | 129 | 书是拿来泡的，不是拿来啃的 |

每篇含：`title.txt` / `body.md` / `images/` / `source.json` / `publish_checklist.md`  
警戒线：ready **&lt; 21** → 补充到 **50**。

---

## 3. 今日三篇已人工发布成功

| GC | 标题 | 发布时间 |
|----|------|----------|
| 126 | 书翻得慢，反而记得住 | 2026-08-09 14:53 |
| 128 | 别再问「这本书多久能读完」了 | 2026-08-09 14:55 |
| 129 | 书是拿来泡的，不是拿来啃的 | 2026-08-09 14:56 |

- 截图：`C:\Users\Administrator\Pictures\Screenshots\屏幕截图 2026-08-09 150010.png`  
- 截图**未显示** `note_url` / `note_id` → **待补**  
- 未见审核/异常提示  

---

## 4. platform_2 状态

- 已建档、已登录、已激活。  
- **不作为**自动发布通道。  
- 草稿箱为空；且图片持久化失败 → **不作为内容仓库**。  
- 不迁稿、不重建草稿、不自动上传。  
- 迁稿计划保持 **`suspended`**。  

---

## 5. 接下来 14 天策略（2026-08-09 至 2026-08-22）

- 每天从本地作品池准备 **3** 篇，**用户手动发布**。  
- **禁止**：自动抓取、F4、日更、`publish_task` / `publish_plan`。  
- 每日人工记录：发布时间、截图、异常、初始数据与 24h 观察。  
- **2 周后**再评估是否尝试「草稿箱中文案直接发布」——须**另行确认**，不自动执行。  

AICF 14 天观察计划：`D:\AIContentFactory\docs\manual-publish-14day-observation-2026-08-09.md`  
（本轮新建；供后续调用。）

---

## 后续调用入口（两仓共用锚点）

| 入口 | 路径 |
|------|------|
| 本地作品池 | `D:\AIContentFactory\content_pool\xhs_manual_publish\` |
| 今日发布包 | `...\daily_queue\2026-08-09\` |
| 今日发布截图 | `C:\Users\Administrator\Pictures\Screenshots\屏幕截图 2026-08-09 150010.png` |
| 作品池政策 | AICF `docs/manual-publish-content-pool-policy.md` |
| AICF 项目状态 | AICF `docs/project-status.md` |
| 14 天观察计划 | AICF `docs/manual-publish-14day-observation-2026-08-09.md` |
| 草稿箱问题单 | AICF `docs/platform-2-draft-image-persistence-issue.md` |
| 本总结（三方闭环） | `docs/2026-08-09-aicf-manual-publish-shift-summary.md` |

---

## 统一边界

- 本地作品池是主仓库。  
- 小红书草稿箱不作为稳定仓库。  
- 用户手动发布。  
- 今日三篇已发布成功。  
- 接下来 14 天按每天 3 篇人工发布观察。  
- 所有自动发布、抓取、F4、日更仍禁止。  
- 2 周后再评估草稿箱文案直接发布，不自动执行。  
