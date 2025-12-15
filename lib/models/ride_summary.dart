/// Driver's daily ride summary
class RideSummary {
  final int totalRides;
  final double totalEarnings;
  final String date; // YYYY-MM-DD format

  const RideSummary({
    required this.totalRides,
    required this.totalEarnings,
    required this.date,
  });

  factory RideSummary.fromJson(Map<String, dynamic> json) {
    return RideSummary(
      totalRides: json['totalRides'] ?? 0,
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
      date: json['date'] ?? '',
    );
  }

  /// Returns true if there are any rides
  bool get hasRides => totalRides > 0;
}
