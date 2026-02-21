abstract class EventRepository {
  Future<void> createEvent(Map<String, dynamic> data);
  /// 🔥 ADD
  Future<List<Map<String, dynamic>>> loadAllEvents();

  /// 🔥 ADD
  Future<List<Map<String, dynamic>>> loadMyEvents(String organizerId);



}
