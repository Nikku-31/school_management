class SyllabusModel {
  final int syllabusId;
  final int classId;
  final String className;
  final int subjectId;
  final String subjectName;
  final String title;
  final String remarks;
  final String attachmentFile;

  SyllabusModel({
    required this.syllabusId,
    required this.classId,
    required this.className,
    required this.subjectId,
    required this.subjectName,
    required this.title,
    required this.remarks,
    required this.attachmentFile,
  });

  factory SyllabusModel.fromJson(Map<String, dynamic> json) {
    return SyllabusModel(
      syllabusId: json['syllabusId'] ?? 0,
      classId: json['class_id'] ?? 0,
      className: json['className'] ?? "",
      subjectId: json['subject_id'] ?? 0,
      subjectName: json['subjectName'] ?? "",
      title: json['title'] ?? "",
      remarks: json['remarks'] ?? "",
      attachmentFile: json['attachmentFile'] ?? "",
    );
  }
}
