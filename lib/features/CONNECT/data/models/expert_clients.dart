import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';

class ExpertClientsModel extends Equatable {
  final List<ClassClientLink> requestedClients;
  final List<ClassClientLink> acceptedClients;
  final List<ClientInstance> requestedConsultations;
  final List<ClientInstance> acceptedConsultations;
  ExpertClientsModel({
    this.requestedClients = const [],
    this.acceptedClients = const [],
    this.requestedConsultations = const [],
    this.acceptedConsultations = const [],
  });

  ExpertClientsModel copyWith({
    List<ClassClientLink> requestedClients,
    List<ClassClientLink> acceptedClients,
    List<ClientInstance> requestedConsultations,
    List<ClientInstance> acceptedConsultations,
  }) {
    return ExpertClientsModel(
      requestedClients: requestedClients ?? this.requestedClients,
      acceptedClients: acceptedClients ?? this.acceptedClients,
      requestedConsultations:
          requestedConsultations ?? this.requestedConsultations,
      acceptedConsultations:
          acceptedConsultations ?? this.acceptedConsultations,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'requestedClients': requestedClients?.map((x) => x.toMap())?.toList(),
      'acceptedClients': acceptedClients?.map((x) => x.toMap())?.toList(),
      'requestedConsultations':
          requestedConsultations?.map((x) => x.toMap())?.toList(),
      'acceptedConsultations':
          acceptedConsultations?.map((x) => x.toMap())?.toList(),
    };
  }

  factory ExpertClientsModel.fromMap(Map<String, dynamic> map) {
    return ExpertClientsModel(
      requestedClients: List<ClassClientLink>.from(map['requestedClients']
              ?.map((x) => ClassClientLink.fromMap(x) ?? ClassClientLink()) ??
          const []),
      acceptedClients: List<ClassClientLink>.from(map['acceptedClients']
              ?.map((x) => ClassClientLink.fromMap(x) ?? ClassClientLink()) ??
          const []),
      requestedConsultations: List<ClientInstance>.from(
          map['requestedConsultations']
                  ?.map((x) => ClientInstance.fromMap(x) ?? ClientInstance()) ??
              const []),
      acceptedConsultations: List<ClientInstance>.from(
          map['acceptedConsultations']
                  ?.map((x) => ClientInstance.fromMap(x) ?? ClientInstance()) ??
              const []),
    );
  }

  factory ExpertClientsModel.fromSnapshot(DocumentSnapshot snap) {
    var map = snap.data() as Map;
    print("t here 0 fromSnapshot"); 
    return ExpertClientsModel(
      requestedClients:
          List<ClassClientLink>.from(map['requestedClients'].map((i) {
                var z = Map<String, dynamic>.from(i);
                print("t here fromSnapshot $z");

                return ClassClientLink.fromMap(z) ?? ClientInstance();
              }) ??
              const []),
      acceptedClients:
          List<ClassClientLink>.from(map['acceptedClients'].map((i) {
                var z = Map<String, dynamic>.from(i);
                print("t here 1 fromSnapshot $z");

                return ClassClientLink.fromMap(z) ?? ClientInstance();
              }) ??
              const []),
      requestedConsultations:
          List<ClientInstance>.from(map['requestedConsultations'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return ClientInstance.fromMap(z) ?? ClientInstance();
              }) ??
              const []),
      acceptedConsultations:
          List<ClientInstance>.from(map['acceptedConsultations'].map((i) {
                var z = Map<String, dynamic>.from(i);

                return ClientInstance.fromMap(z) ?? ClientInstance();
              }) ??
              const []),
    );
  }

  String toJson() => json.encode(toMap());

  factory ExpertClientsModel.fromJson(String source) =>
      ExpertClientsModel.fromMap(json.decode(source));

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        requestedClients,
        acceptedClients,
        requestedConsultations,
        acceptedConsultations
      ];
}
