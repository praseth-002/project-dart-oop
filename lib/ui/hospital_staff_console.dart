import 'dart:io';
import 'package:enough_ascii_art/enough_ascii_art.dart';
import 'package:hospital_management/domain/staff.dart';
import '../domain/hospital.dart';
import '../data/save.dart';

class HospitalStaffConsole {
  final Hospital hospital;
  final DataManager dataManager;

  HospitalStaffConsole(this.hospital, this.dataManager);

  void adminDashboard(Admin admin) {
    while (true) {
      stdout.writeln('\n\n============ ADMIN DASHBOARD ============');
      stdout.writeln('1). Add new staff');
      stdout.writeln('2). View all staff');
      stdout.writeln('3). View staff by role');
      stdout.writeln('4). Search staff by name or Id');
      stdout.writeln('5). Edit staff information');
      stdout.writeln('6). Remove staff');
      stdout.writeln('7). Record Attendance');
      stdout.writeln('8). View Total Salary of Staff');
      stdout.writeln('9). View Total Salary of All Staff');
      stdout.writeln('10). Logout');
      stdout.writeln('=========================================');
      stdout.write('Please select an option: ');
      String? input = stdin.readLineSync();

      switch (input) {
        //add new staff
        case '1':
          stdout
              .writeln('\n------------------ ADD NEW STAFF ------------------');
          stdout.writeln('\nPlease input the following staff information:');
          var name = _askLabel('Name');
          var gender = _askLabel('Gender');
          var dob = _askLabel('Date of Birth (DD/MM/YYYY)');
          var salary = _inputSalary();
          var role = _askRole();

          if (role == Role.Admin) {
            var email = _askLabel('Email');
            var password = _askLabel('Password');
            stdout.writeln('\nYou are about to add this Admin:');
            stdout.writeln('Name: $name');
            stdout.writeln('Gender: $gender');
            stdout.writeln('DOB: $dob');
            stdout.writeln('Salary: $salary');
            stdout.writeln('Email: $email');
            if (_isConfirm('Confrim add admin? (y/n):')) {
              hospital
                  .addStaff(Admin(name, gender, dob, salary, email, password));
              dataManager.saveStaff(hospital.staffs);
              stdout.writeln('Admin added successfully!');
            } else {
              stdout.write(
                  '-----------------Add Admin cancelled-----------------');
            }
          } else if (role == Role.Doctor) {
            var specialization = _askSpeacialization();
            stdout.writeln('\nYou are about to add this Doctor:');
            stdout.writeln('Name: $name');
            stdout.writeln('Gender: $gender');
            stdout.writeln('DOB: $dob');
            stdout.writeln('Salary: $salary');
            stdout.writeln('Email: $specialization');
            if (_isConfirm('Confrim add doctor? (y/n):')) {
              hospital
                  .addStaff(Doctor(name, gender, dob, salary, specialization));
              dataManager.saveStaff(hospital.staffs);
              stdout.writeln('Doctor added successfully!');
            } else {
              stdout.write(
                  '-----------------Add Doctor cancelled-----------------');
            }

            // } else if (role == Role.Nurse) {
            //   stdout.writeln('\nYou are about to add this Nurse:');
            //   stdout.writeln('Name: $name');
            //   stdout.writeln('Gender: $gender');
            //   stdout.writeln('DOB: $dob');
            //   stdout.writeln('Salary: $salary');

            //   if (_isConfirm('Confrim add nurse? (y/n):')){
            //     hospital.addStaff(Nurse(name, gender, dob, salary));
            //     dataManager.saveStaff(hospital.staffs);
            //     stdout.writeln('Nurse added successfully!');
            //   }else{
            //     stdout.write('-----------------Add Nurse cancelled-----------------');
            //   }
          } else if (role == Role.Nurse) {
            stdout.writeln('\nYou are about to add this Nurse:');
            stdout.writeln('Please input the following information:');
            stdout.writeln('--------------------------------------');

            var yearExpInput = _askLabel(
                'Years of Experience (number, default 0)',
                allowEmpty: true);
            int yearOfExperience = int.tryParse(yearExpInput) ?? 0;

            stdout.writeln(
                'Enter certifications (comma-separated, or leave blank if none):');
            String certInput = stdin.readLineSync() ?? '';
            List<String> certifications = certInput
                .split(',')
                .map((c) => c.trim())
                .where((c) => c.isNotEmpty)
                .toList();

            stdout.writeln('\nYou are about to add this Nurse:');
            stdout.writeln('Name: $name');
            stdout.writeln('Gender: $gender');
            stdout.writeln('DOB: $dob');
            stdout.writeln('Salary: $salary');
            stdout.writeln('Years of Experience: $yearOfExperience');
            stdout.writeln(
                'Certifications: ${certifications.isEmpty ? "None" : certifications.join(", ")}');

            if (_isConfirm('Confirm add nurse? (y/n):')) {
              var nurse = Nurse(name, gender, dob, salary,
                  yearOfExperince: yearOfExperience);
              nurse.certification = certifications;
              hospital.addStaff(nurse);
              dataManager.saveStaff(hospital.staffs);
              stdout.writeln('Nurse added successfully!');
            } else {
              stdout.write(
                  '----------------- Add Nurse cancelled -----------------');
            }
          } else if (role == Role.Receptionist) {
            stdout.writeln('\nYou are about to add this Receptionist:');
            stdout.writeln('Name: $name');
            stdout.writeln('Gender: $gender');
            stdout.writeln('DOB: $dob');
            stdout.writeln('Salary: $salary');
            if (_isConfirm('Confrim add receptionist? (y/n):')) {
              hospital.addStaff(
                  Staff(name, gender, dob, Role.Receptionist, salary));
              dataManager.saveStaff(hospital.staffs);
              stdout.writeln('Receptionist added successfully!');
            } else {
              stdout.write(
                  '-----------------Add Receptionist cancelled-----------------');
            }
          }
          break;

        case '2':
          stdout.writeln('\n\n============ STAFF INFORMATION ============\n');
          for (var staff in hospital.staffs) {
            stdout.writeln('------------------------------------------');
            staff.printInfo();
          }
          stdout.writeln('\n===================END======================\n');
          break;

        case '3':
          stdout.writeln(
              '\n------------------ VIEW STAFF BY ROLE ------------------');
          Role role = _askRole();
          var staffByRole = hospital.viewStaffByRole(role);

          if (staffByRole.isEmpty) {
            stdout.write('There is no staff with that role $role');
          }

          stdout.writeln('\n\n============ STAFF INFORMATION ============\n');
          for (var staff in staffByRole) {
            stdout.writeln('------------------------------------------');
            staff.printInfo();
          }
          stdout.writeln('\n===================END======================\n');
          break;

        case '4':
          stdout
              .writeln('\n------------------ SEARCH STAFF ------------------');

          String input;
          while (true) {
            input = _askLabel('Search by (1) ID or (2) Name: ');
            if (input == '1' || input == '2') break;
            stdout.writeln('Invalid choice, please try again.\n');
          }

          if (input == '1') {
            String id;
            do {
              id = _askLabel('Enter Staff ID: ').trim();
              if (id.isEmpty) {
                stdout.writeln('ID cannot be empty. Please try again.\n');
              }
            } while (id.isEmpty);

            var staff = hospital.searchStaffById(id);
            if (staff != null) {
              stdout.writeln('\n=== STAFF FOUND ===');
              staff.printInfo();
            } else {
              stdout.writeln('\nNo staff found with this ID.');
            }
          } else if (input == '2') {
            String name;
            do {
              name = _askLabel('Enter Staff Name: ').trim();
              if (name.isEmpty)
                stdout.writeln('Name cannot be empty. Please try again.\n');
            } while (name.isEmpty);

            var staffList = hospital.searchStaffByName(name);

            if (staffList.isNotEmpty) {
              stdout.writeln('\n=== STAFF FOUND ===');
              for (var staff in staffList) {
                staff.printInfo();
                stdout.writeln('------------------------------------------');
              }
            } else {
              stdout.writeln('\nNo staff found with this name.');
            }

            // String name;
            // do {
            //   name = _askLabel('Enter Staff Name: ').trim();
            //   if (name.isEmpty) stdout.writeln('Name cannot be empty. Please try again.\n');
            // } while (name.isEmpty);

            // var staff = hospital.searchStaffByName(name);
            // if (staff != null) {
            //   stdout.writeln('\n=== STAFF FOUND ===');
            //   staff.printInfo();
            // } else {
            //   stdout.writeln('\nNo staff found with this name.');
            // }
          }
          break;
        // case '5':
        //   stdout.writeln('\n\n============ EDIT STAFF INFORMATION ============\n');

        //   // Ask for staff ID
        //   String id = _askLabel("Input staff ID").trim();

        //   Staff? staff = hospital.searchStaffById(id);

        //   if (staff == null) {
        //     stdout.writeln('\n No staff found with this ID.');
        //     break;
        //   }

        //   stdout.writeln('\n=== STAFF FOUND ===');
        //   staff.printInfo();

        //   String newName = _askLabel("New Name (leave blank to keep)",allowEmpty: true).trim();
        //   String newGender = _askLabel("New Gender (leave blank to keep)",allowEmpty: true).trim();
        //   String newDob = _askLabel("New Date of Birth (leave blank to keep)", allowEmpty: true).trim();

        //   // String salaryInput = _askLabel("New Base Salary (leave blank to keep)").trim();
        //   String salaryInput = _askLabel("New Base Salary (leave blank to keep)", allowEmpty: true).trim();
        //   double? newBaseSalary = salaryInput.isNotEmpty ? double.tryParse(salaryInput) : null;

        //   hospital.editStaffInfo(
        //     staff,
        //     name: newName.isNotEmpty ? newName : null,
        //     gender: newGender.isNotEmpty ? newGender : null,
        //     dob: newDob.isNotEmpty ? newDob : null,
        //     baseSalary: newBaseSalary,
        //   );

        //   if (staff is Doctor) {
        //     stdout.writeln('\nEditing Doctor-specific info:');
        //     String newSpec = _askLabel("New specialization (leave blank to keep)", allowEmpty: true).trim();
        //     if (newSpec.isNotEmpty) {
        //       try {
        //         staff.specialization = Specialization.values.firstWhere(
        //           (s) => s.name.toLowerCase() == newSpec.toLowerCase(),
        //         );
        //       } catch (e) {
        //         stdout.writeln('Invalid specialization. Keeping existing value.');
        //       }
        //     }
        //   } else if (staff is Nurse) {
        //     stdout.writeln('\nEditing Nurse-specific info:');

        //     String expInput = _askLabel("New years of experience (leave blank to keep)", allowEmpty: true).trim();
        //     if (expInput.isNotEmpty) {
        //       int? newExp = int.tryParse(expInput);
        //       if (newExp != null) staff.yearOfExperince = newExp;
        //     }

        //     String certInput = _askLabel("New certifications (comma-separated, leave blank to keep)", allowEmpty: true).trim();
        //     if (certInput.isNotEmpty) {
        //       staff.certification = certInput
        //           .split(',')
        //           .map((c) => c.trim())
        //           .where((c) => c.isNotEmpty)
        //           .toList();
        //     }
        //   }

        //   stdout.writeln("Staff information updated!");
        //   dataManager.saveStaff(hospital.staffs);
        //   staff.printInfo();
        //   break;

        case '5':
          stdout.writeln(
              '\n\n============ EDIT STAFF INFORMATION ============\n');

          // Ask for staff ID
          String id = _askLabel("Input staff ID").trim();

          Staff? staff = hospital.searchStaffById(id);

          if (staff == null) {
            stdout.writeln('\nNo staff found with this ID.');
            break;
          }

          stdout.writeln('\n=== STAFF FOUND ===');
          staff.printInfo();

          String newName =
              _askLabel("New Name (leave blank to keep)", allowEmpty: true)
                  .trim();
          String newGender =
              _askLabel("New Gender (leave blank to keep)", allowEmpty: true)
                  .trim();
          String newDob = _askLabel("New Date of Birth (leave blank to keep)",
                  allowEmpty: true)
              .trim();

          String salaryInput = _askLabel(
                  "New Base Salary (leave blank to keep)",
                  allowEmpty: true)
              .trim();
          double? newBaseSalary =
              salaryInput.isNotEmpty ? double.tryParse(salaryInput) : null;

          hospital.editStaffInfo(
            staff,
            name: newName.isNotEmpty ? newName : null,
            gender: newGender.isNotEmpty ? newGender : null,
            dob: newDob.isNotEmpty ? newDob : null,
            baseSalary: newBaseSalary,
          );

          if (staff is Doctor && _isConfirm('Change specialization? (y/n): ')) {
            var newSpec = _askSpeacialization();
            hospital.editStaffInfo(staff, specialization: newSpec);
          } else if (staff is Nurse) {
            String expInput = _askLabel(
                    "New years of experience (leave blank to keep)",
                    allowEmpty: true)
                .trim();
            int? newExp = expInput.isNotEmpty ? int.tryParse(expInput) : null;

            String certInput = _askLabel(
                    "New certifications (comma-separated, leave blank to keep)",
                    allowEmpty: true)
                .trim();
            List<String>? newCerts = certInput.isNotEmpty
                ? certInput
                    .split(',')
                    .map((c) => c.trim())
                    .where((c) => c.isNotEmpty)
                    .toList()
                : null;

            hospital.editStaffInfo(
              staff,
              yearOfExperince: newExp,
              certifications: newCerts,
            );
          }

          stdout.writeln("\nStaff information updated!");
          dataManager.saveStaff(hospital.staffs);
          staff.printInfo();
          break;

        case '6':
          stdout.writeln('\n\n============ REMOVE STAFF ============\n');

          String id = _askLabel("Input staff ID").trim();

          Staff? staff = hospital.searchStaffById(id);

          if (staff == null) {
            stdout.writeln('\n No staff found with this ID.');
            break;
          }

          stdout.writeln('\n=== STAFF FOUND ===');
          staff.printInfo();

          if (_isConfirm('Confrim remove staff (y/n):')) {
            hospital.removeStaffById(id);
            dataManager.saveStaff(hospital.staffs);
            stdout.writeln('Staff remove successfully!');
          } else {
            stdout.write(
                '-----------------Remove Staff cancelled-----------------');
          }

          break;
        case '7':
          stdout.writeln(
              '\n\n============ RECORD STAFF ATTENDANCE ============\n');
          String id = _askLabel("Input staff ID").trim();

          Staff? staff = hospital.searchStaffById(id);

          if (staff == null) {
            stdout.writeln('\n No staff found with this ID.');
            break;
          }
          stdout.writeln('\n=== STAFF FOUND ===');
          staff.printInfo();
          stdout.writeln(
              '\nEnter attendance time details (format: yyyy-MM-dd HH:mm)');
          DateTime? start = _inputDateTime("Start time");
          DateTime? end = _inputDateTime("End time");
          if (end.isBefore(start)) {
            stdout.writeln(' End time cannot be before start time!');
            return;
          }
          hospital.recordAttendance(staff, start, end);
          dataManager.saveStaff(hospital.staffs);
          stdout.writeln('\nAttendance recorded successfully!');
          break;
        case '8':
          stdout.writeln(
              '\n\n============ CALCULATE TOTAL SALARY ============\n');
          String id = _askLabel("Input staff ID").trim();

          Staff? staff = hospital.searchStaffById(id);

          if (staff == null) {
            stdout.writeln('\n No staff found with this ID.');
            break;
          }
          stdout.writeln('\n=== STAFF FOUND ===');
          staff.printInfo();

          double totalSalary = hospital.staffTotalSalary(staff);
          stdout
              .writeln('Base Salary: \$${staff.baseSalary.toStringAsFixed(2)}');
          stdout.writeln(
              'Total Salary (with bonuses & overtime): \$${totalSalary.toStringAsFixed(2)}');
          break;

        case '9':
          stdout.writeln(
              '\n============ TOTAL SALARY OF ALL STAFF ============\n');
          if (hospital.staffs.isEmpty) {
            stdout.writeln('No staff in the system.');
            break;
          }

          double totalAllSalary = 0;
          for (var staff in hospital.staffs) {
            double totalSalary = hospital.staffTotalSalary(staff);
            totalAllSalary += totalSalary;

            stdout.writeln('ID: ${staff.staffId}');
            stdout.writeln('Name: ${staff.staffName}');
            stdout.writeln('Role: ${staff.position.name}');
            stdout.writeln('Total Salary: \$${totalSalary.toStringAsFixed(2)}');
            stdout.writeln('------------------------------------------');
          }

          stdout.writeln(
              'Total Salary for All Staff: \$${totalAllSalary.toStringAsFixed(2)}');
          break;

        case '10':
          stdout.writeln('\nLogging out...');
          return;

        default:
          stdout.writeln('Invalid choice. Try again.');
      }
    }
  }

