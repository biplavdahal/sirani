class SessionTimeData {
  final Duration remainingDuration;
  final String endTime;

  SessionTimeData._({
    required this.remainingDuration,
    required this.endTime,
  });

  factory SessionTimeData.fromJson(Map<String, dynamic> json) {
    return SessionTimeData._(
      remainingDuration: json["remaining_duration"],
      endTime: json["end_time"],
    );
  }
}
