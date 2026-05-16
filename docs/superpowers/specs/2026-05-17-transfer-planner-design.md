# Transfer Planner Design

## Problem

The current transfer tips experience does not reliably help users strengthen their team. It presents isolated buy/sell ideas, but the user actually needs actionable upgrade plans that start from the current squad, respect the current budget, and optimize the likely starting eleven for the next 2-3 matchdays.

## Chosen Direction

Replace generic transfer tips with a **Transfer Planner** that generates the **top 3 concrete transfer scenarios** for the selected league.

Each scenario must:

- start from the user's current squad
- consider current league budget
- use currently available market players
- optimize for the next 2-3 matchdays
- end with a positive budget
- improve the expected starting eleven, not just the bench

## Goals

1. Produce actionable transfer plans instead of generic player tips.
2. Rank scenarios by expected improvement of the starting eleven.
3. Keep the output explainable and easy to compare.
4. Avoid weak or forced recommendations when no meaningful upgrade exists.

## Non-Goals

- Optimizing bench depth beyond what is needed for a valid squad structure.
- Producing a long feed of independent player suggestions.
- Letting AI invent scenarios without deterministic calculation underneath.

## User Experience

The Transfers page becomes a planner flow instead of separate buy/sell lists.

Primary interaction:

1. User opens Transfers.
2. User triggers **"Beste Transferplaene berechnen"**.
3. App loads current squad, budget, market players, and short-term fixture context.
4. App returns **3 scenario cards**.

Each scenario card shows:

- scenario label such as upgrade focus, value focus, or risk reduction
- players to sell
- players to buy
- budget before/after
- expected starting-eleven improvement
- short explanation of why the plan is strong

Expanded scenario details show:

- resulting likely starting eleven
- which current starters are replaced
- why the upgrade helps over the next 2-3 matchdays
- warnings for uncertainty such as lineup risk or market dependency

## Core Planning Logic

The planner works in four stages.

### 1. Evaluate the current state

- derive the most likely current starting eleven
- identify weak starting slots based on projected short-term value
- factor in form, fixture quality, and availability risk

### 2. Filter market targets

- only consider players currently available on the market
- prioritize players with meaningful short-term upside
- respect budget and positional needs from the start

### 3. Build transfer chains

- allow multi-step plans with multiple buys and sells
- support patterns such as:
  - 2 sells -> 1 premium upgrade
  - 1 sell -> 2 solid starters
  - targeted replacement of weak starting slots
- reject chains that are not budget-positive or do not lead to a coherent final lineup

### 4. Rank scenarios

Primary ranking signal:

- projected improvement of the starting eleven across the next 2-3 matchdays

Secondary tie-breakers:

- execution risk
- remaining budget
- short-term value stability

Bench impact is not an optimization target except where needed for legality or lineup coherence.

## Technical Design

Use a deterministic planner first, then generate explanations for the resulting scenarios.

### Data inputs

- current squad via existing team providers
- current budget via existing budget providers
- available market players via the existing market provider
- short-term matchday and lineup context via existing matchday, lineup, and Ligainsider data

### New planner responsibility

A dedicated planner component should:

1. derive the user's current likely starting eleven
2. identify upgrade opportunities in the starting eleven
3. generate valid buy/sell chains
4. score and rank the best 3 scenarios
5. generate concise scenario explanations after ranking is complete

### Design principle

**Deterministic calculation first, AI explanation second.**

This keeps the feature reliable, testable, and explainable, and prevents the UI from feeling like arbitrary AI output.

## Failure Handling

- If market data is unavailable, show a clear loading/error state instead of empty recommendation text.
- If no meaningful upgrade plan exists, explicitly say that no real strengthening plan was found.
- If a scenario requires a major teardown to become affordable, label it as high intervention.
- If uncertainty is high due to lineup or availability risk, surface that warning in the scenario details.

## Testing and Acceptance

Implementation should focus tests on planner correctness rather than presentation detail.

Key checks:

1. generated scenarios are actually executable
2. final budget is positive after the full chain
3. resulting lineup is positionally coherent
4. top-3 ranking prefers real starting-eleven improvement
5. fallback states are explicit when data is missing or no useful upgrade exists

## Acceptance Summary

The feature is successful when it helps the user answer one concrete question:

**"Given my squad, my budget, and the current market, what are the best realistic transfer plans to make my starting eleven stronger for the next 2-3 matchdays while staying in the plus?"**
