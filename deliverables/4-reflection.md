# Reflection: What Caused the Merge Conflict?

The conflict happened because Student A and Student B both started from the
**same original version** of `index.html` and both edited the **exact same line**
(the `<p>Team Name: Team Alpha</p>` line):

- **Student A** changed it to `Team Rockets` on the `student-a` branch.
- **Student B** changed it to `Code Titans` on the `student-b` branch.

Student A's branch was merged into `main` first, so `main` now contained the
"Team Rockets" version. When Student B's branch was merged afterwards, Git
found two **different versions of the same line** — `main`'s version and
`student-b`'s version — and it could not automatically decide which one was
correct. Git never silently overwrites or guesses, so it stopped the merge and
marked the line with conflict markers:

```
<<<<<<< HEAD
    <p>Team Name: Team Rockets</p>
=======
    <p>Team Name: Code Titans</p>
>>>>>>> student-b
```

To resolve it, we looked at both versions, agreed to keep **"Team Rockets"**
as the final team name, deleted the conflict markers, staged the file, and
committed the resolved version. The lesson: a merge conflict is not an error —
it is Git asking a human to make the decision that it cannot make on its own,
and resolving it is simply a new commit that records that decision.
