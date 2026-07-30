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

$uprightPath = Join-Path $repoRoot "assets/fonts/SourceSans3VF-Upright.ttf.woff2"
$italicPath = Join-Path $repoRoot "assets/fonts/SourceSans3VF-Italic.ttf.woff2"
$licensePath = Join-Path $repoRoot "assets/fonts/source-sans-3-LICENSE.md"
$fontsScssPath = Join-Path $repoRoot "_sass/_fonts.scss"
$variablesPath = Join-Path $repoRoot "_sass/_variables.scss"
$mainScssPath = Join-Path $repoRoot "assets/css/main.scss"

foreach ($fontPath in @($uprightPath, $italicPath)) {
  Assert-True (Test-Path -LiteralPath $fontPath -PathType Leaf) "Missing font file: $fontPath"
  Assert-True ((Get-Item -LiteralPath $fontPath).Length -gt 10000) "Font file is unexpectedly small: $fontPath"
}

Assert-True (Test-Path -LiteralPath $licensePath -PathType Leaf) "Missing Source Sans 3 license"
Assert-True (Test-Path -LiteralPath $fontsScssPath -PathType Leaf) "Missing font-face Sass partial"

$license = Get-Content -Raw -LiteralPath $licensePath
$fontsScss = Get-Content -Raw -LiteralPath $fontsScssPath
$variables = Get-Content -Raw -LiteralPath $variablesPath
$mainScss = Get-Content -Raw -LiteralPath $mainScssPath

Assert-True ($license -match "SIL OPEN FONT LICENSE Version 1\.1") "Unexpected font license"
Assert-True (($fontsScss | Select-String -Pattern 'font-family:\s*"Source Sans 3"' -AllMatches).Matches.Count -eq 2) "Expected upright and italic Source Sans 3 declarations"
Assert-True ($fontsScss -match "SourceSans3VF-Upright\.ttf\.woff2") "Missing upright font source"
Assert-True ($fontsScss -match "SourceSans3VF-Italic\.ttf\.woff2") "Missing italic font source"
Assert-True (($fontsScss | Select-String -Pattern "font-display:\s*swap" -AllMatches).Matches.Count -eq 2) "Both font faces must use font-display: swap"
Assert-True ($fontsScss -match "font-weight:\s*200 900") "Variable weight range is missing"
Assert-True ($mainScss -match '@import "variables";\s*@import "fonts";') "Fonts must be imported after variables"
Assert-True ($variables -match '\$sans-serif\s*:\s*"Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans SC", "Microsoft YaHei", Arial, sans-serif;') "Unexpected sans-serif fallback stack"

Write-Output "Typography contract passed."
