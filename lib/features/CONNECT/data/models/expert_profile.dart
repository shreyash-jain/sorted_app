import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';


//!Warning: Change SQL table and fromSnapshot on Model change 

class ExpertProfileModel extends Equatable {
  final String id;
  final String name;

  final String googleImage;
  final String profileUrl;
  final String description;
  final String coverImage;
  final int mobileNumber;
  final int experience;
  final String city;
  final int isAccountAdded;
  final String specialities;
  final String instagramLink;
  final int profileCompletionState;
  final String facebookLink;
  final String youtubeLink;
  final int videosAdded;
  final String linkedWebsite;
  final int isMale;
  final String email;
  final String instituteName;
  final String instituteLogoUrl;
  final String services;
  final String roles;
  final int language;
  final String instititeId;
  final String otherWebsite;
  final String userName;

  ExpertProfileModel({
    this.id = '',
    this.name = '',
    this.googleImage = '',
    this.profileUrl = '',
    this.description = '',
    this.coverImage = '',
    this.mobileNumber = 0,
    this.experience = 0,
    this.city = '',
    this.isAccountAdded,
    this.specialities,
    this.instagramLink = '',
    this.profileCompletionState = 0,
    this.facebookLink = '',
    this.youtubeLink = '',
    this.videosAdded,
    this.linkedWebsite,
    this.isMale = 0,
    this.email = '',
    this.instituteName = '',
    this.instituteLogoUrl = '',
    this.services = '',
    this.roles = '',
    this.language = 0,
    this.instititeId = '',
    this.otherWebsite = '',
    this.userName = '',
  });

