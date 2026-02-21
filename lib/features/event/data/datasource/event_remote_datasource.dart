import 'package:cloud_firestore/cloud_firestore.dart';

class EventRemoteDataSource {

  final FirebaseFirestore firestore;

  EventRemoteDataSource(this.firestore);

  // ================= CREATE EVENT =================
  Future<void> createEvent(Map<String, dynamic> data) async {
    await firestore.collection("events").add({
      ...data,
      "createdAt": Timestamp.now(),
      "status": "active",
    });
  }

  // ================= GET ALL EVENTS =================
  Future<List<Map<String, dynamic>>> getAllEvents() async {
    final snapshot = await firestore
        .collection("events")
        .orderBy("createdAt", descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  }

  // ================= GET MY EVENTS =================
  Future<List<Map<String, dynamic>>> getMyEvents(String organizerId) async {

    final snapshot = await firestore
        .collection("events")
        .where("organizerId", isEqualTo: organizerId)
        .get(); // ✅ Removed orderBy to avoid index error

    return snapshot.docs.map((doc) {
      return {
        "id": doc.id,
        ...doc.data(),
      };
    }).toList();
  }

}
