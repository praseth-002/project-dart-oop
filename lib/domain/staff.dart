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
  // constructor for read staff from file
  Staff._fromData(
    this._staffId,
    this._staffName,
    this._gender,
    this._dob,
    this._position,
    this._baseSalary,
  );

  // Getters & Setters
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
  Map<String, dynamic> toJson() => {
        'type': 'Staff',
        'staffId': _staffId,
        'staffName': _staffName,
        'gender': _gender,
        'dob': _dob,
        'position': _position.name,
        'baseSalary': _baseSalary,
        'attendance': _attendance.map((a) => a.toJson()).toList(),
      };

  factory Staff.fromJson(Map<String, dynamic> json) {
    var staff = Staff._fromData(
      json['staffId'],
      json['staffName'],
      json['gender'],
      json['dob'],
      Role.values.firstWhere((r) => r.name == json['position']),
      (json['baseSalary'] as num).toDouble(),
    );

    if (json['attendance'] != null) {
      staff.attendance.addAll(
          (json['attendance'] as List).map((a) => Attendance.fromJson(a)));
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
  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data['type'] = 'Doctor';
    data['specialization'] = specialization.name;
    return data;
  }

  factory Doctor.fromJson(Map<String, dynamic> json) {
    var doc = Doctor._fromData(
      json['staffId'],
      json['staffName'],
      json['gender'],
      json['dob'],
      (json['baseSalary'] as num).toDouble(),
      Specialization.values.firstWhere((s) => s.name == json['specialization']),
    );

    if (json['attendance'] != null) {
      doc.attendance.addAll(
          (json['attendance'] as List).map((a) => Attendance.fromJson(a)));
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
    print('Certifications: ${certification.isEmpty ? "None" : certification.join(", ")}');
    print('Years of Experience: $yearOfExperince');
  }

  @override
  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data['type'] = 'Nurse';
    data['certification'] = certification;
    data['yearOfExperince'] = yearOfExperince;
    return data;
  }

  factory Nurse.fromJson(Map<String, dynamic> json) {
    var nurse = Nurse._fromData(
      json['staffId'],
      json['staffName'],
      json['gender'],
      json['dob'],
      (json['baseSalary'] as num).toDouble(),
      yearOfExperince: json['yearOfExperince'] ?? 0,
    );

    nurse.certification = List<String>.from(json['certification'] ?? []);

    if (json['attendance'] != null) {
      nurse.attendance.addAll(
          (json['attendance'] as List).map((a) => Attendance.fromJson(a)));
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
  Map<String, dynamic> toJson() {
    var data = super.toJson();
    data['type'] = 'Admin';
    data['email'] = email;
    data['password'] = password;
    return data;
  }

  factory Admin.fromJson(Map<String, dynamic> json) {
    var admin = Admin._fromData(
      json['staffId'],
      json['staffName'],
      json['gender'],
      json['dob'],
      (json['baseSalary'] as num).toDouble(),
      json['email'],
      json['password'],
    );

    if (json['attendance'] != null) {
      admin.attendance.addAll(
          (json['attendance'] as List).map((a) => Attendance.fromJson(a)));
    }

    return admin;
  }
}


// import 'package:hospital_management/domain/attendance.dart';
// import 'package:uuid/uuid.dart';
// enum Role {Doctor, Nurse, Receptionist, Admin}
// enum Specialization {General, Pediatrician, Surgeon}

// var uuid = Uuid();
// class Staff {
//   final String _staffId;
//   String _staffName;
//   String _gender;
//   String _dob;
//   Role _position;
//   double _baseSalary;
//   final List<Attendance> _attendance = [];

//   Staff (this._staffName, this._gender, this._dob, this._position, this._baseSalary) : _staffId = uuid.v4();

//   //Getter function
//   String get staffId => _staffId;
//   String get staffName => _staffName;
//   String get gender => _gender;
//   String get dob => _dob;
//   Role get position => _position;
//   double get baseSalary => _baseSalary;
//   List<Attendance> get attendance => _attendance;

//   //Setter 
//   set staffName(String name) => _staffName = name;
//   set gender(String g) => _gender = g;
//   set dob(String d) => _dob = d;
//   set position(Role p) => _position = p;
//   set baseSalary(double value) => _baseSalary = value;

//   void printInfo() {
//     print('------------------------------------------');
//     print('ID: $_staffId');
//     print('Name: $_staffName');
//     print('Gender: $_gender');
//     print('DOB: $_dob');
//     print('Role: ${_position.name}');
//     print('Base Salary: \$${_baseSalary.toStringAsFixed(2)}');
//   }

//   @override  
//   String toString() {
//     return " staffId:$_staffId\nname:$_staffName\ngender:$_gender\ndob:$_dob\nposition:$_position\nbaseSalary:$_baseSalary\nattendance:$_attendance";
//   }
// }

// class Doctor extends Staff {
//   Specialization specialization;

//   Doctor(
//     String staffName,
//     String gender,
//     String dob,
//     double baseSalary,
//     this.specialization,
//   ) : super(staffName, gender, dob, Role.Doctor, baseSalary);

//   @override
//   void printInfo() {
//     super.printInfo();
//     print('Specialization: ${specialization.name}');
//   }
// }

// class Nurse extends Staff {
//   List<String> certification =[];
//   int yearOfExperince;

//   Nurse(
//     String staffName,
//     String gender,
//     String dob,
//     double baseSalary, 
//     {this.yearOfExperince = 0}) : super (staffName, gender, dob, Role.Nurse, baseSalary);

//     @override
//   void printInfo() {
//     super.printInfo();
//     print('Certifications: ${certification.isEmpty ? "None" : certification.join(", ")}');
//     print('Years of Experience: $yearOfExperince');
//   }
// }

// class Admin extends Staff {
//   String email;
//   String password;

//   Admin(
//     String staffName,
//     String gender,
//     String dob,
//     double baseSalary,
//     this.email, 
//     this.password) : super (staffName, gender, dob, Role.Admin, baseSalary);

//     bool isAuthenticated (String inputEmail, String inputPassword) {
//       return email == inputEmail && password == inputPassword;
//     }

//     @override
//   void printInfo() {
//     super.printInfo();
//     print('Email: $email');
//   }
// }