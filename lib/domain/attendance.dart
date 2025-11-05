class Attendance {
  DateTime start;
  DateTime end;

  Attendance(this.start, this.end);

  Duration timeWorked() => end.difference(start);

  Map<String, dynamic> toJson() => {
        'start': start.toIso8601String(),
        'end': end.toIso8601String(),
      };

  factory Attendance.fromJson(Map<String, dynamic> json) => Attendance(
        DateTime.parse(json['start']),
        DateTime.parse(json['end']),
      );
}


// class Attendance {
//   DateTime shiftStart;
//   DateTime shiftEnd;

//   Attendance (this.shiftStart, this.shiftEnd);

//   Duration timeWorked() {
//     return shiftEnd.difference(shiftStart);
//   } 

//   @override  
//   String toString() {
//     final duration = timeWorked();
//     final hours = duration.inHours;
//     final minutes = duration.inMinutes.remainder(60);
//     return "Shift Start: $shiftStart, Shift End: $shiftEnd, Worked For: ${hours}h ${minutes}m";
//   }
// }

// void main() {
//   var att = Attendance(
//     DateTime(2025, 11, 2, 8, 0),
//     DateTime(2025, 11, 2, 17, 30),
//   );

//   print(att.timeWorked().inHours); // 9
//   print(att.timeWorked().inMinutes); // 570
//   print(att);
// }