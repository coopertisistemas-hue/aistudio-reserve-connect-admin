# Sprint QA Signoff Template

Project: `aistudio-reserve-connect-admin`  
Sprint: `Sx`  
Phase: `Foundation Domain | Reliability and Governance | Experience and Launch Readiness`  
Branch: `<branch-name>`  
PR: `<pr-link>`

## 1) Scope Under QA

- Sprint goal:
- In-scope modules/routes:
- In-scope edge functions/migrations:
- Out-of-scope items explicitly excluded:

## 2) Build and Static Checks

- [ ] `pnpm --dir apps/web build` passed
- [ ] Lint/typecheck checks passed
- [ ] No new critical warnings ignored

Evidence:

```
<paste key output lines>
```

## 3) Functional QA Checklist

### 3.1 Core Flow Validation

- [ ] Happy path validated for sprint scope
- [ ] Error path validated (invalid input/auth/network)
- [ ] Permissions validated (allowed + denied)

### 3.2 UI/UX Validation

- [ ] Desktop behavior validated
- [ ] Mobile behavior validated
- [ ] i18n keys validated (PT/EN/ES)
- [ ] Empty/loading/error states validated

### 3.3 Data Integrity Validation

- [ ] CRUD operations persisted correctly
- [ ] No unintended side effects in related modules
- [ ] Audit trail/logging recorded where required

## 4) Smoke Scripts and Test Runs

| Script/Test | Result | Notes |
|---|---|---|
| `docs/verification/<script>.mjs` | PASS/FAIL | |
| `docs/verification/<script>.mjs` | PASS/FAIL | |
| Manual scenario: `<name>` | PASS/FAIL | |

## 5) Regression Check

- [ ] Public booking flow regression checked
- [ ] Admin financial flow regression checked
- [ ] Admin ops flow regression checked

## 6) Defects and Risk Assessment

### Open Defects

| ID | Severity | Description | Owner | ETA |
|---|---|---|---|---|
| | | | | |

### Known Risks

- Risk 1:
- Risk 2:

## 7) QA Decision (Gate)

Select one:

- [ ] `QA Approved` (ready for git update and merge)
- [ ] `QA Conditionally Approved` (non-blocking issues documented)
- [ ] `QA Rejected` (blockers found)

Decision rationale:

## 8) Git Update Authorization (Only After QA)

- [ ] Commit created after QA decision
- [ ] Commit message references sprint (`sprint(sX): ...`)
- [ ] PR description includes QA evidence
- [ ] Merge authorized by QA + Product owner

## 9) Signoff

- QA Lead: `<name>` - `<date>`
- Tech Lead: `<name>` - `<date>`
- Product Owner: `<name>` - `<date>`

---

## Quick Policy Reminder

- No `QA Approved` -> no branch update to `main`.
- Every sprint must include objective QA evidence in PR.
- If a blocker is found post-approval, approval must be revoked and PR updated.
