import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';

class ClassMembersModel extends Equatable {
  List<ClientInstance> enrolledMembers;
  List<ClientInstance> requestedMembers;
  ClassMembersModel({
    this.enrolledMembers = const [],
    this.requestedMembers = const [],
  });

  ClassMembersModel copyWith({
    List<ClientInstance> enrolledMembers,
    List<ClientInstance> requestedMembers,
  }) {
    return ClassMembersModel(
      enrolledMembers: enrolledMembers ?? this.enrolledMembers,
      requestedMembers: requestedMembers ?? this.requestedMembers,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'enrolledMembers': enrolledMembers?.map((x) => x.toMap())?.toList(),
      'requestedMembers': requestedMembers?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ClassMembersModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;

    var requestedMembers =
        List<ClientInstance>.from(map['requestedMembers'].map((i) {
              var z = Map<String, dynamic>.from(i);
              print("ClassMembersModel.fromSnapshot");
              print(z);

              return ClientInstance.fromMap(z) ?? ClientInstance();
            }) ??
            const []);
    var acceptedMembers =
        List<ClientInstance>.from(map['enrolledMembers']?.map((i) {
              var z = Map<String, dynamic>.from(i);

              return ClientInstance.fromMap(z) ?? ClientInstance();
            }) ??
            const []);
    return ClassMembersModel(
      enrolledMembers: acceptedMembers,
      requestedMembers: requestedMembers,
    );
  }

  String toJson() => json.encode(toMap());

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [enrolledMembers, requestedMembers];
}
