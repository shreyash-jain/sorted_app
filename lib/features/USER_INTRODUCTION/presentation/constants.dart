import 'package:flutter/material.dart';

class UserIntroStrings {
  static const String oldGreeting = "Welcome back";
  static const String newGreeting = "Welcome";
  static const String oldActionDownloading = "Syncing";
  static const String newActionDownloading = "Setting Up";
  static const String backgroundPath = "assets/images/sortedIntro.png";
  static const String downloadingPath = "assets/images/downloading.gif";
  static const String oldDownloadText =
      "Looks like we have your previous data saved in our cloud, So lets bring it back to you";
  static const String newDownloadText = "Setting up your data !";
  static const String waitingText =
      "\n\nThis might take few minutes, Please do not close me";
  static const List<String> elements = [
    "FILES",
    "EVENTS",
    "TRACKERS",
    "EXPENSES",
    "NOTEBOOKS",
    "ACTIVITIES"
  ];
  static const String notificationHeading = 'Get reminded to stay up-to-date';
  static const String notificationDescription =
      "We need your regular data\nto help you track, analyse and organize your life." +
          "\nTo make this process easier we smarty set a small daily survey to know about your life";
  static const String notificationImagePath = "assets/images/reminder.png";
  static const userImageTag = 'profileImage';
  static const askProfesssion = 'and what are you doing nowadays ?';
  static const studentImagePath = "assets/images/student.png";
  static const studentImageDescription = "Studying";
  static const workingImagePath = "assets/images/working.png";
  static const workingImageDescription = "Working";
  static const bothProfessionImagePath = "assets/images/bothProfession.png";
  static const bothProfessionImageDescription = "Both";
}
