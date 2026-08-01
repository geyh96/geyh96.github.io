$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

function Assert-True {
  param(
    [bool]$Condition,
    [string]$Message
  )

  if (-not $Condition) {
    throw $Message
  }
}

$variablesPath = Join-Path $repoRoot "_sass/_variables.scss"
$mainScssPath = Join-Path $repoRoot "assets/css/main.scss"
$baseScssPath = Join-Path $repoRoot "_sass/_base.scss"
$resetScssPath = Join-Path $repoRoot "_sass/_reset.scss"

$variables = Get-Content -Raw -LiteralPath $variablesPath
$mainScss = Get-Content -Raw -LiteralPath $mainScssPath
$baseScss = Get-Content -Raw -LiteralPath $baseScssPath
$resetScss = Get-Content -Raw -LiteralPath $resetScssPath

Assert-True ($variables -match '\$doc-font-size\s*:\s*16;') "Base font size must match the reference site"
Assert-True ($variables -match '\$serif\s*:\s*Georgia, Times, serif;') "Serif stack must match the reference site"
Assert-True ($variables -match '\$sans-serif\s*:\s*-apple-system, Palatino, "Palatino Linotype", "Palatino LT STD", Georgia, "source-han-serif-sc", "Source Han Serif SC", "Source Han Serif CN", "Source Han Serif TC", "Source Han Serif TW", "Source Han Serif", "Songti SC", "Microsoft YaHei", serif;') "Primary font stack must match the reference site"
Assert-True ($variables -match '\$monospace\s*:\s*Monaco, Consolas, "Lucida Console", monospace;') "Code font stack must match the reference site"
Assert-True ($variables -match '\$global-font-family\s*:\s*\$sans-serif;') "Global text must use the reference font stack"
Assert-True ($variables -match '\$header-font-family\s*:\s*\$sans-serif;') "Headings must use the reference font stack"
Assert-True ($variables -match '\$caption-font-family\s*:\s*\$serif;') "Captions must use the reference serif stack"
Assert-True ($resetScss -match 'html\s*\{[\s\S]*?font-size:\s*16px;[\s\S]*?@include breakpoint\(\$medium\)\s*\{\s*font-size:\s*18px;') "Responsive root font sizes must match the reference site"
Assert-True ($mainScss -notmatch '@import "fonts";') "Unused Source Sans web fonts must not be included in generated CSS"
Assert-True ($baseScss -match 'h1,\s*h2,\s*h3,\s*h4,\s*h5,\s*h6\s*\{[\s\S]*?font-weight:\s*bold;') "All heading levels must remain bold"

Write-Output "Typography contract passed."
