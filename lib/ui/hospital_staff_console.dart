// bin/hospital_staff_console.dart  (or wherever your entrypoint is)
import 'dart:io';
import 'package:enough_ascii_art/enough_ascii_art.dart';
import 'package:hospital_management/domain/staff.dart';
import '../domain/hospital.dart';


class HospitalStaffConsole {
  final Hospital hospital;

  HospitalStaffConsole(this.hospital);

void adminDashboard(Admin admin) {
  while (true) {
    stdout.writeln('\n============ ADMIN DASHBOARD ============');
    stdout.writeln('1). Add new staff');
    stdout.writeln('2). View all staff');
    stdout.writeln('3). View staff by role');
    stdout.writeln('4). Search staff by name or Id');
    stdout.writeln('5). Edit staff information');
    stdout.writeln('6). Remove staff');
    stdout.writeln('7). Logout');
    stdout.writeln('=========================================');
    stdout.write('Please select an option: ');
    String? input = stdin.readLineSync();

    switch (input) {
      case '1':
        stdout.writeln('\nAdd new staff:');
        stdout.writeln('\nPlease input the following staff information:');
        var name = _askLabel('Name');
        var gender = _askLabel('Gender');
        var dob = _askLabel('Date of Birth (DD/MM/YYYY):');
        var salary = _inputSalary();
        var role = _askRole();

        if(role == Role.Admin) {
          var email = _askLabel('Email');
          var password = _askLabel('Password');
          hospital.addStaff(Admin(name, gender, dob, salary, email, password));
          stdout.writeln('Admin added successfully!');
        }else if(role == Role.Doctor) {
          var specialization = _askSpeacialization();
          hospital.addStaff(Doctor(name, gender, dob, salary,specialization));
          stdout.writeln('Doctor added successfully!');
        }else if(role == Role.Nurse) {
          hospital.addStaff(Nurse(name, gender, dob, salary));
          stdout.writeln('Nurse added successfully!');
        }
        break;

      case '2':
        for (var s in hospital.staffs) {
          print('ID: ${s.staffId} | Name: ${s.staffName}');
        }
        break;

      case '3':
        
        break;

      case '7':
        stdout.writeln('\nLogging out...');
        return;

      default:
        stdout.writeln('❌ Invalid choice. Try again.');
    }
  }
}


  void authenticationInterface(){
    while (true) {
    stdout.writeln('\nWelcome to the Hospital Staff Management System!\n');
    stdout.writeln('1). Login');
    stdout.writeln('2). Exit');
    stdout.write('Please enter your choice (1 or 2): ');
    String? input = stdin.readLineSync();  

    if  (input == null || input.trim().isEmpty) {
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

      
      if (inputEmail == null && inputPassword == null){
        stdout.write("Invalid input pls try again.");
        continue;
      }

      

      var admin = hospital.findAdminByEmail(inputEmail!.trim());

      if (admin != null && admin.isAuthenticated(inputEmail, inputPassword!)){
        stdout.write("==============Login successfully==============");
        adminDashboard(admin);
      }else{
        stdout.writeln('\n❌ Invalid email or password. Please try again.');
      }

    }else if (choice == 2) {
      print('\nThank you for using the system. Goodbye!');
      exit(0);
    }else{
      stdout.write('Invalid input please input between choice 1 and 2');
    }

  }
  }

  void startSystem() {
    const String welcomeText = 'HOSPITAL STAFF MANAGEMENT SYSTEM';


    final fontPath = '../../assets/mini.flf';
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
    stdout.writeln('\nWelcome to the Hospital Staff Management System!\n');

  }

  //helper function for user input 
  String _askLabel (String label){
    stdout.write('$label');
    return stdin.readLineSync()?.trim() ?? '';
  }

  double _inputSalary () {
    while(true){
      stdout.write("Base salary:");
      var input = stdin.readLineSync();
      var salary = double.tryParse(input ?? '');
      if(salary != null || salary! > 0){
        return salary;
      }else{
        stdout.write("Invalid salary pls try again");
      }
    }
  }

  Role _askRole() {
    stdout.writeln('Choose role:');
    for (var i = 0; i < Role.values.length; i++) {
      stdout.writeln('${i + 1}). ${Role.values[i].name}');
    }

    while (true) {
      stdout.write('Your choice:');
      var input = stdin.readLineSync();
      var index = int.tryParse(input ?? '');
      if (index != null && index >= 1 && index <= Role.values.length) {
        return Role.values[index - 1];
      }else{
        stdout.write('Invalid role please try again');
      }
    }
  }

  Specialization _askSpeacialization() {
    stdout.writeln('Choose specailization:');
    for (var i = 0; i < Specialization.values.length; i++) {
      stdout.writeln('${i + 1}). ${Specialization.values[i].name}');
    }

    while (true) {
      stdout.write('Your choice:');
      var input = stdin.readLineSync();
      var index = int.tryParse(input ?? '');
      if (index != null && index >= 1 && index <= Specialization.values.length) {
        return Specialization.values[index - 1];
      }else{
        stdout.write('Invalid Specialzation please try again');
      }
    }
  }

}



void main() {
  Hospital hospital = Hospital("TESTING");
  Admin admin1 =Admin("staffName", "gender", "Dob", 12334, "admin@gmail.com", "12345678");
  hospital.addStaff(admin1);
  HospitalStaffConsole testConsole = HospitalStaffConsole(hospital);

  testConsole.startSystem();
  testConsole.authenticationInterface();
}
