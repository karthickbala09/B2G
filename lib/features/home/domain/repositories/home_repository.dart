import '../entities/home_event_entity.dart';

abstract class HomeRepository {

  /// Get all events
  Future<List<HomeEventEntity>> getEvents();

  /// Add new event
  Future<void> addEvent(HomeEventEntity event);

}
