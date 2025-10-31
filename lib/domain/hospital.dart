// ignore_for_file: file_names
import 'dart:io';
import 'dart:math';
import 'staff.dart';

class Hospital {
  final String hospitalName;
  // ignore: prefer_final_fields
  List<Staff> _staffs = [];

  Hospital(this.hospitalName);

  //get all staff
  List<Staff> get staffs => _staffs;

  //add new staff
  Staff addStaff (Staff newStaff) {
    staffs.add(newStaff);
    return newStaff;
  }

  //view staff by role
  List viewStaffByRole (Role role) {
    List<Staff> staffByRole = [];
    for (var staff in staffs) {
      if (staff.position == role) {
        staffByRole.add(staff);
      }
    }
    return staffByRole;
  }

  //search staff (by id less headache)
  Staff searchStaffById (String id) {
    for (var staff in staffs) {
      if (staff.staffId == id) {
        return staff;
      }
    }
    throw Exception("staff $id not found");
  }

  //edit staff 🚧 🚜 👷‍♂️
  Staff editStaffInfo (String id) {
    throw Exception("wait");
  }

  //remove staff
  void removeStaffById (String id) {
    for (var staff in staffs) {
      if (staff.staffId == id) {
        staffs.remove(staff);
        exit(0);
      }
    }
    throw Exception("staff $id not found");
  }

  Admin? findAdminByEmail(String email) {
    for (var staff in _staffs){
      if (staff is Admin && staff.email == email) {
        return staff;
      }
    }
    return null;
  }

}
  