  ExpertProfileModel copyWith({
    String id,
    String name,
    String googleImage,
    String profileUrl,
    String description,
    String coverImage,
    int mobileNumber,
    int experience,
    String city,
    int isAccountAdded,
    String specialities,
    String instagramLink,
    int profileCompletionState,
    String facebookLink,
    String youtubeLink,
    int videosAdded,
    int linkedWebsite,
    int isMale,
    String email,
    String instituteName,
    String instituteLogoUrl,
    String services,
    String roles,
    int language,
    String instititeId,
    String otherWebsite,
    String userName,
  }) {
    return ExpertProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      googleImage: googleImage ?? this.googleImage,
      profileUrl: profileUrl ?? this.profileUrl,
      description: description ?? this.description,
      coverImage: coverImage ?? this.coverImage,
      mobileNumber: mobileNumber ?? this.mobileNumber,
      experience: experience ?? this.experience,
      city: city ?? this.city,
      isAccountAdded: isAccountAdded ?? this.isAccountAdded,
      specialities: specialities ?? this.specialities,
      instagramLink: instagramLink ?? this.instagramLink,
      profileCompletionState:
          profileCompletionState ?? this.profileCompletionState,
      facebookLink: facebookLink ?? this.facebookLink,
      youtubeLink: youtubeLink ?? this.youtubeLink,
      videosAdded: videosAdded ?? this.videosAdded,
      linkedWebsite: linkedWebsite ?? this.linkedWebsite,
      isMale: isMale ?? this.isMale,
      email: email ?? this.email,
      instituteName: instituteName ?? this.instituteName,
      instituteLogoUrl: instituteLogoUrl ?? this.instituteLogoUrl,
      services: services ?? this.services,
      roles: roles ?? this.roles,
      language: language ?? this.language,
      instititeId: instititeId ?? this.instititeId,
      otherWebsite: otherWebsite ?? this.otherWebsite,
      userName: userName ?? this.userName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'googleImage': googleImage,
      'profileUrl': profileUrl,
      'description': description,
      'coverImage': coverImage,
      'mobileNumber': mobileNumber,
      'experience': experience,
      'city': city,
      'isAccountAdded': isAccountAdded,
      'specialities': specialities,
      'instagramLink': instagramLink,
      'profileCompletionState': profileCompletionState,
      'facebookLink': facebookLink,
      'youtubeLink': youtubeLink,
      'videosAdded': videosAdded,
      'linkedWebsite': linkedWebsite,
      'isMale': isMale,
      'email': email,
      'instituteName': instituteName,
      'instituteLogoUrl': instituteLogoUrl,
      'services': services,
      'roles': roles,
      'language': language,
      'instititeId': instititeId,
      'otherWebsite': otherWebsite,
      'userName': userName,
    };
  }

  factory ExpertProfileModel.fromMap(Map<String, dynamic> map) {
    return ExpertProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      googleImage: map['googleImage'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      description: map['description'] ?? '',
      coverImage: map['coverImage'] ?? '',
      mobileNumber: map['mobileNumber'] ?? 0,
      experience: map['experience'] ?? 0,
      city: map['city'] ?? '',
      isAccountAdded: map['isAccountAdded'] ?? 0,
      specialities: map['specialities'] ?? '',
      instagramLink: map['instagramLink'] ?? '',
      profileCompletionState: map['profileCompletionState'] ?? 0,
      facebookLink: map['facebookLink'] ?? '',
      youtubeLink: map['youtubeLink'] ?? '',
      videosAdded: map['videosAdded'] ?? 0,
      linkedWebsite: map['linkedWebsite'] ?? '',
      isMale: map['isMale'] ?? 0,
      email: map['email'] ?? '',
      instituteName: map['instituteName'] ?? '',
      instituteLogoUrl: map['instituteLogoUrl'] ?? '',
      services: map['services'] ?? '',
      roles: map['roles'] ?? '',
      language: map['language'] ?? 0,
      instititeId: map['instititeId'] ?? '',
      otherWebsite: map['otherWebsite'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

    factory ExpertProfileModel.fromgoogleSignin(User user) {
    return ExpertProfileModel(
      id: user.uid,
      name:user.displayName,
      googleImage: user.photoURL,
      profileUrl:  '',
      description:  '',
      coverImage: '',
      mobileNumber: 0,
      experience:  0,
      city: '',
      isAccountAdded:  0,
      specialities:  '',
      instagramLink: '',
      profileCompletionState:  0,
      facebookLink: '',
      youtubeLink:  '',
      videosAdded: 0,
      linkedWebsite:'',
      isMale:  0,
      email:  '',
      instituteName: '',
      instituteLogoUrl:'',
      services: '',
      roles:  '',
      language:  0,
      instititeId: '',
      otherWebsite:  '',
      userName:  '',
    );
  }

  factory ExpertProfileModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    return ExpertProfileModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      googleImage: map['googleImage'] ?? '',
      profileUrl: map['profileUrl'] ?? '',
      description: map['description'] ?? '',
      coverImage: map['coverImage'] ?? '',
      mobileNumber: map['mobileNumber'] ?? 0,
      experience: map['experience'] ?? 0,
      city: map['city'] ?? '',
      isAccountAdded: map['isAccountAdded'] ?? 0,
      specialities: map['specialities'] ?? '',
      instagramLink: map['instagramLink'] ?? '',
      profileCompletionState: map['profileCompletionState'] ?? 0,
      facebookLink: map['facebookLink'] ?? '',
      youtubeLink: map['youtubeLink'] ?? '',
      videosAdded: map['videosAdded'] ?? 0,
      linkedWebsite: map['linkedWebsite'] ?? '',
      isMale: map['isMale'] ?? 0,
      email: map['email'] ?? '',
      instituteName: map['instituteName'] ?? '',
      instituteLogoUrl: map['instituteLogoUrl'] ?? '',
      services: map['services'] ?? '',
      roles: map['roles'] ?? '',
      language: map['language'] ?? 0,
      instititeId: map['instititeId'] ?? '',
      otherWebsite: map['otherWebsite'] ?? '',
      userName: map['userName'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertProfileModel.fromJson(String source) =>
      ExpertProfileModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      id,
      name,
      googleImage,
      profileUrl,
      description,
      coverImage,
      mobileNumber,
      experience,
      city,
      isAccountAdded,
      specialities,
      instagramLink,
      profileCompletionState,
      facebookLink,
      youtubeLink,
      videosAdded,
      linkedWebsite,
      isMale,
      email,
      instituteName,
      instituteLogoUrl,
      services,
      roles,
      language,
      instititeId,
      otherWebsite,
      userName,
    ];
  }
}
