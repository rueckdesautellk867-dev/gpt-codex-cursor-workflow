# AI 三方研发闭环

可复用的 GPT + Codex + Cursor 协作流程。

## 角色

| 角色 | 负责 |
|------|------|
| GPT | 拆需求、定边界、写验收标准、标风险 |
| Codex | 按任务改仓库、跑测试、输出变更总结 |
| Cursor | IDE 内局部修改、调试、重构、人工协作审查 |

## 主流程

```text
需求 / Bug / 告警
    ↓
GPT 拆任务（目标、范围、验收、风险）
    ↓
Codex 实现（最小改动 + 相关测试）
    ↓
CI 验证
    ↓
Cursor + 人工审查（对照 PR_CHECKLIST.md）
    ↓
合并发布
    ↓
反馈回流（问题 / 经验写回任务与规则）
```

## 各阶段产出

1. **GPT 拆任务**：目标、不做事项、涉及文件/模块、验收标准、高风险点
2. **Codex 实现**：代码改动、测试结果、变更总结、待确认项
3. **CI 验证**：流水线通过；失败则回到 Codex / Cursor 修复
4. **Cursor + 人工审查**：按 `PR_CHECKLIST.md` 核对范围、风险、回滚
5. **合并发布**：合并后观察告警与核心路径
6. **反馈回流**：缺陷、误判、缺失规则沉淀到 `AGENTS.md` / Cursor rules / 本文档

## 协作边界

- GPT 不出业务代码实现细节，聚焦可执行任务包
- Codex 不做模糊需求下的大范围猜测改动
- Cursor 不替代 Codex 做整仓批量自动实现；侧重局部与调试
- 高风险变更必须人工确认后再继续

## 相关文件

- `AGENTS.md`：Codex 仓库级规则
- `.cursor/rules/ai-workflow.mdc`：Cursor 规则
- `PR_CHECKLIST.md`：合并前检查清单
- `docs/definition-of-done.md`：完成标准
