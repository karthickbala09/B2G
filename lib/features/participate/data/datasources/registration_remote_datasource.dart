import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/registration_model.dart';

class RegistrationRemoteDataSource {

  final FirebaseFirestore firestore;

  RegistrationRemoteDataSource(this.firestore);

  Future<void> register(RegistrationModel model) async {

    await firestore.collection("registrations").add(
      model.toMap(),
    );
  }
}
