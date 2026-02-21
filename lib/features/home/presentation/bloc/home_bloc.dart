import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/home_event_entity.dart';
import '../../domain/repositories/home_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {

    /// LOAD EVENTS
    on<LoadEvents>((event, emit) async {
      emit(HomeLoading());
      try {
        final events = await repository.getEvents();
        emit(HomeLoaded(events));
      } catch (e) {
        emit(HomeError("Failed to load events"));
      }
    });

    /// ADD EVENT
    on<AddEvent>((event, emit) async {
      try {
        final newEvent = HomeEventEntity(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          name: event.name,
          date: event.date,
        );

        await repository.addEvent(newEvent);

        final events = await repository.getEvents();
        emit(HomeLoaded(events));
      } catch (e) {
        emit(HomeError("Failed to add event"));
      }
    });
  }
}
