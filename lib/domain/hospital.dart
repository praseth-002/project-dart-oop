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

  //search staff, by id less headache (nvm apparently the uuid thing long as hell 💀)
  Staff searchStaffById (String id) {
    for (var staff in staffs) {
      if (staff.staffId == id) {
        return staff;
      }
    }
    throw Exception("staff $id not found");
  }

  //or search by name, no handle dupes, will return all with the same/similar in a list
   List<Staff> searchStaffByName (String name) {
    name = name.toLowerCase();
    List<Staff> foundStaff = [];
    for (var staff in staffs) {
      if (staff.staffName.toLowerCase().contains(name)) {
        foundStaff.add(staff);
      }
    }
    if (foundStaff.isEmpty) {
      throw Exception("staff $name not found");
    }
    return foundStaff;
  }

  //edit staff (in ui recommend dak ah search staff by id, if name u need to code jren filter and stuff)
  Staff editStaffInfo (Staff staff, {String? name, String? gender ,String? dob ,Role? position ,double? baseSalary}) {
    if (name != null) staff.staffName = name;
    if (gender != null) staff.gender = gender;
    if (dob != null) staff.dob = dob;
    if (position != null) staff.position = position;
    if (baseSalary != null) staff.baseSalary = baseSalary;
    return staff;
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
  
