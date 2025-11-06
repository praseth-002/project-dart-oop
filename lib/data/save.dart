import 'dart:io';
import 'dart:convert';
import '../domain/staff.dart'; // Staff, Admin, Doctor, Nurse

class DataManager {
  final String filePath;

  DataManager(this.filePath);

  /// Save a list of staff to the JSON file
  void saveStaff(List<Staff> staffList) {
    final file = File(filePath);
    // Load existing staff first
    List<Staff> existingStaff = loadStaff();

    // Update existing staff or add new ones
    for (var newStaff in staffList) {
      int index = existingStaff.indexWhere((s) => s.staffId == newStaff.staffId);
      if (index >= 0) {
        existingStaff[index] = newStaff; 
      } else {
        existingStaff.add(newStaff); 
      }
    }
    const encoder = JsonEncoder.withIndent('  '); 
    final jsonString = encoder.convert(existingStaff.map((s) => s.toJson()).toList());
    file.writeAsStringSync(jsonString);
  }

  /// Load staff from JSON file
  List<Staff> loadStaff() {
    final file = File(filePath);
    if (!file.existsSync()) return [];

    final content = file.readAsStringSync();
    if (content.trim().isEmpty) return [];

    final List<dynamic> data = jsonDecode(content);

    return data.map((s) {
      switch (s['type']) {
        case 'Admin':
          return Admin.fromJson(s);
        case 'Doctor':
          return Doctor.fromJson(s);
        case 'Nurse':
          return Nurse.fromJson(s);
        case 'Staff': // generic staff, like Receptionist
          return Staff.fromJson(s);
        default:
          throw Exception('Unknown staff type: ${s['type']}');
      }
    }).toList();
  }
}


// import 'dart:io';
// import 'dart:convert';
// import '../domain/staff.dart'; // your Staff, Doctor, Admin classes

// class DataManager {
//   final String filePath;

//   DataManager(this.filePath);

//   /// Save a list of staff to the JSON file
//   void saveStaff(List<Staff> staffList) {
//     final file = File(filePath);
//     final data = staffList.map((s) => s.toJson()).toList();
//     file.writeAsStringSync(jsonEncode(data));
//   }

//   /// Load staff from JSON file
//   List<Staff> loadStaff() {
//     final file = File(filePath);
//     if (!file.existsSync()) return [];

//     final content = file.readAsStringSync();
//     final List<dynamic> data = jsonDecode(content);

//     return data.map((s) {
//       switch (s['type']) {
//         case 'Doctor':
//           return Doctor.fromJson(s);
//         case 'Admin':
//           return Admin.fromJson(s);
//         default:
//           return Staff.fromJson(s);
//       }
//     }).toList();
//   }
// }
