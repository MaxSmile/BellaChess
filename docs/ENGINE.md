# Engine Strategy + Interface Contract

This document defines a stable **engine integration strategy** and a minimal, vendor-neutral **interface contract** so we can build:
- M2/M3 “Play vs AI” (web)
- M3 Offline-first (PWA)
- M5+ analysis/coach quality

…without refactoring the app every time we swap Stockfish builds or move compute between client and server.

## Goals
- **Correctness first**: engine output must never break chess rules.
- **Fast feedback loop**: target sub-250ms median response for “best move” at low depth on modern devices.
- **Portable**: same interface works in Web (WASM/Worker) now, and can later route to backend.
- **Offline capable** (web): minimum viable vs-AI should work offline (cached WASM + worker).

## Recommended strategy (phased)

### Phase A (Web MVP): Client-side Stockfish (WASM) in a Web Worker
**Default path for v1.**
- Run Stockfish compiled to WASM.
- Execute inside a dedicated **Web Worker** to avoid blocking UI.
- Cache WASM assets via PWA service worker for offline.

Why:
- Lowest latency (no round-trip).
- Works offline.
- Lower infra cost.

### Phase B (Hybrid): Client for play, server for heavy analysis
- Keep client WASM for in-game opponent.
- Use backend workers for deep post-game analysis / coach annotations.

Why:
- Deep analysis can be expensive on mobile.
- Server can enforce consistent depth and guardrails.

### Phase C (Server-side): Backend engine workers (optional)
- For enterprise/competitive modes or very low-end devices.
- Can support alternative engines (LCZero) or GPU-backed analysis.

## Interface contract (TypeScript)

### Core types
```ts
export type Color = 'white' | 'black';

export type EngineGoMode =
  | { kind: 'depth'; depth: number }
  | { kind: 'movetime'; ms: number };

export type EngineStartOptions = {
  threads?: number;      // default: 1
  hashMb?: number;       // default: 64
  skillLevel?: number;   // 0..20 (Stockfish)
};

export type EngineBestMoveRequest = {
  fen: string;
  go: EngineGoMode;
};

export type EngineBestMoveResponse = {
  bestMoveUci: string;
  ponderUci?: string;
  depth?: number;
  nodes?: number;
  nps?: number;
  scoreCp?: number;   // centipawns (positive = white better)
  mateIn?: number;    // optional mate distance
  pvUci?: string[];   // principal variation (uci)
};
```

### Engine interface
```ts
export interface ChessEngine {
  start(opts?: EngineStartOptions): Promise<void>;
  stop(): Promise<void>; // terminate worker/process

  // Best move for a given position
  bestMove(req: EngineBestMoveRequest): Promise<EngineBestMoveResponse>;
}
```

### Error contract
- `ENGINE_NOT_READY`
- `ENGINE_TIMEOUT`
- `ENGINE_CRASHED`
- `INVALID_FEN`

## Web implementation notes

### Worker boundary
- UI thread talks to a worker via `postMessage`.
- The worker owns the Stockfish instance.
- Requests are **idempotent** and include a `requestId`.

### Caching (for Offline-first milestone)
- Cache engine assets (`/engine/stockfish.wasm`, worker script, etc.)
- Version assets with a hash in filename to enable safe updates.

## Mapping difficulty → engine settings
We keep a single function to map a user-facing difficulty ladder to engine parameters.

Suggested v1 mapping:
- Difficulty 1..6 → `skillLevel` 1..10 and a small depth cap.
- Use `movetime` for low-end devices (more stable UX).

## How this relates to current code
- Today `web/src/app/api/chess-engine/route.ts` is a **mock**.
- Once we implement Stockfish WASM, this doc’s interface becomes the contract.
- The telemetry events (try_play_started/game_started/move_made/game_completed) should remain stable across implementations.

## Next tasks unlocked by this doc
- Web: JS opponent (Stockfish WASM integration)
- Web: Replace toy board with legal chess rules
- Offline-first PWA with cached engine
