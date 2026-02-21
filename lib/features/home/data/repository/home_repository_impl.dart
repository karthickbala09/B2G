import '../../domain/entities/home_event_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasouce/home_remote_datasource.dart';
import '../model/home_event_model.dart';

class HomeRepositoryImpl implements HomeRepository {

  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<void> addEvent(HomeEventEntity event) async {

    final model = HomeEventModel(
      id: event.id,
      name: event.name,
      date: event.date,
    );

    await remoteDataSource.addEvent(model);
  }

  @override
  Future<List<HomeEventEntity>> getEvents() async {
    final models = await remoteDataSource.getEvents();

    return models;
  }
}
