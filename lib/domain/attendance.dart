class Attendance {
  DateTime shiftStart;
  DateTime shiftEnd;

  Attendance (this.shiftStart, this.shiftEnd);

  Duration timeWorked() {
    return shiftEnd.difference(shiftStart);
  } 

  @override  
  String toString() {
    final duration = timeWorked();
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    return "Shift Start: $shiftStart, Shift End: $shiftEnd, Worked For: ${hours}h ${minutes}m";
  }
}

void main() {
  var att = Attendance(
    DateTime(2025, 11, 2, 8, 0),
    DateTime(2025, 11, 2, 17, 30),
  );

  print(att.timeWorked().inHours); // 9
  print(att.timeWorked().inMinutes); // 570
  print(att);
}