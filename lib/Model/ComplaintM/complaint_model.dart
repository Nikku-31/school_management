class ComplaintModel {
  final int? complaintId;
  final int? studentId;
  final String? complaintText;
  final String? complaintDate;
  final String? status;

  ComplaintModel({
    this.complaintId,
    this.studentId,
    this.complaintText,
    this.complaintDate,
    this.status,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      complaintId: json['complaintId'],
      studentId: json['studentId'],
      complaintText: json['complaintText'],
      complaintDate: json['complaintDate'],
      status: json['status'],
    );
  }
}