import '../../domain/entities/home_event_entity.dart';

class HomeEventModel extends HomeEventEntity {

  const HomeEventModel({
    required super.id,
    required super.name,
    required super.date,
  });

  /// Convert Firestore → Model
  factory HomeEventModel.fromJson(Map<String, dynamic> json, String id) {
    return HomeEventModel(
      id: id,
      name: json['name'] ?? '',
      date: json['date'] ?? '',
    );
  }

  /// Convert Model → Firestore
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date': date,
    };
  }
}
