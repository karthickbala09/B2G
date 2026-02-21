import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/registration_entity.dart';

class RegistrationModel extends RegistrationEntity {

  RegistrationModel({
    required super.eventId,
    required super.participantId,
    required super.name,
    required super.email,
    required super.phone,
    required super.college,
    required super.teamName,
    required super.teamSize,
    required super.members,
    required super.abstractText,
    required super.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      "eventId": eventId,
      "participantId": participantId,
      "name": name,
      "email": email,
      "phone": phone,
      "college": college,
      "teamName": teamName,
      "teamSize": teamSize,
      "members": members,
      "abstract": abstractText,
      "createdAt": FieldValue.serverTimestamp(),
      "status": "pending",
      "score": 0,
      "rank": null,
    };
  }
}
