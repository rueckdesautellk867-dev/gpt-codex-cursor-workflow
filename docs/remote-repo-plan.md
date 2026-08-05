# 远程仓库准备方案

为后续把本项目推送到 GitHub / Gitee / 阿里云 Codeup 做准备。  
**v0.7 只写方案，不创建远程、不推送、不配置 CI。**

## 远程仓库目标

1. 代码与文档有可协作的远端备份
2. 为 PR、分支保护、CI（T006）留接口
3. 平台选择可复盘，不临时拍板

当前本地：工作区 `D:\三方闭环整合项目\`，分支 `master`，**尚无 `git remote`**。推送时需约定沿用 `master` 或改名为 `main`（下文步骤以目标分支名 `main` 为例，执行 T011 前再确认）。

## 可选平台

| 平台 | 特点 |
|------|------|
| **GitHub** | 生态全，易接 Codex / GitHub Actions |
| **Gitee** | 国内访问友好，适合团队协作 |
| **阿里云 Codeup** | 与云效 / 阿里云研发链路衔接紧 |

## 选择建议

- 优先接 **Codex / GitHub Actions** → 推荐 **GitHub**
- 优先 **国内访问和团队协作** → 可考虑 **Gitee**
- 后续要深度接 **阿里云云效** → 可考虑 **Codeup**

未选定前，不执行 T011。

## 推送前检查

执行创建远程 / 首次推送之前，逐项确认：

- [ ] 工作区干净（`git status` 无未提交变更）
- [ ] 无密钥和 Token（含 `.env`、凭证文件、历史提交中的秘密）
- [ ] 无个人隐私文件
- [ ] 无 `node_modules` 等大目录（本仓库当前为纯文档，无依赖目录）
- [ ] `README.md` 和 `docs/release-notes.md` 已更新
- [ ] 已人工确认平台与仓库可见性（公开 / 私有）
- [ ] T011 已审批（状态不再是仅「待确认」而无记录）

## 初始化步骤（供 T011，本阶段不执行）

```text
1. 在选定平台创建远程空仓库（勿勾选自动生成 README，避免首推冲突）
2. 本地设置 remote，例如：
   git remote add origin <仓库 URL>
3. 确认分支策略：保留 master，或 git branch -M main
4. 推送主分支，例如：
   git push -u origin main
   （若保留 master：git push -u origin master）
5. 在网页确认远程文件完整（规则、docs、tasks 均在）
6. 设置分支保护：禁止直接推 main（或 master），后续走 PR
```

## 暂不执行

- 不创建远程仓库
- 不推送代码
- 不配置 CI（仍见 T006）

实际推送见预留任务 [`tasks/T011-remote-repo-push.md`](../tasks/T011-remote-repo-push.md)（`待确认`）。
