# bellachess.org

## Overview
Bella Chess: Reimagine chess with AI, etudes, and NFT collectibles. An open-source project combining Flutter mobile apps and a Next.js web app, with AI opponents/coach and Web3-based collectibles.

Project site: https://bellachess.org

## Categories / tags
Mobile App, iOS, Android, Flutter, Web, Next.js, AI, Game, Web3, DApp, Blockchain, Smart Contracts, NFT, Crypto, Decentralized, Open Source

## Product pillars
- AI chess teacher: adaptive difficulty, analysis, feedback, and training plans
- Etude challenges: puzzle library with progressive difficulty and detailed solutions
- NFT collectibles: “digital trophies” tied to achievements and legendary etudes
- Cross-platform: mobile + web experience with shared identity/progression (TBD)

## Core features (intended)
**Play**
- AI opponents with adjustable strength
- Post-game analysis and suggested alternatives (see `ENGINE.md` for engine strategy + interface contract)

**Learn**
- Personalized AI coach (adaptive difficulty + guidance)
- Training plans by topic (openings / middlegame / endgame)
- Etude/puzzle mode with hints + full explanations

**Collect**
- Etude-based NFTs representing famous positions and tactical ideas
- Earned via etudes, ranked ladders, and limited-time events
- Potential in-game perks for some NFTs (TBD)

## Web3 / NFT model (draft)
- Minting: direct chain minting after earning an achievement (TBD: custody model)
- Smart contracts: open-source (for transparency + audits)
- Target networks (stated): Ethereum, Gnosis, Tron, Polygon (TBD: final selection + priority order)

## Tech (stated)
- Mobile: Flutter (iOS + Android)
- Web: Next.js
- AI: opponents/coach (TBD: engine choice, model choice, infra)
- Web3: smart contracts + wallet integration (TBD)

## Repository
- GitHub: `https://github.com/Vasilkoff-com/BellaChess`
- Contains the open-source chess platform implementation
- Hosted under the Vasilkoff-com organization

## Repository Reconciliation Note
Upon examination of the actual repositories, we discovered that there are two BellaChess repositories:

1. **Vasilkoff-com/BellaChess**: Contains documentation describing a betting-focused chess game with $BLCH Play-Tokens and three-repository architecture (Flutter, Next.js DApp, Hardhat smart contracts), but the DApp and Contracts repositories were not accessible.

2. **MaxSmile/BellaChess**: Contains a fully functional Flutter chess game with six-level AI difficulty, complete game features, and published apps on both Google Play and App Store.

The actual implementation is a sophisticated chess game with advanced AI algorithms rather than the betting-focused platform described in the documentation. The recommended approach is to merge the original educational vision with the existing high-quality chess implementation to create an enhanced platform.

## Native Transition Initiative
We are currently planning a transition from the existing Flutter app to a native architecture consisting of:
- Next.js web application as the primary platform
- Native iOS and Android WebView wrappers
- Pure native implementations rather than Flutter-based

See NATIVE_TRANSITION_PLAN.md for detailed implementation strategy.

