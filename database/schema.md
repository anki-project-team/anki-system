# Database Schema

## Users
- user_id (Primary Key)
- name
- email

## Cards
- card_id (Primary Key)
- front (question)
- back (answer)
- user_id (Foreign Key)

## Reviews
- review_id (Primary Key)
- card_id (Foreign Key)
- user_id (Foreign Key)
- interval (days)
- ease_factor
- next_review_date
