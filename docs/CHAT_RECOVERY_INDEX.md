# Chat Recovery Index

Use this index to recover context quickly if OpenCode chat history is unavailable.

## Read Order

1. `docs/EXEC_PLAN_BRIEFING.md` (fast executive snapshot)
2. `docs/HANDOFF.md` (exact next actions)
3. `docs/EXEC_PLAN_MASTER_LOG.md` (detailed timeline and decisions)
4. `docs/verification/S*_QA_SIGNOFF_DRAFT.md` (sprint QA evidence)

## Backup Routine (Recommended)

- At end of each major session:
  - update briefing + handoff + master log
  - commit docs with message prefix `docs(handoff): ...`
- Daily backup:
  - copy `docs/` to external storage (Drive/OneDrive/Notion export)
- Before risky changes:
  - run `git status` and create a checkpoint commit for docs context.

## Minimal Restart Prompt

If you open a new OpenCode session, start with:

"Leia `docs/EXEC_PLAN_BRIEFING.md`, `docs/HANDOFF.md` e `docs/EXEC_PLAN_MASTER_LOG.md`, confirme estado atual da sprint e continue execucao com gate de QA por sprint."