## Documentation
- [TECHNICAL_DESCRIPTION.md](TECHNICAL_DESCRIPTION.md) - Comprehensive technical architecture
- [TASKS.md](TASKS.md) - Detailed implementation roadmap
- [MARKETING_PLAN.md](MARKETING_PLAN.md) - Go-to-market strategy
- [ANALYTICS_PLAN.md](ANALYTICS_PLAN.md) - Data collection and measurement framework
- [PRODUCTION_READINESS.md](PRODUCTION_READINESS.md) - Pre-launch checklist and requirements
- [RECONCILIATION.md](RECONCILATION.md) - Project reconciliation with actual repository
- [SYNTHESIS.md](SYNTHESIS.md) - Best of both worlds combination
- [ACTUAL_FINDINGS_AND_ENHANCEMENT_OPPORTUNITIES.md](ACTUAL_FINDINGS_AND_ENHANCEMENT_OPPORTUNITIES.md) - Real app findings and enhancement opportunities
- [NATIVE_TRANSITION_PLAN.md](NATIVE_TRANSITION_PLAN.md) - Native iOS/Android transition strategy
- [AI_COACH_SYSTEM_DESIGN.md](AI_COACH_SYSTEM_DESIGN.md) - AI Coach system architecture and implementation
- [ETUDE_CHALLENGE_SYSTEM_DESIGN.md](ETUDE_CHALLENGE_SYSTEM_DESIGN.md) - Etude Challenge system architecture and implementation
- [WEB3_NFT_INTEGRATION_DESIGN.md](WEB3_NFT_INTEGRATION_DESIGN.md) - Web3 NFT integration architecture and implementation
- [SYSTEM_INTEGRATION_ENHANCEMENT.md](SYSTEM_INTEGRATION_ENHANCEMENT.md) - System integration enhancement plan

## Open source
Bella Chess is community-driven.
- Contribution: (TBD: guidelines, code of conduct, issue labels)

## Why this matters for Vasilkoff Ltd (positioning)
Bella Chess demonstrates capability to deliver complex, cross-platform products that combine mobile (Flutter) + web (Next.js) with advanced AI experiences and Web3/NFT infrastructure. Useful as a reference for clients building GameFi, AI-driven platforms, or sophisticated DApps requiring secure, seamless mobile/web integration.

## Roadmap
**Now (foundation)**
- Publish repo link + contribution docs (README/CONTRIBUTING)
- Define product scope: “Play vs Learn vs Collect” MVP boundaries
- Decide AI approach (engine/model), evaluation metrics, and cost envelope
- Define NFT earning rules + rarity model (and what is purely cosmetic vs utility)

**Next (MVP)**
- Cross-platform auth + profiles + progression
- AI opponent + post-game analysis
- Etude/puzzle library MVP + progress tracking
- Wallet connect + testnet minting for 1–3 NFT types
- Basic anti-cheat and abuse controls (ranked + rewards)

**Later (scale + differentiation)**
- AI coach with training plans and real-time feedback overlays
- Ranked ladder + seasons + tournaments + limited-time events
- Multi-chain production minting + marketplace integration
- Creator pipeline for new etudes/NFT drops and editorial content
- Community features (clubs, co-op puzzle solving, sharing)

## Marketing (starter kit)
**One-liner**
- “Bella Chess is an open-source chess platform that teaches you with AI, challenges you with etudes, and rewards mastery with collectible NFTs.”

**Target audiences**
- Chess improvers who want coaching + structured puzzles
- Web3-native collectors who want skill-based collectibles (not pure speculation)
- Developers interested in open-source Flutter/Next.js/GameFi reference implementations

**Key messages**
- Skill-first: collectibles earned by mastery, not just buying
- Learning-first: AI coach + explanations, not just a chess engine UI
- Open-source + transparent contracts: auditable and community-driven

**Top acquisition channels (suggested)**
- SEO content: “etude puzzles”, “AI chess coach”, “chess tactics NFT”, “learn endgames”
- Chess communities: Reddit /r/chess, Lichess forums, chess Discords (carefully, non-spam)
- Dev communities: Flutter/Next.js/Web3 builders (open-source angle)
- Product launches: demo videos + short “before/after” learning progress stories

**Landing page sections (suggested)**
- Hero (AI coach + etudes + collectible mastery)
- Demo video + screenshots (mobile + web)
- How earning NFTs works (simple 3-step)
- Trust: open-source, contract links, security stance
- Roadmap + community call-to-action (contributors + early users)

## Open questions
- What is shipped today (mobile/web, gameplay, puzzles, NFTs)?
- Where is the GitHub repository URL?
- Which chain(s) are actually supported today, and which are planned?
- What is the first “must-win” persona: chess learner, Web3 collector, or dev community?
