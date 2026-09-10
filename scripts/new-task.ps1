param(
    [Parameter(Mandatory = $true)]
    [string]$Title,

    [ValidateSet("small", "standard", "large")]
    [string]$Profile = "standard",

    [string]$Root = (Join-Path (Get-Location) ".flow")
)

$ErrorActionPreference = "Stop"

$slug = $Title.ToLowerInvariant() -replace "[^\p{L}\p{Nd}]+", "-"
$slug = $slug.Trim("-")
if ([string]::IsNullOrWhiteSpace($slug)) {
    throw "Title must contain at least one letter or number so a task folder can be created."
}

$templateRoot = Join-Path $PSScriptRoot "..\assets\templates"
$templateRoot = [System.IO.Path]::GetFullPath($templateRoot)
$taskRoot = Join-Path $Root "tasks"
$knowledgeRoot = Join-Path $Root "knowledge"
$taskPath = Join-Path $taskRoot $slug

if (Test-Path -LiteralPath $taskPath) {
    throw "Task already exists: $taskPath"
}

New-Item -ItemType Directory -Force $taskRoot, $knowledgeRoot | Out-Null
New-Item -ItemType Directory -Force $taskPath | Out-Null
Get-ChildItem -LiteralPath $templateRoot -File | Copy-Item -Destination $taskPath

$today = Get-Date -Format "yyyy-MM-dd"
$taskFile = Join-Path $taskPath "task.md"
$stateFile = Join-Path $taskPath "state.yaml"
$utf8NoBom = New-Object System.Text.UTF8Encoding($false)
$taskContent = (Get-Content -Raw $taskFile).Replace("<title>", $Title)
[System.IO.File]::WriteAllText($taskFile, $taskContent, $utf8NoBom)
$state = Get-Content -Raw $stateFile
$state = $state.Replace("profile: standard", "profile: $Profile").Replace("updated: YYYY-MM-DD", "updated: $today")
[System.IO.File]::WriteAllText($stateFile, $state, $utf8NoBom)

Write-Output "Created task: $taskPath"
