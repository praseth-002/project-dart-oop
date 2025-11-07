class Attendance {
  DateTime start;
  DateTime end;

  Attendance(this.start, this.end);

  Duration timeWorked() => end.difference(start);

  Map<String, Object> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        DateTime.parse(json['start'] as String),
        DateTime.parse(json['end'] as String),
      );
}