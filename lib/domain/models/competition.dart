class Competition {
  const Competition({
    required this.id,
    required this.title,
    required this.type,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.startDate,
    required this.endDate,
    required this.status,
    required this.bannerUrl,
  });

  final String id;
  final String title;
  final String type;
  final String location;
  final double? latitude;
  final double? longitude;
  final DateTime startDate;
  final DateTime endDate;
  final String status;
  final String? bannerUrl;
}

class CompetitionRound {
  const CompetitionRound({
    required this.id,
    required this.competitionId,
    required this.title,
    required this.distance,
    required this.scheduledTime,
  });

  final String id;
  final String competitionId;
  final String title;
  final int? distance;
  final DateTime scheduledTime;
}

class Prize {
  const Prize({
    required this.id,
    required this.roundId,
    required this.rank,
    required this.prizeDescription,
  });

  final String id;
  final String roundId;
  final int rank;
  final String prizeDescription;
}
