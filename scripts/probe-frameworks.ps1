param(
    [string]$ProjectRoot = (Get-Location)
)

$ErrorActionPreference = "Stop"

function Find-CommandPath([string]$Name) {
    $command = Get-Command $Name -ErrorAction SilentlyContinue
    if ($null -eq $command) {
        return $null
    }

    return $command.Source
}

function Find-FirstCommandPath([string[]]$Names) {
    foreach ($name in $Names) {
        $path = Find-CommandPath $name
        if ($path) {
            return $path
        }
    }

    return $null
}

function Read-FirstLine([string]$Path) {
    if (-not $Path -or -not (Test-Path -LiteralPath $Path)) {
        return $null
    }

    $line = Get-Content -LiteralPath $Path -TotalCount 1 -ErrorAction SilentlyContinue
    if ($null -eq $line) {
        return $null
    }

    return $line.Trim()
}

function Get-CommandVersion([string]$Path) {
    if (-not $Path) {
        return $null
    }

    try {
        $output = @(& $Path "--version" 2>&1)
        if ($output.Count -eq 0) {
            return $null
        }

        return ([string]$output[0]).Trim()
    }
    catch {
        return $null
    }
}

function Get-ChildDirectoryNames([string]$Root, [string]$Pattern = "*") {
    if (-not (Test-Path -LiteralPath $Root)) {
        return @()
    }

    return @(Get-ChildItem -LiteralPath $Root -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -like $Pattern } |
        Select-Object -ExpandProperty Name)
}

function Get-MatchingSkillNames([string[]]$Roots, [string[]]$Patterns) {
    $names = [System.Collections.Generic.List[string]]::new()

    foreach ($root in $Roots) {
        foreach ($pattern in $Patterns) {
            Get-ChildDirectoryNames -Root $root -Pattern $pattern |
                ForEach-Object { [void]$names.Add($_) }
        }
    }

    return @($names | Sort-Object -Unique)
}

function Select-AvailableNames([string[]]$Available, [string[]]$Expected) {
    return @($Expected | Where-Object { $Available -contains $_ })
}

$resolvedProjectRoot = [System.IO.Path]::GetFullPath($ProjectRoot)
$userProfilePath = [Environment]::GetFolderPath([Environment+SpecialFolder]::UserProfile)
$codexHomePath = if ($env:CODEX_HOME) { $env:CODEX_HOME } else { Join-Path $userProfilePath ".codex" }
$pluginCacheRoot = Join-Path $codexHomePath "plugins\cache"
$globalSkillRoot = Join-Path $codexHomePath "skills"
$projectAgentSkillRoot = Join-Path $resolvedProjectRoot ".agents\skills"
$projectCodexSkillRoot = Join-Path $resolvedProjectRoot ".codex\skills"
$skillRoots = @($globalSkillRoot, $projectAgentSkillRoot, $projectCodexSkillRoot)

$openspecCommand = Find-FirstCommandPath @("openspec.cmd", "openspec")
$nodeCommand = Find-FirstCommandPath @("node.exe", "node")
$omxCommand = Find-FirstCommandPath @("omx.cmd", "omx")
$openspecProject = Join-Path $resolvedProjectRoot "openspec"
$omxProject = Join-Path $resolvedProjectRoot ".omx"

$openspecSkills = @(Get-MatchingSkillNames -Roots $skillRoots -Patterns @("openspec-*", "opsx*"))
$gstackSkills = @(Get-MatchingSkillNames -Roots $skillRoots -Patterns @("gstack", "gstack-*"))
$gstackCoreExpected = @(
    "gstack-office-hours",
    "gstack-plan-ceo-review",
    "gstack-plan-eng-review",
    "gstack-plan-design-review",
    "gstack-qa",
    "gstack-qa-only"
)
$gstackCoreSkills = @(Select-AvailableNames -Available $gstackSkills -Expected $gstackCoreExpected)
$gstackVersionFile = Join-Path $userProfilePath ".gstack\.last-setup-version"

$cePackageRoot = Join-Path $pluginCacheRoot "compound-engineering-plugin\compound-engineering"
$ceVersionDirectories = if (Test-Path -LiteralPath $cePackageRoot) {
    @(Get-ChildItem -LiteralPath $cePackageRoot -Directory -ErrorAction SilentlyContinue |
        Where-Object { $_.Name -match '^\d+\.\d+\.\d+$' })
}
else {
    @()
}
$ceVersions = @($ceVersionDirectories | Select-Object -ExpandProperty Name)
$ceLatestDirectory = $ceVersionDirectories |
    Sort-Object { [Version]$_.Name } -Descending |
    Select-Object -First 1
$ceSkillRoot = if ($ceLatestDirectory) { Join-Path $ceLatestDirectory.FullName "skills" } else { $null }
$ceSkills = @(if ($ceSkillRoot) { Get-ChildDirectoryNames -Root $ceSkillRoot })
$ceCoreExpected = @(
    "ce-ideate",
    "ce-brainstorm",
    "ce-plan",
    "ce-work",
    "ce-code-review",
    "ce-doc-review",
    "ce-polish",
    "ce-compound"
)
$ceCoreSkills = @(Select-AvailableNames -Available $ceSkills -Expected $ceCoreExpected)

$runningOnWindows = $env:OS -eq "Windows_NT"

[ordered]@{
    projectRoot = $resolvedProjectRoot
    environment = [ordered]@{
        os = if ($runningOnWindows) { "Windows" } else { [Environment]::OSVersion.Platform.ToString() }
        codexHome = $codexHomePath
    }
    openspec = [ordered]@{
        available = [bool](($openspecCommand -and $nodeCommand) -or (Test-Path -LiteralPath $openspecProject) -or $openspecSkills.Count -gt 0)
        command = $openspecCommand
        version = Get-CommandVersion $openspecCommand
        nodeCommand = $nodeCommand
        cliReady = [bool]($openspecCommand -and $nodeCommand)
        projectArtifacts = Test-Path -LiteralPath $openspecProject
        installedSkills = $openspecSkills
        activationRequired = "Use only an OpenSpec skill active in this session or a command supported by the installed CLI version."
        route = "Optional task/spec owner; keep CE as the implementation-plan owner and reconcile the change at close."
    }
    gstack = [ordered]@{
        available = $gstackSkills.Count -gt 0
        version = Read-FirstLine $gstackVersionFile
        installedSkillCount = $gstackSkills.Count
        coreSkills = $gstackCoreSkills
        activationRequired = "A matching gstack skill must be active in the current Codex session."
        route = "Use selected product, architecture, design, QA-only, or authorized QA fix-loop gates."
    }
    compoundEngineering = [ordered]@{
        available = $ceSkills.Count -gt 0
        versions = $ceVersions
        activeCacheVersion = if ($ceLatestDirectory) { $ceLatestDirectory.Name } else { $null }
        coreSkills = $ceCoreSkills
        activationRequired = "A matching CE skill must be active in the current Codex session."
        route = "Use CE for ideate/brainstorm, plan, work, code/doc review, explicit polish, and compound."
    }
    omx = [ordered]@{
        available = [bool]$omxCommand
        command = $omxCommand
        version = Get-CommandVersion $omxCommand
        projectArtifacts = Test-Path -LiteralPath $omxProject
        hostCaution = if ($runningOnWindows) { "Official OMX guidance does not recommend native Windows or Codex App as the default runtime; verify the runtime before launch." } else { $null }
        activationRequired = "Use only after explicit approval of the exact team or task-specific worktree launch."
        route = "Optional parallel runtime only; Personal Flow does not adopt OMX autopilot or Ralph."
    }
} | ConvertTo-Json -Depth 6
