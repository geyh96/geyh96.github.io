# Source Sans 3 Typography Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Self-host Source Sans 3 and use it consistently for the site's body text, headings, navigation, publication entries, and sidebar text.

**Architecture:** Add Adobe's official upright and italic variable WOFF2 files plus their SIL Open Font License under `assets/fonts/`. Declare one shared web-font family in a focused Sass partial, then place that family first in the theme's existing `$sans-serif` stack so all current consumers inherit it without layout-specific overrides.

**Tech Stack:** Jekyll, Sass/SCSS, PowerShell, WOFF2 variable fonts

---

## File Map

- Create `test/typography_test.ps1`: executable typography contract covering assets, license, Sass declarations, import order, and fallback stack.
- Create `assets/fonts/SourceSans3VF-Upright.ttf.woff2`: official upright Source Sans 3 variable web font.
- Create `assets/fonts/SourceSans3VF-Italic.ttf.woff2`: official italic Source Sans 3 variable web font.
- Create `assets/fonts/source-sans-3-LICENSE.md`: official SIL Open Font License distributed with the font files.
- Create `_sass/_fonts.scss`: local `@font-face` declarations only.
- Modify `assets/css/main.scss`: import the font declarations after variables and before base rules.
- Modify `_sass/_variables.scss`: replace the current Palatino-led `$sans-serif` stack with the approved Source Sans 3 and system/CJK fallback stack.

### Task 1: Add a Failing Typography Contract

**Files:**
- Create: `test/typography_test.ps1`

- [ ] **Step 1: Write the failing test**

```powershell
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
```

- [ ] **Step 2: Run the test and verify the expected failure**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/typography_test.ps1
```

Expected: nonzero exit with `Missing font file: ...SourceSans3VF-Upright.ttf.woff2`.

- [ ] **Step 3: Commit the failing test**

```powershell
git add test/typography_test.ps1
git commit -m "test: define Source Sans typography contract"
```

### Task 2: Add the Licensed Font Assets

**Files:**
- Create: `assets/fonts/SourceSans3VF-Upright.ttf.woff2`
- Create: `assets/fonts/SourceSans3VF-Italic.ttf.woff2`
- Create: `assets/fonts/source-sans-3-LICENSE.md`

- [ ] **Step 1: Download the official upright variable WOFF2**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adobe-fonts/source-sans/release/WOFF2/VF/SourceSans3VF-Upright.ttf.woff2" -OutFile "assets/fonts/SourceSans3VF-Upright.ttf.woff2"
```

Expected: `assets/fonts/SourceSans3VF-Upright.ttf.woff2` exists and is larger than 10 KB.

- [ ] **Step 2: Download the official italic variable WOFF2**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adobe-fonts/source-sans/release/WOFF2/VF/SourceSans3VF-Italic.ttf.woff2" -OutFile "assets/fonts/SourceSans3VF-Italic.ttf.woff2"
```

Expected: `assets/fonts/SourceSans3VF-Italic.ttf.woff2` exists and is larger than 10 KB.

- [ ] **Step 3: Download the official license**

```powershell
Invoke-WebRequest -Uri "https://raw.githubusercontent.com/adobe-fonts/source-sans/release/LICENSE.md" -OutFile "assets/fonts/source-sans-3-LICENSE.md"
```

Expected: the downloaded file contains `SIL OPEN FONT LICENSE Version 1.1`.

- [ ] **Step 4: Re-run the contract and verify it reaches the next missing component**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/typography_test.ps1
```

Expected: nonzero exit with `Missing font-face Sass partial`.

- [ ] **Step 5: Commit the font assets**

```powershell
git add assets/fonts/SourceSans3VF-Upright.ttf.woff2 assets/fonts/SourceSans3VF-Italic.ttf.woff2 assets/fonts/source-sans-3-LICENSE.md
git commit -m "assets: self-host Source Sans 3"
```

### Task 3: Declare and Apply Source Sans 3

**Files:**
- Create: `_sass/_fonts.scss`
- Modify: `assets/css/main.scss`
- Modify: `_sass/_variables.scss`
- Test: `test/typography_test.ps1`

- [ ] **Step 1: Add the upright and italic variable font declarations**

Create `_sass/_fonts.scss`:

```scss
/* ==========================================================================
   Local web fonts
   ========================================================================== */

@font-face {
  font-family: "Source Sans 3";
  font-style: normal;
  font-weight: 200 900;
  font-display: swap;
  src: url("../fonts/SourceSans3VF-Upright.ttf.woff2") format("woff2");
}

@font-face {
  font-family: "Source Sans 3";
  font-style: italic;
  font-weight: 200 900;
  font-display: swap;
  src: url("../fonts/SourceSans3VF-Italic.ttf.woff2") format("woff2");
}
```

- [ ] **Step 2: Import the font partial**

In `assets/css/main.scss`, change:

```scss
@import "variables";
@import "mixins";
```

to:

```scss
@import "variables";
@import "fonts";
@import "mixins";
```

- [ ] **Step 3: Replace the shared sans-serif stack**

In `_sass/_variables.scss`, replace the commented historical system stack and current Palatino-led stack with:

```scss
$sans-serif                 : "Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI", "Noto Sans SC", "Microsoft YaHei", Arial, sans-serif;
```

Leave `$serif`, `$monospace`, `$sans-serif-narrow`, `$global-font-family`, and `$header-font-family` otherwise unchanged so existing selectors inherit the new family.

Do not edit the type-scale variables, line heights, colors, spacing rules, `_sass/vendor/font-awesome/`, or code typography. These remain outside the change set, preserving the existing layout and Font Awesome/monospace declarations.

- [ ] **Step 4: Run the typography contract and verify it passes**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/typography_test.ps1
```

Expected:

```text
Typography contract passed.
```

- [ ] **Step 5: Commit the Sass implementation**

```powershell
git add _sass/_fonts.scss _sass/_variables.scss assets/css/main.scss
git commit -m "style: apply Source Sans 3 typography"
```

### Task 4: Build and Inspect the Generated Site

**Files:**
- Verify: `_site/assets/css/main.css`

- [ ] **Step 1: Build the development site**

Run:

```powershell
bundle exec jekyll build --config _config.yml,_config.dev.yml
```

Expected: exit code 0 with `done in` in the final Jekyll output.

- [ ] **Step 2: Verify the generated stylesheet**

Run:

```powershell
$css = Get-Content -Raw "_site/assets/css/main.css"
if ($css -notmatch 'font-family:\s*"Source Sans 3"') { throw "Generated CSS is missing Source Sans 3" }
if ($css -notmatch "SourceSans3VF-Upright\.ttf\.woff2") { throw "Generated CSS is missing the upright font URL" }
if ($css -notmatch "SourceSans3VF-Italic\.ttf\.woff2") { throw "Generated CSS is missing the italic font URL" }
if ($css -notmatch "font-display:\s*swap") { throw "Generated CSS is missing font-display: swap" }
Write-Output "Generated typography CSS passed."
```

Expected:

```text
Generated typography CSS passed.
```

- [ ] **Step 3: Verify the full change set**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/typography_test.ps1
git diff --check
git status --short
```

Expected: typography contract passes, `git diff --check` has no output, and status lists only the intended font, Sass, test, specification, and plan files.

- [ ] **Step 4: Commit the verified documentation**

```powershell
git add docs/superpowers/specs/2026-07-30-source-sans-3-typography-design.md docs/superpowers/plans/2026-07-30-source-sans-3-typography.md
git commit -m "docs: record Source Sans typography design"
```
