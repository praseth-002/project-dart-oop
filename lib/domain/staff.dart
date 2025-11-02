import 'package:uuid/uuid.dart';
enum Role {Doctor, Nurse, Receptionist, Admin}
enum Specialization {General, Pediatrician, Surgeon}

var uuid = Uuid();
class Staff {
  final String _staffId;
  String _staffName;
  String _gender;
  String _dob;
  Role _position;
  double _baseSalary;
  // shift idk how to implement yet TBC

  Staff (this._staffName, this._gender, this._dob, this._position, this._baseSalary) : _staffId = uuid.v4();

  //Getter function
  String get staffId => _staffId;
  String get staffName => _staffName;
  String get gender => _gender;
  String get dob => _dob;
  Role get position => _position;
  double get baseSalary => _baseSalary;

  //Setter 
  set staffName(String name) => _staffName = name;
  set gender(String g) => _gender = g;
  set dob(String d) => _dob = d;
  set position(Role p) => _position = p;
  set baseSalary(double value) => _baseSalary = value;

  @override  
  String toString() {
    return " staffId:$_staffId\nname:$_staffName\ngender:$_gender\ndob:$_dob\nposition:$_position\nbaseSalary:$_baseSalary";
  }
}

class Doctor extends Staff {
  Specialization specialization;

  Doctor(
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.specialization,
  ) : super(staffName, gender, dob, Role.Doctor, baseSalary);
}

class Nurse extends Staff {
  List<String> certification =[];
  int yearOfExperince;

  Nurse(
    String staffName,
    String gender,
    String dob,
    double baseSalary, 
    {this.yearOfExperince = 0}) : super (staffName, gender, dob, Role.Nurse, baseSalary);
}

class Admin extends Staff {
  String email;
  String password;

  Admin(
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.email, 
    this.password) : super (staffName, gender, dob, Role.Admin, baseSalary);

    bool isAuthenticated (String inputEmail, String inputPassword) {
      return email == inputEmail && password == inputPassword;
    }
}