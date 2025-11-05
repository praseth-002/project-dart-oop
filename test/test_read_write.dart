import 'dart:io';
import 'package:test/test.dart';
import '../lib/data/save.dart';
import '../lib/domain/staff.dart';

void main() {
  group('DataManager Tests', () {
    final testFilePath = 'test_staff.json';
    late DataManager dataManager;

    setUp(() {
      File(testFilePath).writeAsStringSync('');
      dataManager = DataManager(testFilePath);
    });

    tearDown(() {
      if (File(testFilePath).existsSync()) {
        File(testFilePath).deleteSync();
      }
    });

    test('Save and Load Staff', () {
      // Arrange: create sample staff
      var staff1 = Staff("Alice", "Female", "1990-01-01", Role.Receptionist, 2000);
      var doctor1 = Doctor("Bob", "Male", "1985-05-05", 5000, Specialization.Surgeon);
      var admin1 = Admin("Carol", "Female", "1992-03-03", 6000, "admin@test.com", "123456");

      var staffList = [staff1, doctor1, admin1];

      dataManager.saveStaff(staffList);

      var loadedList = dataManager.loadStaff();

      expect(loadedList.length, 3);

      expect(loadedList[0], isA<Staff>());
      expect(loadedList[1], isA<Doctor>());
      expect(loadedList[2], isA<Admin>());

      expect(loadedList[0].staffName, "Alice");
      expect((loadedList[1] as Doctor).specialization, Specialization.Surgeon);
      expect((loadedList[2] as Admin).email, "admin@test.com");
    });
  });
}
