// bin/hospital_staff_console.dart  (or wherever your entrypoint is)
import 'dart:io';
import 'package:enough_ascii_art/enough_ascii_art.dart';
import '../domain/hospital.dart';

class HospitalStaffConsole {
  final Hospital hospital;

  HospitalStaffConsole(this.hospital);

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
      stdout.write('================Login=================\n');
      stdout.write('Please input the following field\n');
      stdout.write('Email:');
      String? inputEmail = stdin.readLineSync();
      stdout.write('\nPassword:');
      String? inputPassword = stdin.readLineSync();
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
}



void main() {
  Hospital hospital = Hospital("TESTING");

  HospitalStaffConsole testConsole = HospitalStaffConsole(hospital);

  testConsole.startSystem();
  testConsole.authenticationInterface();
}
