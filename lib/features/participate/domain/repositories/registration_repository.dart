import '../entities/registration_entity.dart';

abstract class RegistrationRepository {
  Future<void> register(RegistrationEntity registration);
}
