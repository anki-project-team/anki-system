# Spaced Repetition Algorithm (SM-2 simplified)

Each card has:
- interval (days)
- ease_factor (default: 2.5)

User answers:

## Again (wrong)
- interval = 1
- ease_factor = ease_factor - 0.2

## Good
- interval = interval * ease_factor

## Easy
- interval = interval * ease_factor * 1.3
- ease_factor = ease_factor + 0.1

## Next Review
- next_review_date = today + interval
