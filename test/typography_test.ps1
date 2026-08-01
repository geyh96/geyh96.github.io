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

$georgiaDeclaration = $variables.IndexOf('$georgia                    : Georgia, serif;')
$serifReference = $variables.IndexOf('$serif                      : $georgia;')
$sansSerifReference = $variables.IndexOf('$sans-serif                 : $georgia;')

Assert-True ($georgiaDeclaration -ge 0) "Missing Georgia font stack"
Assert-True ($serifReference -gt $georgiaDeclaration) "Georgia must be declared before the serif stack references it"
Assert-True ($sansSerifReference -gt $georgiaDeclaration) "Georgia must be declared before the sans-serif stack references it"
Assert-True ($variables -match '\$global-font-family\s*:\s*\$georgia;') "Global text must use Georgia"
Assert-True ($variables -match '\$header-font-family\s*:\s*\$georgia;') "Headings must use Georgia"
Assert-True ($variables -match '\$caption-font-family\s*:\s*\$georgia;') "Captions must use Georgia"
Assert-True ($mainScss -notmatch '@import "fonts";') "Unused Source Sans web fonts must not be included in generated CSS"
Assert-True ($baseScss -match 'h1,\s*h2,\s*h3,\s*h4,\s*h5,\s*h6\s*\{[\s\S]*?font-weight:\s*bold;') "All heading levels must remain bold"

Write-Output "Typography contract passed."
