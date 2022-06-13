class StudentData{
  String name;
  String studentNumber;
  String password;
  DateTime joiningDate = DateTime.now();
  DateTime updateDate = DateTime.now();

  StudentData({required this.name, required this.studentNumber, required this.password});
}