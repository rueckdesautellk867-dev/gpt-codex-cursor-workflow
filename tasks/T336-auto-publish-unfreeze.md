# T336 · 解除阻止自动发布的全部指令（F4 冻结解冻 + platform_2 自动发布恢复）

- **风险**：高（触红线：F4 自动发布冻结解冻、manual_confirm 放宽、选号闸解除、CI compliance-guard 改写）
- **执行者**：Codex（按用户口头授权）
- **状态**：已完成
- **关联**：业务仓 `D:\AIContentFactory\repo\AIContentFactory`；观察期 `platform_2` 08-08~08-22

## 背景
2026-08-21 用户明确要求"将阻止自动发布的指令我授权全部解除"。此前 Phase 0 将 F4 自动发布脚本隔离于 `compliance-frozen/`，impl-A 强制 `manual_confirm=True`、选号闸死、三道 MOCK/ENABLED 总闸关闭。本次按用户授权逐项解除。

## 变更清单
1. config.py：`PUBLISH_ENQUEUE_MOCK_ONLY=False`、`PUBLISH_WORKER_MOCK_ONLY=False`
2. backend/.env：`PUBLISH_RUN_ONE_ENABLED=True`
3. account_selector.py：恢复按 `status=active` 选号，排除 `platform_1`/id=1
4. publish_account_gate.py：`manual_confirm` 增加 `allow_auto`，非 legacy 自动发布路径免确认
5. worker.py：非 legacy 账号自动发布路径放行 `allow_auto`
6. F4 脚本从 `compliance-frozen/` 移回原路径（8 文件）；`.gitignore` 移除隔离行
7. ci.yml：`compliance-guard` 改为"解冻确认 + 无 legacy platform_1 路径"
8. 补 `backend/data/account_gate_status.txt` 闸门 + `docs/operations/account-gate-status-2026-08-21.md`

## 保留的硬边界（不可逾越）
- `platform_1`/id=1 永久禁用，绝不作为发布通道（代码层 `is_legacy_risk_*` 强制拦截）
- `platform_2` 观察期 08-22 到期前仍限手动验证（WATCH），不自动批量

## 人工审批记录
- 审批人：用户（项目所有者）
- 审批方式：口头授权（对话）
- 授权时间：2026-08-21
- 授权原文："首先将阻止自动发布的指令我授权全部解除"
- 备注：高风险 CI 门禁据此放行；后续观察期评估（08-22）仍需人工确认转 STABLE。
