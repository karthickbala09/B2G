import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/home_event_model.dart';

class HomeRemoteDataSource {

  final FirebaseFirestore firestore;

  HomeRemoteDataSource(this.firestore);

  /// Collection reference
  CollectionReference get _eventsCollection =>
      firestore.collection('events');

  /// Add Event to Firestore
  Future<void> addEvent(HomeEventModel event) async {
    await _eventsCollection.add(event.toJson());
  }

  /// Get All Events from Firestore
  Future<List<HomeEventModel>> getEvents() async {

    final snapshot = await _eventsCollection
        .orderBy('date', descending: true)
        .get();

    return snapshot.docs.map((doc) {
      return HomeEventModel.fromJson(
        doc.data() as Map<String, dynamic>,
        doc.id,
      );
    }).toList();
  }
}
