enum Role {Doctor, Nurse, Receptionist}
enum Specialization {General, Pediatrician, Surgeon}

class Staff {
  String staffId;
  String staffName;
  String gender;
  String dob;
  Role position;
  double baseSalary;
  // shift idk how to implement yet TBC

  Staff(this.staffId, this.staffName, this.gender, this.dob, this.position, this.baseSalary);

  @override  
  String toString() {
    return "$staffId $staffName $gender $dob $position $baseSalary";
  }
}

class Doctor extends Staff {
  Specialization specialization;

  Doctor(
    String staffId,
    String staffName,
    String gender,
    String dob,
    double baseSalary,
    this.specialization,
  ) : super(staffId, staffName, gender, dob, Role.Doctor, baseSalary);
}
