import 'dart:convert';

import 'package:equatable/equatable.dart';

class ExpertCalendarModel extends Equatable {
  List<int> monTimings;
  List<int> tueTimings;
  List<int> wedTimings;
  List<int> thuTimings;
  List<int> friTimings;
  List<int> satTimings;
  List<int> sunTimings;
  int isSet;
  List<String> monEndDates;
  List<int> monEndDatesSlots;
  List<String> tueEndDates;
  List<int> tueEndDatesSlots;
  List<String> wedEndDates;
  List<int> wedEndDatesSlots;
  List<String> thuEndDates;
  List<int> thuEndDatesSlots;
  List<String> friEndDates;
  List<int> friEndDatesSlots;
  List<String> satEndDates;
  List<int> satEndDatesSlots;
  List<String> sunEndDates;
  List<int> sunEndDatesSlots;

  ExpertCalendarModel({
    this.monTimings = const [],
    this.tueTimings = const [],
    this.wedTimings = const [],
    this.thuTimings = const [],
    this.friTimings = const [],
    this.satTimings = const [],
    this.sunTimings = const [],
    this.isSet = 0,
    this.monEndDates = const [],
    this.monEndDatesSlots = const [],
    this.tueEndDates = const [],
    this.tueEndDatesSlots = const [],
    this.wedEndDates = const [],
    this.wedEndDatesSlots = const [],
    this.thuEndDates = const [],
    this.thuEndDatesSlots = const [],
    this.friEndDates = const [],
    this.friEndDatesSlots = const [],
    this.satEndDates = const [],
    this.satEndDatesSlots = const [],
    this.sunEndDates = const [],
    this.sunEndDatesSlots = const [],
  });

  ExpertCalendarModel copyWith(
      {List<int> monTimings,
      List<int> tueTimings,
      List<int> wedTimings,
      List<int> thuTimings,
      List<int> friTimings,
      List<int> satTimings,
      List<int> sunTimings,
      List<String> monEndDates,
      List<int> monEndDatesSlots,
      List<String> tueEndDates,
      List<int> tueEndDatesSlots,
      List<String> wedEndDates,
      List<int> wedEndDatesSlots,
      List<String> thuEndDates,
      List<int> thuEndDatesSlots,
      List<String> friEndDates,
      List<int> friEndDatesSlots,
      List<String> satEndDates,
      List<int> satEndDatesSlots,
      List<String> sunEndDates,
      List<int> sunEndDatesSlots,
      int isSet}) {
    return ExpertCalendarModel(
      monTimings: monTimings ?? this.monTimings,
      tueTimings: tueTimings ?? this.tueTimings,
      wedTimings: wedTimings ?? this.wedTimings,
      thuTimings: thuTimings ?? this.thuTimings,
      friTimings: friTimings ?? this.friTimings,
      satTimings: satTimings ?? this.satTimings,
      sunTimings: sunTimings ?? this.sunTimings,
      monEndDates: monEndDates ?? this.monEndDates,
      monEndDatesSlots: monEndDatesSlots ?? this.monEndDatesSlots,
      tueEndDates: tueEndDates ?? this.tueEndDates,
      tueEndDatesSlots: tueEndDatesSlots ?? this.tueEndDatesSlots,
      wedEndDates: wedEndDates ?? this.wedEndDates,
      wedEndDatesSlots: wedEndDatesSlots ?? this.wedEndDatesSlots,
      thuEndDates: thuEndDates ?? this.thuEndDates,
      thuEndDatesSlots: thuEndDatesSlots ?? this.thuEndDatesSlots,
      friEndDates: friEndDates ?? this.friEndDates,
      friEndDatesSlots: friEndDatesSlots ?? this.friEndDatesSlots,
      satEndDates: satEndDates ?? this.satEndDates,
      satEndDatesSlots: satEndDatesSlots ?? this.satEndDatesSlots,
      sunEndDates: sunEndDates ?? this.sunEndDates,
      sunEndDatesSlots: sunEndDatesSlots ?? this.sunEndDatesSlots,
      isSet: isSet ?? this.isSet,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'monTimings': monTimings,
      'tueTimings': tueTimings,
      'wedTimings': wedTimings,
      'thuTimings': thuTimings,
      'friTimings': friTimings,
      'satTimings': satTimings,
      'sunTimings': sunTimings,
      'isSet': isSet,
      'monEndDates': monEndDates,
      'monEndDatesSlots': monEndDatesSlots,
      'tueEndDates': tueEndDates,
      'tueEndDatesSlots': tueEndDatesSlots,
      'wedEndDates': wedEndDates,
      'wedEndDatesSlots': wedEndDatesSlots,
      'thuEndDates': thuEndDates,
      'thuEndDatesSlots': thuEndDatesSlots,
      'friEndDates': friEndDates,
      'friEndDatesSlots': friEndDatesSlots,
      'satEndDates': satEndDates,
      'satEndDatesSlots': satEndDatesSlots,
      'sunEndDates': sunEndDates,
      'sunEndDatesSlots': sunEndDatesSlots,
    };
  }

  factory ExpertCalendarModel.fromMap(Map<String, dynamic> map) {
    return ExpertCalendarModel(
      monTimings: List<int>.from(map['monTimings'] ?? const []),
      tueTimings: List<int>.from(map['tueTimings'] ?? const []),
      wedTimings: List<int>.from(map['wedTimings'] ?? const []),
      thuTimings: List<int>.from(map['thuTimings'] ?? const []),
      friTimings: List<int>.from(map['friTimings'] ?? const []),
      satTimings: List<int>.from(map['satTimings'] ?? const []),
      sunTimings: List<int>.from(map['sunTimings'] ?? const []),
      isSet: map['isSet'] ?? 0,
      monEndDates: List<String>.from(map['monEndDates'] ?? const []),
      monEndDatesSlots: List<int>.from(map['monEndDatesSlots'] ?? const []),
      tueEndDates: List<String>.from(map['tueEndDates'] ?? const []),
      tueEndDatesSlots: List<int>.from(map['tueEndDatesSlots'] ?? const []),
      wedEndDates: List<String>.from(map['wedEndDates'] ?? const []),
      wedEndDatesSlots: List<int>.from(map['wedEndDatesSlots'] ?? const []),
      thuEndDates: List<String>.from(map['thuEndDates'] ?? const []),
      thuEndDatesSlots: List<int>.from(map['thuEndDatesSlots'] ?? const []),
      friEndDates: List<String>.from(map['friEndDates'] ?? const []),
      friEndDatesSlots: List<int>.from(map['friEndDatesSlots'] ?? const []),
      satEndDates: List<String>.from(map['satEndDates'] ?? const []),
      satEndDatesSlots: List<int>.from(map['satEndDatesSlots'] ?? const []),
      sunEndDates: List<String>.from(map['sunEndDates'] ?? const []),
      sunEndDatesSlots: List<int>.from(map['sunEndDatesSlots'] ?? const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertCalendarModel.fromJson(String source) =>
      ExpertCalendarModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      monTimings,
      tueTimings,
      wedTimings,
      thuTimings,
      friTimings,
      satTimings,
      sunTimings,
      isSet,
      monEndDates,
      monEndDatesSlots,
      tueEndDates,
      tueEndDatesSlots,
      wedEndDates,
      wedEndDatesSlots,
      thuEndDates,
      thuEndDatesSlots,
      friEndDates,
      friEndDatesSlots,
      satEndDates,
      satEndDatesSlots,
      sunEndDates,
      sunEndDatesSlots,
    ];
  }
}
