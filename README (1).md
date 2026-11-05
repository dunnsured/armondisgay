# aux. — example database (revised)

SQLite example for **aux.** seeded from App mockups, quiz PDF, and category spreadsheet.

## Locked decisions
- Houses: Dreamer / Anchor / Curator / Rebel (canonical)
- Aliases: Timekeepers → Anchor, Wanderers → Rebel (`house_aliases`)
- Trait→house: **weighted** via `house_trait_weights` (not a hard lock)
- Privacy: profile + per-post visibility
- Engine: SQLite for now
- Assets: pictures/videos/album covers under each subcategory

## Still placeholder
- `reason_trait_points.is_placeholder = 1` until Ryan supplies the real button→trait point table
- Loyalty / Curiosity quiz prompts are stand-ins where the PDF was incomplete

## Files
- `aux_example.db`
- `schema.sql`
- `SAMPLE.md`
- `README.md`
