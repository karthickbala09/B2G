import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRemoteDataSource {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;

  AuthRemoteDataSource(
      this.firebaseAuth,
      this.firestore,
      );

  /// LOGIN
  Future<User> login(
      String email,
      String password,
      ) async {
    final credential =
    await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return credential.user!;
  }

  /// REGISTER + STORE IN FIRESTORE
  Future<User> register(
      String fullName,
      String email,
      String password,
      ) async {
    final credential =
    await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user!;

    // Store profile data in Firestore
    await firestore.collection('users').doc(user.uid).set({
      'uid': user.uid,
      'fullName': fullName,
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    return user;
  }

  /// FORGOT PASSWORD
  Future<void> forgotPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }

  /// LOGOUT
  Future<void> logout() async {
    await firebaseAuth.signOut();
  }
}
