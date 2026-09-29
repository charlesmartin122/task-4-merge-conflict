# =====================================================================
# GitHub Merge Conflict Simulation - replay script for screenshots
# Run:  .\screenshot-run.ps1
# Creates a FRESH repo in .\conflict-demo and walks through the activity
# step by step, pausing at each screenshot moment.
# =====================================================================
$ErrorActionPreference = 'Stop'

$Demo = Join-Path $PSScriptRoot 'conflict-demo'
if (Test-Path $Demo) { Remove-Item -Recurse -Force $Demo }
New-Item -ItemType Directory -Path $Demo | Out-Null
Push-Location $Demo

git init -b main | Out-Null
git config user.name "Student A"
git config user.email "student-a@example.com"

@'
<!DOCTYPE html>
<html>
<head>
    <title>Team Profile</title>
</head>
<body>
    <h1>Team Profile</h1>
    <p>Team Name: Team Alpha</p>
    <p>Members: Student A & Student B</p>
</body>
</html>
'@ | Set-Content -Path index.html -Encoding utf8

git add -A
git commit -m "initial commit: team profile page" | Out-Null

# --- Student A ---
git checkout -b student-a
(Get-Content index.html) -replace 'Team Alpha', 'Team Rockets' | Set-Content index.html -Encoding utf8
git add -A
git commit -m "student A update"
git checkout main

# --- Student B (branches from the SAME original main, before A is merged) ---
git checkout -b student-b
(Get-Content index.html) -replace 'Team Alpha', 'Code Titans' | Set-Content index.html -Encoding utf8
git add -A
git commit -m "student B update"
git checkout main

# --- Merge student-a (succeeds) ---
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " STEP 1: git merge student-a  (should succeed)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
git merge student-a

Read-Host "`nStudent A merged successfully. Press Enter to merge student-b (this will CONFLICT)"

# --- Merge student-b (conflicts!) ---
Write-Host "`n==================================================" -ForegroundColor Cyan
Write-Host " STEP 2: git merge student-b  (conflict!)" -ForegroundColor Cyan
Write-Host "==================================================" -ForegroundColor Cyan
git merge student-b

Write-Host "`n=== index.html with conflict markers ===" -ForegroundColor Yellow
Get-Content index.html

Read-Host "`n>>> SCREENSHOT 1: capture the conflict markers above. Press Enter to resolve the conflict"

# --- Resolve ---
@'
<!DOCTYPE html>
<html>
<head>
    <title>Team Profile</title>
</head>
<body>
    <h1>Team Profile</h1>
    <p>Team Name: Team Rockets</p>
    <p>Members: Student A & Student B</p>
</body>
</html>
'@ | Set-Content -Path index.html -Encoding utf8

git add index.html
git commit -m "resolve merge conflict: final team name is Team Rockets"

Write-Host "`n=== git status after resolution ===" -ForegroundColor Green
git status

Read-Host "`n>>> SCREENSHOT 2: capture the clean git status above. Press Enter for branch history"

Write-Host "`n=== Branches ===" -ForegroundColor Cyan
git branch
Write-Host "`n=== History ===" -ForegroundColor Cyan
git log --graph --oneline --all

Pop-Location
Write-Host "`nDone! The replay repo is in $Demo" -ForegroundColor Green
