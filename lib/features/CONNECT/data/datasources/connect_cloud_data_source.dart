import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';

abstract class ConnectCloud {
  Future<ClassModel> getClass(String id);
  Future<ExpertProfileModel> getExpertProfile(String id);

  Future<ClientEnrollsModel> getEnrollsOfClient();

  Future<int> enrollClass(ClassInstanceModel classroom, ClassClientLink link,
      String expertId, ClientInstance client);
}

class ConnectCloudDataSourceImpl implements ConnectCloud {
  final FirebaseAuth auth;

  final FirebaseFirestore cloudDb;
  final SqlDatabaseService nativeDb;
  ConnectCloudDataSourceImpl({this.cloudDb, this.auth, this.nativeDb});

  @override
  Future<List<ClientInstance>> getClassRequestedClients(int classId) {
    // TODO: implement getClassRequestedClients
    throw UnimplementedError();
  }

  @override
  Future<ClassModel> getClass(String id) async {
    var snapShot = await cloudDb.collection('classrooms').doc(id).get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ClassModel(id: ""));
    if (snapShot != null) {
      return ClassModel.fromSnapshot(snapShot);
    }
    return Future.value(ClassModel(id: ""));
  }

  @override
  Future<ExpertProfileModel> getExpertProfile(String id) async {
    var snapShot = await cloudDb.collection('experts/data/uid/').doc(id).get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ExpertProfileModel(id: ""));
    if (snapShot != null) {
      return ExpertProfileModel.fromSnapshot(snapShot);
    }
    return Future.value(ExpertProfileModel(id: ""));
  }

  @override
  Future<ClientEnrollsModel> getEnrollsOfClient() async {
    var user = auth.currentUser;
    var snapShot = await cloudDb
        .collection('users/${user.uid}/user_data/data/enrolled')
        .doc('data')
        .get();

    if (snapShot == null || !snapShot.exists)
      return Future.value(ClientEnrollsModel());
    if (snapShot != null) {
      print("at getEnrollsOfClient $snapShot");
      return ClientEnrollsModel.fromSnapshot(snapShot);
    }
    return Future.value(ClientEnrollsModel());
  }

  @override
  Future<ClassMembersModel> getClassMembers(String classId) async {
    var snapShot = await cloudDb
        .collection('classrooms')
        .doc(classId)
        .collection('members')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ClassMembersModel());

    return ClassMembersModel.fromSnapshot(snapShot);
  }

  @override
  Future<int> enrollClass(ClassInstanceModel classroom, ClassClientLink link,
      String expertId, ClientInstance client) async {
    print("t here -1");
    await cloudDb.runTransaction((transaction) async {
      var user = auth.currentUser;
      client = client.copyWith(uid: user.uid);
      link = link.copyWith(clientId: user.uid);

      DocumentReference classMembersRef = cloudDb
          .collection('classrooms')
          .doc(classroom.classId)
          .collection('members')
          .doc('data');
      DocumentReference expertMembersRef = cloudDb
          .collection('experts/data/uid')
          .doc(expertId)
          .collection('members')
          .doc('data');
      DocumentReference clientEnrollsRef = cloudDb
          .collection('users/${user.uid}/user_data/data/enrolled')
          .doc('data');
      print("t here 0");

      DocumentSnapshot classMemberSnap = await transaction.get(classMembersRef);
      DocumentSnapshot expertMembersSnap =
          await transaction.get(expertMembersRef);
      DocumentSnapshot clientEnrollsSnap =
          await transaction.get(clientEnrollsRef);
      print("t here");
      await transaction.set(
          classMembersRef, addClassMemberSnap(classMemberSnap, client));
      print("t here 1");
      await transaction.set(
          expertMembersRef, addTrainerMemberSnap(expertMembersSnap, link));
      print("t here 2");
      await transaction.set(
          clientEnrollsRef, addEnrollsClientSnap(clientEnrollsSnap, classroom));
      return Future.value(1);
    }).catchError((error, stackTrace) {
      return Future.value(0);
    });
    return Future.value(1);
  }

  Map<dynamic, dynamic> addClassMemberSnap(
      DocumentSnapshot snap, ClientInstance client) {
    ClassMembersModel classMembers;
    if (snap == null || !snap.exists) {
      classMembers =
          ClassMembersModel(enrolledMembers: [], requestedMembers: [client]);

      return classMembers.toMap();
    }

    classMembers = ClassMembersModel.fromSnapshot(snap);

    if (((classMembers.requestedMembers.singleWhere(
                (it) => it.uid == client.uid,
                orElse: () => null)) !=
            null) ||
        (classMembers.enrolledMembers.singleWhere((it) => it.uid == client.uid,
                orElse: () => null)) !=
            null) return snap.data();
    classMembers.requestedMembers.add(client);
    return classMembers.toMap();
  }

  Map<dynamic, dynamic> addTrainerMemberSnap(
      DocumentSnapshot snap, ClassClientLink client) {
    ExpertClientsModel expertsMembers;
    if (snap == null || !snap.exists) {
      print("t here 2.5");
      expertsMembers = ExpertClientsModel(requestedClients: [client]);
      print("t here 2.6");

      return expertsMembers.toMap();
    }
    print("t here 2.7");
    expertsMembers = ExpertClientsModel.fromSnapshot(snap);
    print("t here 2.75");
    if (((expertsMembers.requestedClients.singleWhere(
                (it) => (it.clientId == client.clientId &&
                    it.classId == client.classId),
                orElse: () => null)) !=
            null) ||
        (expertsMembers.acceptedClients.singleWhere(
                (it) => (it.clientId == client.clientId &&
                    it.classId == client.classId),
                orElse: () => null)) !=
            null) {
      print("t here 2.756");
      return snap.data();
    }
    print("t here 2.8");
    expertsMembers.requestedClients.add(client);
    print("t here 2.9");
    return expertsMembers.toMap();
  }

  Map<dynamic, dynamic> addEnrollsClientSnap(
      DocumentSnapshot snap, ClassInstanceModel classroom) {
    ClientEnrollsModel clientEnrolls;
    if (snap == null || !snap.exists) {
      clientEnrolls = ClientEnrollsModel(requestedClasses: [classroom]);

      return clientEnrolls.toMap();
    }
    clientEnrolls = ClientEnrollsModel.fromSnapshot(snap);
    if (((clientEnrolls.requestedClasses.singleWhere(
                (it) => it.classId == classroom.classId,
                orElse: () => null)) !=
            null) ||
        (clientEnrolls.enrolledClasses.singleWhere(
                (it) => it.classId == classroom.classId,
                orElse: () => null)) !=
            null) return snap.data();
    clientEnrolls.requestedClasses.add(classroom);
    return clientEnrolls.toMap();
  }
}
