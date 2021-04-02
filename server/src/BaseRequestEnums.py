from enum import Enum


class RequestType(Enum):
    hour = 1
    level = 2
    rating = 3
    write_answer = 4
    mcq = 5
    prediction_expense = 6
    prediction_hour = 7
    prediction_choice = 8
    prediction_rating = 9
    plot_activity = 10
    prediction_activity = 11
    plot_life = 12
    prediction_life = 13
    streak_mcq = 14
    streak_hours = 15
    streak_diary = 16

class PeriodcityType(Enum):
    daily=0
    weekly=1
    monthly=2
