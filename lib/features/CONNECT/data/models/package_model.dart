import 'dart:convert';

import 'package:equatable/equatable.dart';

//! same at pro

/// type ->
/// 0-> one time
/// 1-> one week
/// 2-> one month
/// 3-> three months
///
///
/// category ->
///  0-> yoga
/// 1-> fitness
/// 2-> nutrition
class ConsultationPackageModel extends Equatable {
  String id;
  String name;
  List<int> days;
  int type;
  int category;
  int perSessionPrice;
  int numClients;
  String imageUrl;
  String coachId;
  String coachName;
  String topics;
  String dynamicLink;
  String description;
  int feeType;
  int monthlyFee;
  int discountPercentage;
  int isAtHome;
  int isOnline;
  int isAtInstitute;
  int hasDemoSession;
  int coupleDiscount;
  int tripleDiscount;
  ConsultationPackageModel({
    this.id = '',
    this.name = '',
    this.days = const [],
    this.type = 0,
    this.category = 0,
    this.perSessionPrice = 0,
    this.numClients = 0,
    this.imageUrl = '',
    this.coachId = '',
    this.coachName = '',
    this.topics = '',
    this.dynamicLink = '',
    this.description = '',
    this.feeType = 0,
    this.monthlyFee = 0,
    this.discountPercentage = 0,
    this.isAtHome = 0,
    this.isOnline = 0,
    this.isAtInstitute = 0,
    this.hasDemoSession = 0,
    this.coupleDiscount = 0,
    this.tripleDiscount = 0,
  });

  ConsultationPackageModel copyWith({
    String id,
    String name,
    List<int> days,
    int type,
    int category,
    int perSessionPrice,
    int numClients,
    String imageUrl,
    String coachId,
    String coachName,
    String topics,
    String dynamicLink,
    String description,
    int feeType,
    int monthlyFee,
    int discountPercentage,
    int isAtHome,
    int isOnline,
    int isAtInstitute,
    int hasDemoSession,
    int coupleDiscount,
    int tripleDiscount,
  }) {
    return ConsultationPackageModel(
      id: id ?? this.id,
      name: name ?? this.name,
      days: days ?? this.days,
      type: type ?? this.type,
      category: category ?? this.category,
      perSessionPrice: perSessionPrice ?? this.perSessionPrice,
      numClients: numClients ?? this.numClients,
      imageUrl: imageUrl ?? this.imageUrl,
      coachId: coachId ?? this.coachId,
      coachName: coachName ?? this.coachName,
      topics: topics ?? this.topics,
      dynamicLink: dynamicLink ?? this.dynamicLink,
      description: description ?? this.description,
      feeType: feeType ?? this.feeType,
      monthlyFee: monthlyFee ?? this.monthlyFee,
      discountPercentage: discountPercentage ?? this.discountPercentage,
      isAtHome: isAtHome ?? this.isAtHome,
      isOnline: isOnline ?? this.isOnline,
      isAtInstitute: isAtInstitute ?? this.isAtInstitute,
      hasDemoSession: hasDemoSession ?? this.hasDemoSession,
      coupleDiscount: coupleDiscount ?? this.coupleDiscount,
      tripleDiscount: tripleDiscount ?? this.tripleDiscount,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'days': days,
      'type': type,
      'category': category,
      'perSessionPrice': perSessionPrice,
      'numClients': numClients,
      'imageUrl': imageUrl,
      'coachId': coachId,
      'coachName': coachName,
      'topics': topics,
      'dynamicLink': dynamicLink,
      'description': description,
      'feeType': feeType,
      'monthlyFee': monthlyFee,
      'discountPercentage': discountPercentage,
      'isAtHome': isAtHome,
      'isOnline': isOnline,
      'isAtInstitute': isAtInstitute,
      'hasDemoSession': hasDemoSession,
      'coupleDiscount': coupleDiscount,
      'tripleDiscount': tripleDiscount,
    };
  }

  factory ConsultationPackageModel.fromMap(Map<String, dynamic> map) {
    return ConsultationPackageModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      days: List<int>.from(map['days'] ?? const []),
      type: map['type'] ?? 0,
      category: map['category'] ?? 0,
      perSessionPrice: map['perSessionPrice'] ?? 0,
      numClients: map['numClients'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      coachId: map['coachId'] ?? '',
      coachName: map['coachName'] ?? '',
      topics: map['topics'] ?? '',
      dynamicLink: map['dynamicLink'] ?? '',
      description: map['description'] ?? '',
      feeType: map['feeType'] ?? 0,
      monthlyFee: map['monthlyFee'] ?? 0,
      discountPercentage: map['discountPercentage'] ?? 0,
      isAtHome: map['isAtHome'] ?? 0,
      isOnline: map['isOnline'] ?? 0,
      isAtInstitute: map['isAtInstitute'] ?? 0,
      hasDemoSession: map['hasDemoSession'] ?? 0,
      coupleDiscount: map['coupleDiscount'] ?? 0,
      tripleDiscount: map['tripleDiscount'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ConsultationPackageModel.fromJson(String source) =>
      ConsultationPackageModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      days,
      type,
      category,
      perSessionPrice,
      numClients,
      imageUrl,
      coachId,
      coachName,
      topics,
      dynamicLink,
      description,
      feeType,
      monthlyFee,
      discountPercentage,
      isAtHome,
      isOnline,
      isAtInstitute,
      hasDemoSession,
      coupleDiscount,
      tripleDiscount,
    ];
  }
}
