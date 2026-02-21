import '../../domain/entities/registration_entity.dart';

abstract class RegistrationEvent {}

class SubmitRegistration extends RegistrationEvent {
  final RegistrationEntity registration;

  SubmitRegistration(this.registration);
}
