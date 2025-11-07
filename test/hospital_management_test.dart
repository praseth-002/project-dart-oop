import 'package:test/test.dart';
import 'package:hospital_management/domain/hospital.dart';
import 'package:hospital_management/domain/staff.dart';
// import 'package:hospital_management/domain/attendance.dart';

void main() {
  group('Hospital Domain Tests', () {
    late Hospital hospital;

    setUp(() {
      hospital = Hospital('Test Hospital');
    });

    test('Add new staff increases staff count', () {
      final staff = Staff('Bopich', 'Female', '2000-01-01', Role.Receptionist, 1000);
      hospital.addStaff(staff);

      expect(hospital.staffs.length, 1);
      expect(hospital.staffs.first.staffName, equals('Bopich'));
    });

    test('Search staff by ID returns correct staff', () {
      final staff = Staff('Darong', 'Male', '1998-04-12', Role.Nurse, 2000);
      hospital.addStaff(staff);

      final found = hospital.searchStaffById(staff.staffId);
      expect(found, isNotNull);
      expect(found!.staffName, equals('Darong'));
    });

    test('Search staff by name is case-insensitive', () {
      final staff = Staff('Praseth', 'Male', '1995-05-05', Role.Receptionist, 1500);
      hospital.addStaff(staff);

      final foundList = hospital.searchStaffByName('praseth'); // lowercase to test case-insensitivity
      expect(foundList, isNotEmpty);
      expect(foundList.first.staffName, equals('Praseth'));
    });


    test('Edit staff info updates fields correctly', () {
      final staff = Staff('Leaphea', 'Male', '1990-07-07', Role.Nurse, 2000);
      hospital.addStaff(staff);

      hospital.editStaffInfo(staff, name: 'Sokleaphea', baseSalary: 2500);

      expect(staff.staffName, equals('Sokleaphea'));
      expect(staff.baseSalary, equals(2500));
    });

    test('Remove staff by ID reduces count', () {
      final staff = Staff('Bopich', 'Female', '2001-02-02', Role.Receptionist, 1000);
      hospital.addStaff(staff);
      expect(hospital.staffs.length, 1);

      hospital.removeStaffById(staff.staffId);
      expect(hospital.staffs.length, 0);
    });

    test('Record attendance adds to staff attendance list', () {
      final staff = Staff('Darong', 'Male', '1985-12-12', Role.Nurse, 1800);
      hospital.addStaff(staff);

      final start = DateTime(2025, 11, 2, 8, 0);
      final end = DateTime(2025, 11, 2, 17, 0);
      hospital.recordAttendance(staff, start, end);

      expect(staff.attendance.length, 1);
      expect(staff.attendance.first.timeWorked().inHours, equals(9));
    });

    test('Doctor salary includes role + specialization + overtime bonus', () {
      final doctor = Doctor('Praseth', 'Male', '1980-01-01', 5000, Specialization.Surgeon);
      final hospital = Hospital('Test Hospital');
      hospital.addStaff(doctor);

      hospital.recordAttendance(doctor, DateTime(2025, 11, 2, 8, 0), DateTime(2025, 11, 2, 18, 0));

      final total = hospital.staffTotalSalary(doctor);
      expect(total, equals(10100));
    });

    test('findAdminByEmail returns correct admin', () {
      final admin = Admin('Sokleaphea', 'Male', '1999-10-10', 4000, 'admin@test.com', '1234');
      hospital.addStaff(admin);

      final found = hospital.findAdminByEmail('admin@test.com');
      expect(found, isNotNull);
      expect(found!.isAuthenticated('admin@test.com', '1234'), isTrue);
    });

    test('Removing non-existent staff throws Exception', () {
      expect(() => hospital.removeStaffById('invalid-id'), throwsException);
    });
  });
}
