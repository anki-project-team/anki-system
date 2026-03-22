# FSRS Algorithm (Modern Spaced Repetition)

Each card has:

- Stability (S): how long the memory lasts
- Difficulty (D): how hard the card is
- Retrievability (R): probability of recall

## Process

1. User reviews a card
2. System estimates retrievability (R)
3. Based on response, update S and D

## User Ratings

### Again (fail)
- Stability decreases
- Difficulty increases

### Good
- Stability increases
- Difficulty slightly adjusts

### Easy
- Stability increases significantly
- Difficulty decreases

## Scheduling

Next interval is calculated based on:

interval = S * log(target_retrievability)

Typical target:
- R ≈ 0.9 (90% recall probability)

## Goal

Optimize:
- minimal reviews
- maximal retention
