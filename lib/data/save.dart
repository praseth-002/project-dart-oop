import 'dart:io';
import 'dart:convert';
import '../domain/staff.dart'; // your Staff, Doctor, Admin classes

class DataManager {
  final String filePath;

  DataManager(this.filePath);

  /// Save a list of staff to the JSON file
  void saveStaff(List<Staff> staffList) {
    final file = File(filePath);
    final data = staffList.map((s) => s.toJson()).toList();
    file.writeAsStringSync(jsonEncode(data));
  }

  /// Load staff from JSON file
  List<Staff> loadStaff() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    final List<dynamic> data = jsonDecode(content);

    return data.map((s) {
      switch (s['type']) {
        case 'Doctor':
          return Doctor.fromJson(s);
        case 'Admin':
          return Admin.fromJson(s);
        default:
          return Staff.fromJson(s);
      }
    }).toList();
  }
}
