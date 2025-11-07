import 'package:hospital_management/domain/attendance.dart';
import 'package:uuid/uuid.dart';

enum Role { Doctor, Nurse, Receptionist, Admin }
enum Specialization { General, Pediatrician, Surgeon }

var uuid = Uuid();

class Staff {
  final String _staffId;
  String _staffName;
  String _gender;
  String _dob;
  Role _position;
  double _baseSalary;
  final List<Attendance> _attendance = [];

  Staff(
    this._staffName,
    this._gender,
    this._dob,
    this._position,
    this._baseSalary,
  ) : _staffId = uuid.v4();

  // constructor for loading from JSON file
  Staff._fromData(
    this._staffId,
    this._staffName,
    this._gender,
    this._dob,
    this._position,
    this._baseSalary,
  );

  // Getters & setters
  String get staffId => _staffId;
  String get staffName => _staffName;
  String get gender => _gender;
  String get dob => _dob;
  Role get position => _position;
  double get baseSalary => _baseSalary;
  List<Attendance> get attendance => _attendance;

  set staffName(String name) => _staffName = name;
  set gender(String g) => _gender = g;
  set dob(String d) => _dob = d;
  set position(Role p) => _position = p;
  set baseSalary(double value) => _baseSalary = value;

  void printInfo() {
    print('------------------------------------------');
    print('ID: $_staffId');
    print('Name: $_staffName');
    print('Gender: $_gender');
    print('DOB: $_dob');
    print('Role: ${_position.name}');
    print('Base Salary: \$${_baseSalary.toStringAsFixed(2)}');
  }

  @override
  String toString() => toJson().toString();

  // JSON serialization
  Map<String, Object> toJson() => {
        'type': 'Staff',
        'staffId': _staffId,
        'staffName': _staffName,
        'gender': _gender,
        'dob': _dob,
        'position': _position.name,
        'baseSalary': _baseSalary,
        'attendance': _attendance.map((a) => a.toJson()).toList(),
      };

  factory Staff.fromJson(Map<String, Object> json) {
    var staff = Staff._fromData(
      json['staffId'] as String,
      json['staffName'] as String,
      json['gender'] as String,
      json['dob'] as String,
      Role.values.firstWhere((r) => r.name == (json['position'] as String)),
      (json['baseSalary'] as num).toDouble(),
    );

    if (json['attendance'] != null) {
      staff.attendance.addAll(
          ((json['attendance'] as List<Object>)
                  .map((a) => Attendance.fromJson(a as Map<String, Object>)))
              .toList());
    }

    return staff;
  }
}

// ----------------------------- Doctor -----------------------------
class Doctor extends Staff {
  Specialization specialization;

  Doctor(
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.specialization,
  ) : super(staffName, gender, dob, Role.Doctor, baseSalary);

  Doctor._fromData(
    String staffId,
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.specialization,
  ) : super._fromData(staffId, staffName, gender, dob, Role.Doctor, baseSalary);

  @override
  void printInfo() {
    super.printInfo();
    print('Specialization: ${specialization.name}');
  }

  @override
  Map<String, Object> toJson() {
    var data = super.toJson();
    data['type'] = 'Doctor';
    data['specialization'] = specialization.name;
    return data;
  }

  factory Doctor.fromJson(Map<String, Object> json) {
    var doc = Doctor._fromData(
      json['staffId'] as String,
      json['staffName'] as String,
      json['gender'] as String,
      json['dob'] as String,
      (json['baseSalary'] as num).toDouble(),
      Specialization.values
          .firstWhere((s) => s.name == (json['specialization'] as String)),
    );

    if (json['attendance'] != null) {
      doc.attendance.addAll(
          ((json['attendance'] as List<Object>)
                  .map((a) => Attendance.fromJson(a as Map<String, Object>)))
              .toList());
    }

    return doc;
  }
}

// ----------------------------- Nurse -----------------------------
class Nurse extends Staff {
  List<String> certification = [];
  int yearOfExperince;

  Nurse(
    String staffName,
    String gender,
    String dob,
    double baseSalary, {
    this.yearOfExperince = 0,
  }) : super(staffName, gender, dob, Role.Nurse, baseSalary);

  Nurse._fromData(
    String staffId,
    String staffName,
    String gender,
    String dob,
    double baseSalary, {
    this.yearOfExperince = 0,
    List<String>? certifications,
  }) : super._fromData(staffId, staffName, gender, dob, Role.Nurse, baseSalary) {
    if (certifications != null) this.certification = certifications;
  }

  @override
  void printInfo() {
    super.printInfo();
    print(
        'Certifications: ${certification.isEmpty ? "None" : certification.join(", ")}');
    print('Years of Experience: $yearOfExperince');
  }

  @override
  Map<String, Object> toJson() {
    var data = super.toJson();
    data['type'] = 'Nurse';
    data['certification'] = certification;
    data['yearOfExperince'] = yearOfExperince;
    return data;
  }

  factory Nurse.fromJson(Map<String, Object> json) {
    var nurse = Nurse._fromData(
      json['staffId'] as String,
      json['staffName'] as String,
      json['gender'] as String,
      json['dob'] as String,
      (json['baseSalary'] as num).toDouble(),
      yearOfExperince: json['yearOfExperince'] != null
          ? (json['yearOfExperince'] as num).toInt()
          : 0,
    );

    nurse.certification =
        (json['certification'] as List<Object>? ?? []).cast<String>();

    if (json['attendance'] != null) {
      nurse.attendance.addAll(
          ((json['attendance'] as List<Object>)
                  .map((a) => Attendance.fromJson(a as Map<String, Object>)))
              .toList());
    }

    return nurse;
  }
}

// ----------------------------- Admin -----------------------------
class Admin extends Staff {
  String email;
  String password;

  Admin(
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.email,
    this.password,
  ) : super(staffName, gender, dob, Role.Admin, baseSalary);

  Admin._fromData(
    String staffId,
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.email,
    this.password,
  ) : super._fromData(staffId, staffName, gender, dob, Role.Admin, baseSalary);

  bool isAuthenticated(String inputEmail, String inputPassword) =>
      email == inputEmail && password == inputPassword;

  @override
  void printInfo() {
    super.printInfo();
    print('Email: $email');
  }

  @override
  Map<String, Object> toJson() {
    var data = super.toJson();
    data['type'] = 'Admin';
    data['email'] = email;
    data['password'] = password;
    return data;
  }

  factory Admin.fromJson(Map<String, Object> json) {
    var admin = Admin._fromData(
      json['staffId'] as String,
      json['staffName'] as String,
      json['gender'] as String,
      json['dob'] as String,
      (json['baseSalary'] as num).toDouble(),
      json['email'] as String,
      json['password'] as String,
    );

    if (json['attendance'] != null) {
      admin.attendance.addAll(
          ((json['attendance'] as List<Object>)
                  .map((a) => Attendance.fromJson(a as Map<String, Object>)))
              .toList());
    }

    return admin;
  }
}


