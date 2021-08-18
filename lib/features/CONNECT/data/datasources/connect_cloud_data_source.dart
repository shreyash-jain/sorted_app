import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sorted/core/global/database/sqflite_init.dart';
import 'package:sorted/features/CONNECT/data/models/chat_message.dart';
import 'package:sorted/features/CONNECT/data/models/class_members.dart';
import 'package:sorted/features/CONNECT/data/models/client_consultation_model.dart';
import 'package:sorted/features/CONNECT/data/models/client_enrolls_model.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_calendar.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_clients.dart';
import 'package:sorted/features/CONNECT/data/models/expert/expert_profile.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_client_link.dart';
import 'package:sorted/features/CONNECT/data/models/instances/class_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/noticeboard_message.dart';
import 'package:sorted/features/CONNECT/data/models/package_model.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_trainer_instance.dart';
import 'package:sorted/features/CONNECT/data/models/instances/consultation_client_instance.dart';
import 'package:sorted/features/CONNECT/data/models/resource_message.dart';
import 'package:sorted/features/CONNECT/domain/entities/chat_message_entity.dart';
import 'package:sorted/features/HOME/data/models/class_model.dart';
import 'package:sorted/features/PLANNER/data/models/activity.dart';
import 'package:sorted/features/PLANNER/data/models/diet_plan.dart';
import 'package:sorted/features/PLANNER/data/models/workout_plan.dart';

abstract class ConnectCloud {
  Future<ClassModel> getClass(String id);
  Future<ExpertProfileModel> getExpertProfile(String id);

  Future<ClientEnrollsModel> getEnrollsOfClient();

  Future<int> enrollClass(ClassInstanceModel classroom, ClassClientLink link,
      String expertId, ClientInstance client);

  Future<int> enrollPackage(
      ClientConsultationModel consultation,
      ConsultationClientInstanceModel clientLink,
      ConsultationTrainerInstanceModel expertLink);

  Future<ExpertCalendarModel> getExpertCalendar(String id);

  Future<List<ConsultationPackageModel>> getExpertPackages(String expertId);

  Future<ConsultationPackageModel> getPackage(String id);
  Future<List<NoticeboardMessage>> getNoticeBoardMessages(ClassModel classroom);
  Future<ChatMessageEntitiy> addChatMessage(
      ChatMessage message, ClassModel classroom);
  Future<List<DietPlanModel>> getClassDietPlans(ClassModel classroom);
  Future<List<ResourceMessage>> getConsultationResourceMessages(
      ClientConsultationModel consultation);
  Future<List<WorkoutPlanModel>> getClasWorkoutPlans(ClassModel classroom);
  Future<List<ChatMessageEntitiy>> getChatMessages(
      ClassModel classroom, ChatMessage startAfterChat, int limit);
  Future<ChatMessageEntitiy> addConsultationChatMessage(
      ChatMessage message, ClientConsultationModel client);

  Future<List<ChatMessageEntitiy>> getConsultationChatMessages(
      ClientConsultationModel client, ChatMessage startAfterChat, int limit);
  Future<List<DietPlanModel>> getConsultationDietPlans(
      ClientConsultationModel consultation);

  Future<List<WorkoutPlanModel>> getConsultationWorkoutPlans(
      ClientConsultationModel consultation);

  Future<ClientConsultationModel> getConsultationById(String id);
  Future<List<ResourceMessage>> getResourceMessages(ClassModel classroom);
  Future<ActivityModel> getActivityById(int activityId);
}

class ConnectCloudDataSourceImpl implements ConnectCloud {
  final FirebaseAuth auth;

