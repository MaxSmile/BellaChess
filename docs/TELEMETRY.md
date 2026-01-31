# Telemetry (MVP)

This document describes the **minimal telemetry** we want early so we can measure whether testers actually complete games.

## Principles
- Keep it **vendor-neutral** in code (`track()` wrapper).
- Default to **no-op** unless a telemetry vendor is configured.
- Avoid collecting personal data in MVP telemetry.

## Current implementation (web)
- Telemetry wrapper: `web/src/lib/telemetry.ts`
- GA4 support (optional): if `NEXT_PUBLIC_GA4_ID` is set, events are forwarded to `gtag()`.

## Event names (MVP)

### `try_play_started`
Emitted when the user reaches the “play surface”.

Recommended props:
- `surface`: `web`
- `page`: `home` (or route)

### `game_started`
Emitted when the first valid move is made.

Recommended props:
- `surface`
- `initial_fen` (currently `startpos` for the toy board)

### `move_made`
Emitted on each valid move.

Recommended props:
- `surface`
- `from`, `to` (e.g. `e2` → `e4`)
- `piece`, `color`
- `capture` (boolean)
- `move_count`

### `game_completed`
Emitted when a game ends.

Recommended props:
- `surface`
- `winner`
- `reason`
- `move_count`

## Notes
The current chess board is a simplified placeholder (toy rules). Once we replace it with legal chess rules + real engine integration, the same event names should be reused.
