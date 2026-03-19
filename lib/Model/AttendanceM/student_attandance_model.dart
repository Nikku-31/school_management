class StudentAttendanceStatusModel {
  final DateTime date;
  final String status;

  StudentAttendanceStatusModel({
    required this.date,
    required this.status,
  });

  factory StudentAttendanceStatusModel.fromJson(Map<String, dynamic> json) {
    return StudentAttendanceStatusModel(
      date: DateTime.parse(json['date']),
      status: json['status'],
    );
  }
}