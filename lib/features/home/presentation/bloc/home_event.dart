abstract class HomeEvent {}

/// Load all events from Firestore
class LoadEvents extends HomeEvent {}

/// Add new event
class AddEvent extends HomeEvent {
  final String name;
  final String date;

  AddEvent({
    required this.name,
    required this.date,
  });
}
