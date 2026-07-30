# Source Sans 3 Typography

## Goal

Use Source Sans 3 consistently across the English academic homepage while preserving reliable Chinese and system-font fallbacks.

## Considered Approaches

1. Self-host Source Sans 3 web fonts. This is the selected approach because it gives the site a consistent appearance without depending on an external font service.
2. Load Source Sans 3 from Google Fonts. This keeps the repository smaller but introduces an external request and can be unreliable for visitors in mainland China.
3. Use only the operating-system font stack. This is fastest but does not provide consistent typography across platforms.

## Design

- Store the Source Sans 3 upright and italic web-font files under `assets/fonts/`.
- Declare the local files with `@font-face` and `font-display: swap`.
- Make Source Sans 3 the first choice in the site's shared sans-serif stack.
- Retain Apple and Windows system fonts as English fallbacks.
- Retain `Noto Sans SC`, `Microsoft YaHei`, and a generic `sans-serif` as Chinese and final fallbacks.
- Continue using the shared stack for body text, headings, navigation, publication entries, and sidebar text.
- Do not change font sizes, font weights, line heights, colors, spacing, or page layout.
- Keep Font Awesome declarations and code/monospace typography unchanged.

## Verification

- Confirm the required local Source Sans 3 web-font files exist.
- Confirm the generated stylesheet contains the local `@font-face` declarations with `font-display: swap`.
- Confirm the generated body font stack begins with `"Source Sans 3"` and contains the specified system and Chinese fallbacks.
- Build the Jekyll site and confirm generation succeeds without warnings caused by the typography change.