  final FirebaseFirestore cloudDb;
  final SqlDatabaseService nativeDb;
  ConnectCloudDataSourceImpl({this.cloudDb, this.auth, this.nativeDb});

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
  Future<List<ResourceMessage>> getConsultationResourceMessages(
      ClientConsultationModel consultation) async {
    var result = await FirebaseFirestore.instance
        .collection('consultations/${consultation.id}/resources')
        .doc('data')
        .get();

    if (result != null && result.exists) {
      return List<ResourceMessage>.from((result.data() as Map)['data'].map((i) {
            var z = Map<String, dynamic>.from(i);
            print("t here fromSnapshot $z");

            return ResourceMessage.fromMap(z) ?? ResourceMessage();
          }) ??
          const []);
    } else
      return [];
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

  @override
  Future<int> enrollPackage(
      ClientConsultationModel consultation,
      ConsultationClientInstanceModel clientLink,
      ConsultationTrainerInstanceModel expertLink) async {
    print("t here -1");

    await cloudDb.runTransaction((transaction) async {
      var user = auth.currentUser;

      DocumentReference newConsultationRef =
          cloudDb.collection('consultations').doc();
      consultation =
          consultation.copyWith(uid: user.uid, id: newConsultationRef.id);
      clientLink = clientLink.copyWith(consultationId: newConsultationRef.id);
      clientLink = clientLink.copyWith(clientId: user.uid);
      expertLink = expertLink.copyWith(consultationId: newConsultationRef.id);

      DocumentReference expertMembersRef = cloudDb
          .collection('experts/data/uid')
          .doc(consultation.coachId)
          .collection('members')
          .doc('data');
      DocumentReference clientEnrollsRef = cloudDb
          .collection('users/${user.uid}/user_data/data/enrolled')
          .doc('data');
      print("t here 0");

      DocumentSnapshot expertMembersSnap =
          await transaction.get(expertMembersRef);
      DocumentSnapshot clientEnrollsSnap =
          await transaction.get(clientEnrollsRef);
      print("t here");
      await transaction.set(newConsultationRef, consultation.toMap());

      print("t here 1");
      await transaction.set(expertMembersRef,
          addConsultationTrainerMemberSnap(expertMembersSnap, clientLink));
      print("t here 2");
      await transaction.set(clientEnrollsRef,
          addConsultationEnrollsClientSnap(clientEnrollsSnap, expertLink));
      return Future.value(1);
    }).catchError((error, stackTrace) {
      return Future.value(0);
    });
    return Future.value(1);
  }

  addConsultationTrainerMemberSnap(DocumentSnapshot<Object> snap,
      ConsultationClientInstanceModel clientLink) {
    ExpertClientsModel expertsMembers;
    if (snap == null || !snap.exists) {
      print("t here 2.5");
      expertsMembers = ExpertClientsModel(requestedConsultations: [clientLink]);
      print("t here 2.6");

      return expertsMembers.toMap();
    }
    print("t here 2.7");
    expertsMembers = ExpertClientsModel.fromSnapshot(snap);
    print("t here 2.75");
    if (((expertsMembers.requestedConsultations.singleWhere(
                (it) => (it.clientId == clientLink.clientId &&
                    it.packageId == clientLink.packageId),
                orElse: () => null)) !=
            null) ||
        (expertsMembers.acceptedConsultations.singleWhere(
                (it) => (it.clientId == clientLink.clientId &&
                    it.packageId == clientLink.packageId),
                orElse: () => null)) !=
            null) {
      print("t here 2.756");
      return snap.data();
    }
    print("t here 2.8");
    expertsMembers.requestedConsultations.add(clientLink);
    print("t here 2.9");
    return expertsMembers.toMap();
  }

  addConsultationEnrollsClientSnap(DocumentSnapshot<Object> snap,
      ConsultationTrainerInstanceModel expertLink) {
    ClientEnrollsModel clientEnrolls;
    if (snap == null || !snap.exists) {
      clientEnrolls = ClientEnrollsModel(requestedConsultation: [expertLink]);

      return clientEnrolls.toMap();
    }
    clientEnrolls = ClientEnrollsModel.fromSnapshot(snap);
    if (((clientEnrolls.requestedConsultation.singleWhere(
                (it) => (it.coachId == expertLink.coachId &&
                    it.packageId == expertLink.coachId),
                orElse: () => null)) !=
            null) ||
        (clientEnrolls.requestedConsultation.singleWhere(
                (it) => (it.coachId == expertLink.coachId &&
                    it.packageId == expertLink.coachId),
                orElse: () => null)) !=
            null) return snap.data();
    clientEnrolls.requestedConsultation.add(expertLink);
    return clientEnrolls.toMap();
  }

  @override
  Future<ExpertCalendarModel> getExpertCalendar(String id) async {
    var snapShot = await cloudDb
        .collection('experts/data/uid')
        .doc(id)
        .collection('workingHours')
        .doc('data')
        .get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ExpertCalendarModel());

    return ExpertCalendarModel.fromMap(snapShot.data() as Map);
  }

