class RegistrationEntity {
  final String eventId;
  final String participantId;
  final String name;
  final String email;
  final String phone;
  final String college;
  final String teamName;
  final String teamSize;
  final String members;
  final String abstractText;
  final DateTime createdAt;

  RegistrationEntity({
    required this.eventId,
    required this.participantId,
    required this.name,
    required this.email,
    required this.phone,
    required this.college,
    required this.teamName,
    required this.teamSize,
    required this.members,
    required this.abstractText,
    required this.createdAt,
  });
}
