abstract class EventEvent {}

class CreateEvent extends EventEvent {
  final Map<String, dynamic> data;
  CreateEvent(this.data);
}
/// 🔥 ADD THIS
class LoadAllEvents extends EventEvent {}

/// 🔥 ADD THIS
class LoadMyEvents extends EventEvent {
  final String organizerId;
  LoadMyEvents(this.organizerId);
}