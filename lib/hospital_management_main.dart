import './data/save.dart';
import './domain/staff.dart';
import './domain/hospital.dart';
import './ui/hospital_staff_console.dart';

void main() {
  final filePath = 'data/staff.json';
  final dataManager = DataManager(filePath);

  List<Staff> staffList = dataManager.loadStaff();

  Hospital hospital = Hospital("Hospital 01");
  for (var staff in staffList) {
    hospital.addStaff(staff);
  }

  HospitalStaffConsole console = HospitalStaffConsole(hospital, dataManager);

  console.startSystem();
  console.authenticationInterface();

  dataManager.saveStaff(hospital.staffs);
}
