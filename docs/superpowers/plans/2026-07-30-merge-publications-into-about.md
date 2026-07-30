# Merge Publications into About Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Display all publication entries on the About page and remove the Research/Publications link from the main navigation while preserving the standalone Publications source page.

**Architecture:** This is a source-content change in the existing Jekyll site. The Publications page body is copied into the About page, while the navigation data removes only the `/publications/` entry; a small PowerShell regression test checks these source-level guarantees before the full Jekyll build.

**Tech Stack:** Jekyll, Markdown, YAML, PowerShell

---

### Task 1: Add a failing source-content regression test

**Files:**
- Create: `test/publications-on-about.tests.ps1`
- Inspect: `_pages/about.md`
- Inspect: `_pages/publications.md`
- Inspect: `_data/navigation.yml`

- [ ] **Step 1: Write the failing test**

Create `test/publications-on-about.tests.ps1` with:

```powershell
$ErrorActionPreference = 'Stop'

$about = Get-Content -Raw '_pages/about.md'
$publications = Get-Content -Raw '_pages/publications.md'
$navigation = Get-Content -Raw '_data/navigation.yml'

if ($about -notmatch '(?m)^## Publications$') {
    throw 'About page does not contain the Publications section.'
}

if ($about -notmatch '(?m)^## Working Papers$') {
    throw 'About page does not contain the Working Papers section.'
}

if ($navigation -match '(?m)^\s+url:\s*/publications/\s*$') {
    throw 'Main navigation still links to /publications/.'
}

if ($publications -notmatch '(?m)^permalink:\s*/publications/\s*$') {
    throw 'The standalone Publications page was removed or its permalink changed.'
}

Write-Output 'Publications/About source checks passed.'
```

- [ ] **Step 2: Run the test to verify it fails**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/publications-on-about.tests.ps1
```

Expected: non-zero exit with `About page does not contain the Publications section.`

- [ ] **Step 3: Commit the regression test**

```powershell
git add test/publications-on-about.tests.ps1
git commit -m "test: cover publications on about page"
```

### Task 2: Merge the content and hide the navigation entry

**Files:**
- Modify: `_pages/about.md`
- Modify: `_data/navigation.yml`
- Preserve unchanged: `_pages/publications.md`
- Test: `test/publications-on-about.tests.ps1`

- [ ] **Step 1: Append the Publications page body to About**

Append everything from the first `## Publications` heading through the final working-paper entry in `_pages/publications.md` to the end of `_pages/about.md`. The exact transformation is:

```powershell
$about = Get-Content -Raw '_pages/about.md'
$publicationsPage = Get-Content -Raw '_pages/publications.md'
$sectionStart = $publicationsPage.IndexOf('## Publications')
if ($sectionStart -lt 0) {
    throw 'Publications heading was not found.'
}
$publicationBody = $publicationsPage.Substring($sectionStart).TrimEnd()
$mergedAbout = $about.TrimEnd() + "`r`n`r`n" + $publicationBody + "`r`n"
```

Apply the resulting `$mergedAbout` content to `_pages/about.md` without changing `_pages/publications.md`. This direct substring copy preserves names, punctuation, ordering, and status text.

- [ ] **Step 2: Remove the Research navigation item**

Change `_data/navigation.yml` from:

```yaml
main:
  - title: "Research"
    url: /publications/

  - title: "Misc"
    url: /Misc/
```

to:

```yaml
main:
  - title: "Misc"
    url: /Misc/
```

Keep the Contact item and all unrelated spacing/content intact.

- [ ] **Step 3: Run the source-content test to verify it passes**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/publications-on-about.tests.ps1
```

Expected: exit code 0 and `Publications/About source checks passed.`

- [ ] **Step 4: Confirm the standalone Publications file is unchanged**

Run:

```powershell
git diff --exit-code -- _pages/publications.md
```

Expected: exit code 0 with no output.

- [ ] **Step 5: Commit the site change**

```powershell
git add _pages/about.md _data/navigation.yml
git commit -m "feat: show publications on about page"
```

### Task 3: Verify the generated site

**Files:**
- Verify: `_pages/about.md`
- Verify: `_data/navigation.yml`
- Verify: `_pages/publications.md`

- [ ] **Step 1: Run the complete Jekyll build**

Run:

```powershell
bundle exec jekyll build --config _config.yml,_config.dev.yml
```

Expected: exit code 0 and a completed build with no fatal error.

- [ ] **Step 2: Re-run the regression check**

Run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File test/publications-on-about.tests.ps1
```

Expected: exit code 0 and `Publications/About source checks passed.`

- [ ] **Step 3: Inspect the final diff**

Run:

```powershell
git diff --check
git status --short
```

Expected: no whitespace errors; only intentionally uncommitted build artifacts, if the project generates any, may appear.
