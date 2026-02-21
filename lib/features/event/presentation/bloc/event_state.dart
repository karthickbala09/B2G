abstract class EventState {}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {}

class EventFailure extends EventState {
  final String message;
  EventFailure(this.message);
}
/// 🔥 ADD THIS
class EventLoaded extends EventState {
  final List<Map<String, dynamic>> events;
  EventLoaded(this.events);
}