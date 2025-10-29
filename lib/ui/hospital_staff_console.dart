// bin/hospital_staff_console.dart  (or wherever your entrypoint is)
import 'dart:io';
import 'package:enough_ascii_art/enough_ascii_art.dart';
import '../domain/hospital.dart';

class HospitalStaffConsole {
  final Hospital hospital;

  HospitalStaffConsole(this.hospital);


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
}
