# Merge Publications into About

## Goal

Show the existing publications and working papers on the About page while removing the Research/Publications option from the site's main navigation.

## Design

- Append the body content from `_pages/publications.md` to the bottom of `_pages/about.md`.
- Keep `_pages/publications.md` unchanged so the existing `/publications/` route remains available.
- Remove the `Research` entry that links to `/publications/` from `_data/navigation.yml`.
- Preserve the existing publication ordering, headings, Markdown formatting, and all unrelated navigation items.

## Verification

- Confirm the About source contains both `## Publications` and `## Working Papers`.
- Confirm `_data/navigation.yml` contains no main-navigation link to `/publications/`.
- Confirm `_pages/publications.md` remains unchanged.
- Build the Jekyll site and check that generation succeeds.
