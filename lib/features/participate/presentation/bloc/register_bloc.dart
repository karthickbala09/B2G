import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hackthon_app/features/participate/presentation/bloc/register_event.dart';
import 'package:hackthon_app/features/participate/presentation/bloc/register_state.dart';
import '../../domain/repositories/registration_repository.dart';
class RegistrationBloc
    extends Bloc<RegistrationEvent, RegistrationState> {

  final RegistrationRepository repository;

  RegistrationBloc(this.repository)
      : super(RegistrationInitial()) {

    on<SubmitRegistration>((event, emit) async {

      emit(RegistrationLoading());

      try {
        await repository.register(event.registration);
        emit(RegistrationSuccess());
      } catch (e) {
        emit(RegistrationFailure("Registration Failed"));
      }
    });
  }
}