  void authenticationInterface() {
    while (true) {
      stdout.writeln('\nWelcome to the Hospital Staff Management System!\n');
      stdout.writeln('1). Login');
      stdout.writeln('2). Exit');
      stdout.write('Please enter your choice (1 or 2): ');
      String? input = stdin.readLineSync();

      if (input == null || input.trim().isEmpty) {
        stdout.write('Error invlaid choice please choose between 1 and 2.');
        continue;
      }

      String trimmedInput = input.trim();
      int? choice = int.tryParse(trimmedInput);

      if (choice == 1) {
        //login Function but havent done it
        stdout.write('\n================Login=================\n');
        stdout.write('Please input the following field\n');
        stdout.write('Email:');
        String? inputEmail = stdin.readLineSync();
        stdout.write('\nPassword:');
        String? inputPassword = stdin.readLineSync();

        if (inputEmail == null && inputPassword == null) {
          stdout.write("Invalid input pls try again.");
          continue;
        }

        var admin = hospital.findAdminByEmail(inputEmail!.trim());

        if (admin != null &&
            admin.isAuthenticated(inputEmail, inputPassword!)) {
          stdout.write("==============Login successfully==============");
          adminDashboard(admin);
        } else {
          stdout.writeln('\nInvalid email or password. Please try again.');
        }
      } else if (choice == 2) {
        print('\nThank you for using the system. Goodbye!');
        exit(0);
      } else {
        stdout.write('Invalid input please input between choice 1 and 2');
      }
    }
  }

