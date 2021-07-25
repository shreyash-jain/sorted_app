import 'dart:convert';

import 'package:equatable/equatable.dart';

class UnsplashImage extends Equatable {
  final String imageUrl;
  final String imageUrlThumb;
  final String profileLink;
  final String firstName;
  final String lastName;
  final String downloadLink;
  UnsplashImage({
    this.imageUrl = '',
    this.imageUrlThumb = '',
    this.profileLink = '',
    this.firstName = '',
    this.lastName = '',
    this.downloadLink = '',
  });

  UnsplashImage copyWith({
    String imageUrl,
    String imageUrlThumb,
    String profileLink,
    String firstName,
    String lastName,
    String downloadLink,
  }) {
    return UnsplashImage(
      imageUrl: imageUrl ?? this.imageUrl,
      imageUrlThumb: imageUrlThumb ?? this.imageUrlThumb,
      profileLink: profileLink ?? this.profileLink,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      downloadLink: downloadLink ?? this.downloadLink,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'imageUrl': imageUrl,
      'imageUrlThumb': imageUrlThumb,
      'profileLink': profileLink,
      'firstName': firstName,
      'lastName': lastName,
      'downloadLink': downloadLink,
    };
  }

  factory UnsplashImage.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UnsplashImage(
      imageUrl: map['imageUrl'],
      imageUrlThumb: map['imageUrlThumb'],
      profileLink: map['profileLink'],
      firstName: map['firstName'],
      lastName: map['lastName'],
      downloadLink: map['downloadLink'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UnsplashImage.fromJson(Map<String, dynamic> map) => UnsplashImage(
        imageUrl: map['urls']['regular'],
        imageUrlThumb: map['urls']['thumb'],
        profileLink: map['user']['links']['html'],
        firstName: map['user']['name'],
        lastName: map['user']['last_name'],
        downloadLink: map['links']['download'],
      );

  @override
  bool get stringify => true;

  @override
  List<Object> get props {
    return [
      imageUrl,
      imageUrlThumb,
      profileLink,
      firstName,
      lastName,
      downloadLink,
    ];
  }
}