  @override
  Future<List<ConsultationPackageModel>> getExpertPackages(
      String expertId) async {
    var snapShot = await cloudDb
        .collection('packages')
        .where('coachId', isEqualTo: expertId)
        .get();
    if (snapShot != null && snapShot.docs.length > 0)
      return snapShot.docs
          .map((e) => ConsultationPackageModel.fromMap(e.data() as Map))
          .toList();
  }

  @override
  Future<ConsultationPackageModel> getPackage(String id) async {
    var snapShot = await cloudDb.collection('packages').doc(id).get();
    if (snapShot != null && snapShot.exists)
      return ConsultationPackageModel.fromMap(snapShot.data() as Map);

    return ConsultationPackageModel(id: "");
  }

  @override
  Future<ChatMessageEntitiy> addChatMessage(
      ChatMessage message, ClassModel classroom) async {
    var user = auth.currentUser;

    message = message
        .copyWith(uid: user.uid)
        .copyWith(senderName: user.displayName)
        .copyWith(time: DateTime.now().toIso8601String())
        .copyWith(url: user.photoURL);

    String id = cloudDb.collection("classrooms/${classroom.id}/chats").doc().id;

    var result = await cloudDb
        .collection('classrooms/${classroom.id}/chats')
        .doc(id)
        .set(message.copyWith(id: id).toMap());
    return message.toEntity(user.uid);
  }

  @override
  Future<ChatMessageEntitiy> addConsultationChatMessage(
      ChatMessage message, ClientConsultationModel client) async {
    var user = auth.currentUser;
    message = message
        .copyWith(uid: user.uid)
        .copyWith(senderName: user.displayName)
        .copyWith(time: DateTime.now().toIso8601String())
        .copyWith(url: user.photoURL);

    String id = cloudDb.collection("consultations/${client.id}/chats").doc().id;

    var result = await cloudDb
        .collection("consultations/${client.id}/chats")
        .doc(id)
        .set(message.copyWith(id: id).toMap());
    return message.toEntity(user.uid);
  }

  DocumentSnapshot startClassChat = null;

  @override
  Future<List<ChatMessageEntitiy>> getChatMessages(
      ClassModel classroom, ChatMessage startAfterChat, int limit) async {
    var user = auth.currentUser;
    FieldValue.serverTimestamp();
    List<ChatMessage> getChats = [];
    if (startAfterChat != null && startClassChat != null) {
      var result = await FirebaseFirestore.instance
          .collection('classrooms/${classroom.id}/chats')
          .limit(limit)
          .orderBy('time', descending: true)
          .startAfterDocument(startClassChat)
          .get();

      if (result != null && result.docs.length > 0) {
        startClassChat = result.docs[result.docs.length - 1];
        List<ChatMessageEntitiy> chats = [];
        result.docs.forEach((element) {
          chats.add(
              ChatMessage.fromMap(element.data() as Map).toEntity(user.uid));
        });

        return chats;
      } else
        return [];
    } else {
      startClassChat = null;

      var result = await FirebaseFirestore.instance
          .collection('classrooms/${classroom.id}/chats')
          .limit(limit)
          .orderBy('time', descending: true)
          .get();

      if (result != null && result.docs.length > 0) {
        List<ChatMessageEntitiy> chats = [];
        startClassChat = result.docs[result.docs.length - 1];

        result.docs.forEach((element) {
          chats.add(
              ChatMessage.fromMap(element.data() as Map).toEntity(user.uid));
        });
        return chats;
      } else
        return [];
    }
  }

  @override
  Future<List<WorkoutPlanModel>> getClasWorkoutPlans(
      ClassModel classroom) async {
    var snapShot = await cloudDb
        .collection('classrooms/${classroom.id}/workoutPlans')
        .get();
    if (snapShot != null && snapShot.docs.length > 0)
      return snapShot.docs
          .map((e) => WorkoutPlanModel.fromMap(e.data() as Map))
          .toList();

    return [];
  }

  @override
  Future<List<DietPlanModel>> getClassDietPlans(ClassModel classroom) async {
    var snapShot =
        await cloudDb.collection('classrooms/${classroom.id}/dietPlans').get();
    if (snapShot != null && snapShot.docs.length > 0)
      return snapShot.docs
          .map((e) => DietPlanModel.fromMap(e.data() as Map))
          .toList();

    return [];
  }

