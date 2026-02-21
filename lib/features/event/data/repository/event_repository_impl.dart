import '../../domain/repositories/event_repository.dart';
import '../datasource/event_remote_datasource.dart';

class EventRepositoryImpl implements EventRepository {

  final EventRemoteDataSource remoteDataSource;

  EventRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> createEvent(Map<String, dynamic> data) {
    return remoteDataSource.createEvent(data);
  }
  @override
  Future<List<Map<String, dynamic>>> loadAllEvents() async {
    final snapshot = await remoteDataSource.getAllEvents();
    return snapshot;
  }

  @override
  Future<List<Map<String, dynamic>>> loadMyEvents(String organizerId) async {
    final snapshot = await remoteDataSource.getMyEvents(organizerId);
    return snapshot;
  }




}
