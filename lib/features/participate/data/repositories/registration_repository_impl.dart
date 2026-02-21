import '../../domain/entities/registration_entity.dart';
import '../../domain/repositories/registration_repository.dart';

import '../datasources/registration_remote_datasource.dart';
import '../models/registration_model.dart';

class RegistrationRepositoryImpl implements RegistrationRepository {

  final RegistrationRemoteDataSource remoteDataSource;

  RegistrationRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> register(RegistrationEntity registration) async {

    final model = RegistrationModel(
      eventId: registration.eventId,
      participantId: registration.participantId,
      name: registration.name,
      email: registration.email,
      phone: registration.phone,
      college: registration.college,
      teamName: registration.teamName,
      teamSize: registration.teamSize,
      members: registration.members,
      abstractText: registration.abstractText,
      createdAt: registration.createdAt,
    );

    await remoteDataSource.register(model);
  }
}
