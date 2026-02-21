import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/event_repository.dart';
import 'event_event.dart';
import 'event_state.dart';

class EventBloc extends Bloc<EventEvent, EventState> {

  final EventRepository repository;

  EventBloc(this.repository) : super(EventInitial()) {

    // ================= CREATE EVENT =================
    on<CreateEvent>((event, emit) async {
      emit(EventLoading());

      try {
        await repository.createEvent(event.data);
        emit(EventSuccess());
      } catch (e) {
        emit(EventFailure("Failed to create event"));
      }
    });

    // ================= LOAD ALL EVENTS (FOR PARTICIPATE) =================
    on<LoadAllEvents>((event, emit) async {
      emit(EventLoading());

      try {
        final events = await repository.loadAllEvents();
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventFailure("Failed to load events"));
      }
    });

    // ================= LOAD MY EVENTS (FOR DASHBOARD) =================
    on<LoadMyEvents>((event, emit) async {
      emit(EventLoading());

      try {
        final events =
        await repository.loadMyEvents(event.organizerId);
        emit(EventLoaded(events));
      } catch (e) {
        emit(EventFailure("Failed to load your events"));
      }
    });

  }
}
