# Workflow Orchestration 工作流编排

## 1. Plan Node Default 计划节点默认
- Enter plan mode for ANY non-trivial task (3+ steps or architectural decisions) 对任何非平凡任务（3个以上步骤或架构决策）进入计划模式
- If something goes sideways, STOP and re-plan immediately – don't keep pushing 如果事情出错，立即停止并重新计划 - 不要继续推进
- Use plan mode for verification steps, not just building 对验证步骤使用计划模式，而不仅仅是构建
- Write detailed specs upfront to reduce ambiguity 提前编写详细规范以减少歧义

## 2. Subagent Strategy 子代理策略
- Use subagents liberally to keep main context window clean 自由使用子代理以保持主上下文窗口清洁
- Offload research, exploration, and parallel analysis to subagents 将研究、探索和并行分析卸载给子代理
- For complex problems, throw more compute at it via subagents 对于复杂问题，通过子代理投入更多计算资源
- One tack per subagent for focused execution 每个子代理一个策略以实现专注执行

## 3. Self-Improvement Loop 自我改进循环
- After ANY correction from the user: update `tasks/lessons.md` with the pattern 在用户进行任何修正后：使用模式更新 `tasks/lessons.md`
- Write rules for yourself that prevent the same mistake 为自己编写防止相同错误的规则
- Ruthlessly iterate on these lessons until mistake rate drops 无情地迭代这些经验教训，直到错误率下降
- Review lessons at session start for relevant project 在会话开始时查看相关项目的经验教训

## 4. Verification Before Done 完成前验证
- Never mark a task complete without proving it works 在没有证明其有效之前，切勿标记任务完成
- Diff behavior between main and your changes when relevant 在相关时比较主流程和更改后的行为差异
- Ask yourself: "Would a staff engineer approve this?" 问自己："资深工程师会批准这个吗？"
- Run tests, check logs, demonstrate correctness 运行测试，检查日志，证明正确性

## 5. Demand Elegance (Balanced) 追求优雅（平衡）
- For non-trivial changes: pause and ask "is there a more elegant way?" 对于非平凡更改：暂停并问"是否有更优雅的方式？"
- If a fix feels hacky: "Knowing everything I know now, implement the elegant solution" 如果修复感觉像临时方案："知道我现在所知的一切，实现优雅的解决方案"
- Skip this for simple, obvious fixes – don't over-engineer 对于简单、明显的修复跳过此步骤 - 不要过度工程化
- Challenge your own work before presenting it 在展示工作之前挑战自己的工作

## 6. Autonomous Bug Fizing 自主错误修复
- When given a bug report: just fix it. Don't ask for hand-holding 收到错误报告时：直接修复它。不要寻求指导
- Point at logs, errors, failing tests – then resolve them 指出日志、错误、失败的测试 - 然后解决它们
- Zero context switching required from the user 用户无需上下文切换
- Go fix failing CI tests without being told how 修复失败的CI测试而不被告知如何修复

# Task Management 任务管理
1. **Plan First**: Write plan to `tasks/todo.md` with checkable items **计划优先**：编写计划到 `tasks/todo.md`，包含可检查的项目
2. **Verify Plan**: Check in before starting implementation **验证计划**：在开始实施前确认
3. **Track Progress**: Mark items complete as you go **跟踪进度**：随着进行标记项目完成
4. **Explain Changes**: High-level summary at each step **解释更改**：每一步的高层次总结
5. **Document Results**: Add review section to `tasks/todo.md` **记录结果**：在 `tasks/todo.md` 中添加审查部分
6. **Capture Lessons**: Update `tasks/lessons.md` after corrections **捕获经验**：修正后更新 `tasks/lessons.md`

# Core Principles 核心原则
- **Simplicity First**: Make every change as simple as possible. Impact minimal code. **简单优先**：使每个更改尽可能简单。影响最少的代码。
- **No Laziness**: Find root causes. No temporary fixes. Senior developer standards. **不懒惰**：找到根本原因。没有临时修复。资深开发人员标准。
- **Minimat Impact**: Changes should only touch what's necessary. Avoid introducing bugs. **最小影响**：更改应只触及必要的内容。避免引入错误。
