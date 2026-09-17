class AnimalAchievement {
  const AnimalAchievement({
    required this.id,
    required this.animalId,
    required this.competitionId,
    required this.rank,
    required this.timing,
    required this.pointsOrScore,
    required this.achievementDate,
  });

  final String id;
  final String animalId;
  final String competitionId;
  final int rank;
  final String? timing;
  final double? pointsOrScore;
  final DateTime achievementDate;
}
