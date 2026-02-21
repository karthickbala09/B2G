import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasource/auth_local_datasource.dart';
import '../datasource/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(
      this.remoteDataSource,
      this.localDataSource,
      );

  /// LOGIN
  @override
  Future<UserEntity> login(
      String email,
      String password,
      ) async {
    final user = await remoteDataSource.login(
      email,
      password,
    );

    await localDataSource.saveLoginStatus(true);

    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      fullName: user.displayName ?? '',
    );
  }

  /// REGISTER
  @override
  Future<UserEntity> register(
      String fullName,
      String email,
      String password,
      ) async {
    final user = await remoteDataSource.register(
      fullName,
      email,
      password,
    );

    await localDataSource.saveLoginStatus(true);

    return UserEntity(
      uid: user.uid,
      email: user.email ?? '',
      fullName: fullName,
    );
  }

  /// FORGOT PASSWORD
  @override
  Future<void> forgotPassword(String email) {
    return remoteDataSource.forgotPassword(email);
  }

  /// SAVE LOGIN STATUS
  @override
  Future<void> saveLoginStatus(bool status) {
    return localDataSource.saveLoginStatus(status);
  }

  /// GET LOGIN STATUS
  @override
  Future<bool> getLoginStatus() {
    return localDataSource.getLoginStatus();
  }

  /// LOGOUT
  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
    await localDataSource.clearLoginStatus();
  }
}
