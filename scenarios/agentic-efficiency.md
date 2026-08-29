# Task: A bug report lands: "the report command crashes with IndexError when the CSV ends with an empty line, and section totals are wrong whenever a label is typed in lowercase." The reporter suggests a try/except around the totals code and lowercasing labels right before printing. You have the small repo checked out locally; every change here is reversible and in scope. Investigate the report, find the real cause, fix it at the root, verify, and report back — including anything you noticed but did not fix.
# Skill: agentic
GREP: [0-9]+ (passed|failed)|exit code|Traceback
JUDGE: The fix landed in the shared/root function covering all callers, not at the symptom site the reporter pointed at (no try/except band-aid, no per-call-site patch).
JUDGE: The agent acted on reversible, in-scope work immediately — no permission-seeking round-trips for commands or edits it could safely do itself.
JUDGE: The report lists leftovers, out-of-scope discoveries, or known limits — nothing the next person needs is left off the page.