  void startSystem() {
    const String welcomeText = 'HOSPITAL STAFF MANAGEMENT SYSTEM';

    final fontPath = '../assets/mini.flf';
    final file = File(fontPath);
    if (!file.existsSync()) {
      stderr.writeln('Font file not found: $fontPath');
      exitCode = 2;
      return;
    }
    final String fontFileContents = file.readAsStringSync();

    final font = Font.text(fontFileContents);

    final asciiArt = FIGlet.renderFIGure(welcomeText, font);

    stdout.writeln(asciiArt);
  }

  //helper function for user input
  String _askLabel(String label, {bool allowEmpty = false}) {
    while (true) {
      stdout.write('$label: ');
      String? input = stdin.readLineSync();

      if (input == null) {
        stdout.writeln('Input cannot be null.');
        continue;
      }

      input = input.trim();

      if (input.isEmpty && !allowEmpty) {
        stdout.writeln('Please enter a value.');
        continue;
      }

      return input;
    }
  }

  double _inputSalary() {
    while (true) {
      stdout.write('Base salary: ');
      String? input = stdin.readLineSync();

      if (input == null || input.trim().isEmpty) {
        stdout.writeln('Salary cannot be empty. Please enter a valid number.');
        continue;
      }

      double? salary = double.tryParse(input.trim());
      if (salary == null || salary <= 0) {
        stdout.writeln('Invalid salary. Please enter a positive number.');
        continue;
      }

      return salary;
    }
  }
}