  @override
  Future<ClientConsultationModel> getConsultationById(String id) async {
    var user = auth.currentUser;
    var snapShot = await cloudDb.collection('consultations').doc(id).get();
    if (snapShot == null || !snapShot.exists)
      return Future.value(ClientConsultationModel());

    return ClientConsultationModel.fromMap(snapShot.data() as Map);
  }

  DocumentSnapshot startConsultationChat = null;
  @override
  Future<List<ChatMessageEntitiy>> getConsultationChatMessages(
      ClientConsultationModel client,
      ChatMessage startAfterChat,
      int limit) async {
    var user = auth.currentUser;
    FieldValue.serverTimestamp();
    List<ChatMessage> getChats = [];
    if (startAfterChat != null && startConsultationChat != null) {
      var result = await FirebaseFirestore.instance
          .collection('consultations/${client.id}/chats')
          .limit(limit)
          .orderBy('time', descending: true)
          .startAfterDocument(startConsultationChat)
          .get();

      if (result != null && result.docs.length > 0) {
        startClassChat = result.docs[result.docs.length - 1];
        List<ChatMessageEntitiy> chats = [];
        result.docs.forEach((element) {
          chats.add(
              ChatMessage.fromMap(element.data() as Map).toEntity(user.uid));
        });

        return chats;
      } else
        return [];
    } else {
      startConsultationChat = null;

      var result = await FirebaseFirestore.instance
          .collection('consultations/${client.id}/chats')
          .limit(limit)
          .orderBy('time', descending: true)
          .get();

      if (result != null && result.docs.length > 0) {
        List<ChatMessageEntitiy> chats = [];
        startClassChat = result.docs[result.docs.length - 1];

        result.docs.forEach((element) {
          chats.add(
              ChatMessage.fromMap(element.data() as Map).toEntity(user.uid));
        });
        return chats;
      } else
        return [];
    }
  }

  @override
  Future<List<DietPlanModel>> getConsultationDietPlans(
      ClientConsultationModel consultation) async {
    var snapShot = await cloudDb
        .collection('consultations/${consultation.id}/dietPlans')
        .get();
    if (snapShot != null && snapShot.docs.length > 0)
      return snapShot.docs
          .map((e) => DietPlanModel.fromMap(e.data() as Map))
          .toList();

    return [];
  }

  @override
  Future<List<WorkoutPlanModel>> getConsultationWorkoutPlans(
      ClientConsultationModel consultation) async {
    var snapShot = await cloudDb
        .collection('consultations/${consultation.id}/workoutPlans')
        .get();
    if (snapShot != null && snapShot.docs.length > 0)
      return snapShot.docs
          .map((e) => WorkoutPlanModel.fromMap(e.data() as Map))
          .toList();

    return [];
  }

  @override
  Future<List<NoticeboardMessage>> getNoticeBoardMessages(
      ClassModel classroom) async {
    var result = await FirebaseFirestore.instance
        .collection('classrooms/${classroom.id}/announcements')
        .doc('data')
        .get();

    if (result != null && result.exists) {
      return List<NoticeboardMessage>.from(
          (result.data() as Map)['data'].map((i) {
                var z = Map<String, dynamic>.from(i);
                print("t here fromSnapshot $z");

                return NoticeboardMessage.fromMap(z) ?? NoticeboardMessage();
              }) ??
              const []);
    } else
      return [];
  }

  @override
  Future<List<ResourceMessage>> getResourceMessages(
      ClassModel classroom) async {
    var result = await FirebaseFirestore.instance
        .collection('classrooms/${classroom.id}/resources')
        .doc('data')
        .get();

    if (result != null && result.exists) {
      return List<ResourceMessage>.from((result.data() as Map)['data'].map((i) {
            var z = Map<String, dynamic>.from(i);
            print("t here fromSnapshot $z");

            return ResourceMessage.fromMap(z) ?? ResourceMessage();
          }) ??
          const []);
    } else
      return [];
  }

  @override
  Future<ActivityModel> getActivityById(int activityId) async {
    var snapShot = await cloudDb
        .collection('ActivitiesDb/data/activities')
        .doc(activityId.toString())
        .get();
    if (snapShot != null) {
      return ActivityModel.fromSnapshot(snapShot);
    } else
      return Future.value(ActivityModel(id: -1));
  }
}
