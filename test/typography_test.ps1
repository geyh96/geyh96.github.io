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

$variables = Get-Content -Raw -LiteralPath $variablesPath
$mainScss = Get-Content -Raw -LiteralPath $mainScssPath
$baseScss = Get-Content -Raw -LiteralPath $baseScssPath

Assert-True ($variables -match '\$consolas\s*:\s*Consolas, "Cascadia Mono", "SFMono-Regular", "Liberation Mono", "Courier New", "Microsoft YaHei", monospace;') "Missing Consolas font stack"
Assert-True ($variables -match '\$serif\s*:\s*\$consolas;') "Serif consumers must use the Consolas stack"
Assert-True ($variables -match '\$sans-serif\s*:\s*\$consolas;') "Sans-serif consumers must use the Consolas stack"
Assert-True ($variables -match '\$monospace\s*:\s*\$consolas;') "Monospace consumers must use the Consolas stack"
Assert-True ($mainScss -notmatch '@import "fonts";') "Unused Source Sans web fonts must not be included in generated CSS"
Assert-True ($baseScss -match 'h1,\s*h2,\s*h3,\s*h4,\s*h5,\s*h6\s*\{[\s\S]*?font-weight:\s*bold;') "All heading levels must remain bold"

Write-Output "Typography contract passed."
