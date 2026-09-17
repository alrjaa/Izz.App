class Animal {
  const Animal({
    required this.id,
    required this.ownerId,
    required this.type,
    required this.name,
    required this.microchipNumber,
    required this.categoryColor,
    required this.ageClass,
    required this.fatherName,
    required this.motherName,
    required this.birthYear,
    required this.avatarUrl,
  });

  final String id;
  final String ownerId;
  final String type;
  final String name;
  final String microchipNumber;
  final String? categoryColor;
  final String ageClass;
  final String? fatherName;
  final String? motherName;
  final int? birthYear;
  final String? avatarUrl;
}
