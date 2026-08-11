# T016 全自动模式边界与运行规则

## 状态

已完成

## 背景

昨日 Cursor 与 Codex 自动闭环项目已进入半自动模式。今日目标是推进到全自动模式，但必须明确全自动只覆盖研发闭环，不覆盖平台发布、抓取、F4、日更或凭证动作。

## 目标

- 新增全自动模式说明文档。
- 明确可自动执行范围、人工确认边界、失败降级和今日目标。
- 将 Obsidian 每日复盘入库纳入全自动研发闭环。

## 影响范围

- `docs/full-auto-mode.md`
- `tasks/backlog.md`
- `README.md`

## 不做什么

- 不改 AICF 业务仓库代码。
- 不打开平台、不登录、不抓取、不上传、不发布。
- 不创建 `publish_task` / `publish_plan`。
- 不提交、不 push。
- 不修改凭证、cookie、token、`.env`。

## 验收标准

- [x] 文档明确“全自动研发闭环”与“小红书自动发布”是两件事。
- [x] 文档列出可自动执行范围。
- [x] 文档列出必须人工确认的动作。
- [x] 文档列出失败降级规则。
- [x] backlog 已登记 T016。

## 验证命令

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\ci-check.ps1
```

## 风险等级

低

## 结果

已新增 `docs/full-auto-mode.md`，并将 T016 登记到 backlog。该任务只修改三方闭环文档，不触碰平台、AICF 业务仓库或凭证。

