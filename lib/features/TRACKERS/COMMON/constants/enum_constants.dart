enum PropertyType {
  text,
  number,
  elist, // EXPANDABLE LIST
  rlist, // RIGID LIST
  erlist, // EXPANDABLE RICH LIST
  duration,
  level,
  rating,
  image
}

enum TrackDuration {
  seven,
  twentyone,
  fortyfive,
  ninty,
}

extension DurationDescription on TrackDuration {
  String get description {
    switch (this) {
      case TrackDuration.seven:
        return '7 day';
      case TrackDuration.twentyone:
        return '21 days';
      case TrackDuration.fortyfive:
        return '30 days';
      case TrackDuration.ninty:
        return '3 months';
      default:
        return '21 days';
    }
  }
}

extension DurationIcon on TrackDuration {
  String get description {
    switch (this) {
      case TrackDuration.seven:
        return 'assets/images/iconseven';
      case TrackDuration.twentyone:
        return 'assets/images/iconseven';
      case TrackDuration.fortyfive:
        return 'assets/images/iconseven';
      case TrackDuration.ninty:
        return 'assets/images/iconseven';
      default:
        return 'assets/images/iconseven';
    }
  }
}

enum TrackReminder {
  daily,
  weekly,
  monthly,
}

extension ReminderDescription on TrackReminder {
  String get description {
    switch (this) {
      case TrackReminder.daily:
        return "Set reminder daily";
      case TrackReminder.weekly:
        return 'Set reminder in week';
      case TrackReminder.monthly:
        return 'Set reminder at interval';
      default:
        return 'Set reminder daily at';
    }
  }
}

enum TrackAutoTracking {
  noautofill,
  googlefitactivity,
  googlefitbmr,
  googlefitcalories,
  googlefitmoveminutes,
  googlefitsteps,
  googlefitworkout,
  googlefitbodyfat,
  googlefitheight,
  googlefitweight,
  googlefithydration,
  googlefitnutrition,
  googlefitsleep,
  googlefitheartrate,
  googlefitglucose,
  googlefitmenstruation,
  googlefitovulation_test,
  googlefitoxygen,
  androidusage,
  androidnotifications,
}

extension TrackAutoTrackingDescription on TrackAutoTracking {
  String get description {
    switch (this) {
      case TrackAutoTracking.noautofill:
        return 'This track does not have Auto-fill';
      case TrackAutoTracking.androidusage:
        return 'Use Android data data to auto fill';
      case TrackAutoTracking.androidnotifications:
        return 'Use Android data data to auto fill';
      default:
        return "Use Google Fit data to auto fill";
    }
  }
}