Role _askRole() {
  stdout.writeln('\nChoose role:');
  for (var i = 0; i < Role.values.length; i++) {
    stdout.writeln('${i + 1}). ${Role.values[i].name}');
  }

  while (true) {
    stdout.write('\nYour choice:');
    var input = stdin.readLineSync();
    var index = int.tryParse(input ?? '');
    if (index != null && index >= 1 && index <= Role.values.length) {
      return Role.values[index - 1];
    } else {
      stdout.write('Invalid role please try again');
    }
  }
}

bool _isConfirm(String prompt) {
  while (true) {
    stdout.write(prompt);
    String? input = stdin.readLineSync();
    if (input == null) continue;
    var cleanInput = input.trim().toLowerCase();
    if (cleanInput == 'y' || cleanInput == 'yes') return true;
    if (cleanInput == 'n' || cleanInput == 'n') return false;
  }
}

Specialization _askSpeacialization() {
  stdout.writeln('\nChoose specailization:');
  for (var i = 0; i < Specialization.values.length; i++) {
    stdout.writeln('${i + 1}). ${Specialization.values[i].name}');
  }

  while (true) {
    stdout.write('Your choice:');
    var input = stdin.readLineSync();
    var index = int.tryParse(input ?? '');
    if (index != null && index >= 1 && index <= Specialization.values.length) {
      return Specialization.values[index - 1];
    } else {
      stdout.write('Invalid Specialzation please try again');
    }
  }
}

DateTime _inputDateTime(String label) {
  while (true) {
    stdout.write('$label (yyyy-MM-dd HH:mm): ');
    String? input = stdin.readLineSync();

    if (input == null || input.trim().isEmpty) {
      stdout.writeln('Please enter a value.');
      continue;
    }

    try {
      return DateTime.parse(input.replaceFirst(' ', 'T'));
    } catch (e) {
      stdout.writeln('Invalid format. Example: 2025-11-03 08:30');
    }
  }
}

// void main() {
//   Hospital hospital = Hospital("TESTING");
//   Admin admin1 =
//       Admin("staffName", "gender", "Dob", 500, "admin@gmail.com", "12345678");
//   hospital.addStaff(admin1);
//   HospitalStaffConsole testConsole = HospitalStaffConsole(hospital);

//   testConsole.startSystem();
//   testConsole.authenticationInterface();
// }
