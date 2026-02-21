import '../entities/user_entity.dart';

abstract class AuthRepository {

  /// Login user
  Future<UserEntity> login(
      String email,
      String password,
      );

  /// Register user + store profile in Firestore
  Future<UserEntity> register(
      String fullName,
      String email,
      String password,
      );

  /// Send password reset email
  Future<void> forgotPassword(String email);

  /// Save login status locally
  Future<void> saveLoginStatus(bool status);

  /// Get login status
  Future<bool> getLoginStatus();

  /// Logout user
  Future<void> logout();
}
