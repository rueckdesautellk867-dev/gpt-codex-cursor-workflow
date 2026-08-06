# 推送失败降级策略（CLI → Desktop）

适用仓库：本三方闭环文档仓（有 `origin` 时）。  
目标：自动流程里 **push 失败不死等**；本地 tip 可追踪；人工用 GitHub Desktop 兜底；网络恢复后再发 `同意推送`。

## 1. 标准路径（优先）

```text
本地 commit 成功
  → CLI: git push origin HEAD（有限次数，短超时）
  → 成功：清除「待 Desktop 推送」标记，回报远端 tip
  → 失败：进入 §2 降级，不阻塞后续本地任务
```

## 2. 失败降级（必须执行）

push / fetch / ls-remote 出现例如：

- `Failed to connect to github.com port 443`
- `curl 28`
- `Recv failure: Connection was reset`
- `unable to access 'https://github.com/...'`

**Agent / 脚本立即：**

1. **停止重试死等**（默认最多 1～2 次短试；总等待建议 < 60s）
2. **记录本地 tip**：`git rev-parse HEAD`、`git log -1 --oneline`
3. **写入待推送标记**（本地文件，不入库）：`.pending-desktop-push.json`
4. **向用户回报**固定句式（见下）
5. **继续**可本地完成的工作（改文档、本地 commit、模板 CI）；**不假装已推送**

### 固定回报句式

```text
CLI 推送失败（网络/443）。已记本地 tip=<shortsha> <subject>。
状态：待人工 Desktop 推送。网络恢复后请发：同意推送三方闭环
```

## 2.1 重点监控：`github.com:443`（与 api 分流）

推送 URL 走 **`https://github.com/...`**，**不是** `api.github.com`。

| 探针 | 意义 |
|------|------|
| `Test-NetConnection github.com -Port 443` | CLI push / ls-remote 硬依赖 |
| `Test-NetConnection api.github.com -Port 443` | 仅说明 GitHub API 侧可达；**不能**代替上一项 |
| `curl -sI https://github.com` | 曾出现 TCP True 但 curl 仍失败；须与 TCP 双检 |
| `git ls-remote --heads origin main` | 与 push 同源；成功才算远端可证 |

**判读：** `api.github.com` 通而 `github.com:443` 不通 → 按本文件 §2 降级（Desktop Fetch/Push），**不要**因「浏览器能上网」反复空跑 CLI push。

详细当日案例与标准探针见目标项目：`D:\AIContentFactory\docs\daily-progress-report-2026-08-06.md` §4。

## 3. 待推送标记文件

路径：仓库根目录 `.pending-desktop-push.json`（已加入 `.gitignore`，**禁止 commit**）

示例：

```json
{
  "status": "pending_desktop_push",
  "repo": "D:\\三方闭环整合项目",
  "branch": "main",
  "local_tip": "17030ad95a0aeb59f50dedf0d04d1af1b13c4066",
  "local_tip_short": "17030ad",
  "subject": "docs: record AIContentFactory P1A detail gate",
  "remote_tracking": "4b7ab08...",
  "failed_at": "2026-08-06T08:00:00+08:00",
  "last_error": "Failed to connect to github.com port 443",
  "action": "Open GitHub Desktop → Push origin，或网络恢复后发：同意推送三方闭环"
}
```

- 有此文件且 `status=pending_desktop_push` → 视为远程可能落后  
- push 成功或确认 `HEAD == origin/main` 后 → **删除**该文件  

查询：`powershell -NoProfile -File .\scripts\push-with-fallback.ps1 -StatusOnly`

## 4. 人工 Desktop 通道

1. 打开 GitHub Desktop，选中本仓库  
2. 确认待推提交后点 **Push origin**  
3. 或网络恢复后对 Agent 说：`同意推送三方闭环`（再走 CLI）  
4. 成功后本地应显示 `main...origin/main`（无 ahead），标记文件已清除  

## 5. 对自动闭环的影响

| 环节 | 影响 |
|------|------|
| 本地改文档 / commit / `ci-check.ps1` | 不受阻 |
| Agent 自动 `git push` | 失败则降级，不阻塞会话 |
| 远端 Docs CI / 分支保护 | **延后**到真正 push 成功之后 |
| GitHub Desktop | 仅人工兜底，不作为无人值守主路径 |

## 6. 相关排查（已知）

若 CLI 长期 443 失败，先查是否误开：

- `codex_sandbox_offline_block_outbound`
- `codex_sandbox_offline_block_loopback_tcp`
- `codex_sandbox_offline_block_loopback_udp`

（曾导致全局出站阻断；禁用后需复测 `git ls-remote`。）

## 7. 推荐命令

```powershell
# 尝试推送；失败则写标记并退出非 0（不抛死等）
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\push-with-fallback.ps1

# 只查看是否有待 Desktop 推送
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\push-with-fallback.ps1 -StatusOnly

# 连通性探测（不推送）
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\push-with-fallback.ps1 -ProbeOnly
```
