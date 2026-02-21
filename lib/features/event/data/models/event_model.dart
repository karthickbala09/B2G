import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/event_entity.dart';

class EventModel extends EventEntity {
  EventModel({
    String? id,
    required Map<String, dynamic> data,
  }) : super(id: id, data: data);

  Map<String, dynamic> toMap() {
    return {
      ...data,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
  }

  factory EventModel.fromSnapshot(DocumentSnapshot doc) {
    return EventModel(
      id: doc.id,
      data: doc.data() as Map<String, dynamic>,
    );
  }
}
