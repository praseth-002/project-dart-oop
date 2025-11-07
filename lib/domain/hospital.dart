// ignore_for_file: file_names
import 'dart:io';
import 'dart:math';
import 'staff.dart';
import 'attendance.dart';

class Hospital {
  final String hospitalName;
  // ignore: prefer_final_fields
  List<Staff> _staffs = [];

  Hospital(this.hospitalName);

  //get all staff
  List<Staff> get staffs => _staffs;

  //add new staff
  Staff addStaff(Staff newStaff) {
    staffs.add(newStaff);
    return newStaff;
  }

  //view staff by role
  List<Staff> viewStaffByRole(Role role) {
    List<Staff> staffByRole = [];
    for (var staff in staffs) {
      if (staff.position == role) {
        staffByRole.add(staff);
      }
    }
    return staffByRole;
  }

  //search staff, by id less headache (nvm apparently the uuid thing long as hell 💀)
  Staff? searchStaffById(String id) {
    for (var staff in staffs) {
      if (staff.staffId == id) {
        return staff;
      }
    }
    return null;
  }

  //or search by name, no handle dupes, will return all with the same/similar in a list
  // Staff? searchStaffByName(String name) {
  //   name = name.toLowerCase();
  //   for (var staff in staffs) {
  //     if (staff.staffName.toLowerCase() == name) {
  //       return staff;
  //     }
  //   }
  //   return null;
  // }
  List<Staff> searchStaffByName(String name) {
    name = name.toLowerCase();
    List<Staff> matches = [];

    for (var staff in staffs) {
      if (staff.staffName.toLowerCase().contains(name)) {
        matches.add(staff);
      }
    }

    return matches;
  }

  //edit staff (in ui recommend dak ah search staff by id, if name u need to code jren filter and stuff)
  Staff editStaffInfo(
    Staff staff, {
    String? name,
    String? gender,
    String? dob,
    Role? position,
    double? baseSalary,
    Specialization? specialization,
    List<String>? certifications,
    int? yearOfExperince,
  }) {
    if (name != null) staff.staffName = name;
    if (gender != null) staff.gender = gender;
    if (dob != null) staff.dob = dob;
    if (position != null) staff.position = position;
    if (baseSalary != null) staff.baseSalary = baseSalary;

    // --- Handle Doctor-specific updates ---
    if (staff is Doctor && specialization != null) {
      staff.specialization = specialization;
    }

    // --- Handle Nurse-specific updates ---
    if (staff is Nurse) {
      if (certifications != null) {
        staff.certification = certifications;
      }
      if (yearOfExperince != null) {
        staff.yearOfExperince = yearOfExperince;
      }
    }

    return staff;
  }

  // Staff editStaffInfo (Staff staff, {String? name, String? gender ,String? dob ,Role? position ,double? baseSalary}) {
  //   if (name != null) staff.staffName = name;
  //   if (gender != null) staff.gender = gender;
  //   if (dob != null) staff.dob = dob;
  //   if (position != null) staff.position = position;
  //   if (baseSalary != null) staff.baseSalary = baseSalary;
  //   return staff;
  // }

  //remove staff
  void removeStaffById(String id) {
    for (var staff in staffs) {
      if (staff.staffId == id) {
        staffs.remove(staff);
        return;
      }
    }
    throw Exception("staff $id not found");
  }

  Admin? findAdminByEmail(String email) {
    for (var staff in _staffs) {
      if (staff is Admin && staff.email == email) {
        return staff;
      }
    }
    return null;
  }

  //total salary for staff
  //3 bonuses: role, doc specialization, and overtime
  //role: recep + 0, nurse + 1000, doc + 2000
  //doc special: gen + 2000, ped + 1000, surg + 3000
  //overtime: + 100 each hr over 8, hr 9, 10, 11...

  double staffTotalSalary(Staff staff) {
    double totalSalary = staff.baseSalary;
    double roleBonus = 0;
    double specializationBonus = 0;
    double overtimePay = 0;
    double experienceBonus = 0;

    // Role bonus
    switch (staff.position) {
      case Role.Receptionist:
        roleBonus = 0;
        break;
      case Role.Nurse:
        roleBonus = 1000;
        break;
      case Role.Doctor:
        roleBonus = 2000;
        break;
      default:
        roleBonus = 0;
    }

    // Doctor specialization bonus
    if (staff is Doctor) {
      switch (staff.specialization) {
        case Specialization.General:
          specializationBonus = 2000;
          break;
        case Specialization.Pediatrician:
          specializationBonus = 1000;
          break;
        case Specialization.Surgeon:
          specializationBonus = 3000;
          break;
      }
    }

    // Nurse years of experience bonus
    if (staff is Nurse) {
      experienceBonus = staff.yearOfExperince * 100;
    }

    // Overtime calculation (fractional hours)
    for (var attendance in staff.attendance) {
      double hoursWorked = attendance.timeWorked().inMinutes / 60.0;
      if (hoursWorked > 8) {
        double overtimeHours = hoursWorked - 8;
        overtimePay += overtimeHours * 50; // $50 per overtime hour
      }
    }

    totalSalary +=
        roleBonus + specializationBonus + overtimePay + experienceBonus;

    return totalSalary;
  }

  // double staffTotalSalary(Staff staff) {
  //   double totalSalary = staff.baseSalary;
  //   double roleBonus = 0;
  //   double specializationBonus = 0;
  //   double overtimePay = 0;

  //   switch (staff.position) {
  //     case Role.Receptionist:
  //       roleBonus = 0;
  //       break;
  //     case Role.Nurse:
  //       roleBonus = 1000;
  //       break;
  //     case Role.Doctor:
  //       roleBonus = 2000;
  //       break;
  //     default:
  //       roleBonus = 0;
  //   }

  //   if (staff is Doctor) {
  //     switch (staff.specialization) {
  //       case Specialization.General:
  //         specializationBonus = 2000;
  //         break;
  //       case Specialization.Pediatrician:
  //         specializationBonus = 1000;
  //         break;
  //       case Specialization.Surgeon:
  //         specializationBonus = 3000;
  //         break;
  //     }
  //   }

  //   for (var attendance in staff.attendance) {
  //     var hoursWorked = attendance.timeWorked().inHours;
  //     if (hoursWorked > 8) {
  //       var overtimeHours = hoursWorked - 8;
  //       overtimePay += overtimeHours * 100;
  //     }
  //   }

  //   totalSalary += roleBonus + specializationBonus + overtimePay;

  //   return totalSalary;
  // }

  //attendance tracker thing
  //format for datetime yyyy, mm, dd, hh, mm
  void recordAttendance(Staff staff, DateTime start, DateTime end) {
    staff.attendance.add(Attendance(start, end));
  }
}
