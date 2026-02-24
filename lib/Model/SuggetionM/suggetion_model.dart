class SuggetionModel {
  final int suggestionId;
  final int appNo;
  final DateTime date;
  final String title;
  final String category;
  final String remarks;
  final int createdBy;
  final DateTime createdDate;
  final int modifiedBy;
  final DateTime? modifiedDate;

  SuggetionModel({
    required this.suggestionId,
    required this.appNo,
    required this.date,
    required this.title,
    required this.category,
    required this.remarks,
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    this.modifiedDate,
  });

  factory SuggetionModel.fromJson(Map<String, dynamic> json) {
    return SuggetionModel(
      suggestionId: json['suggestionId'] ?? 0,
      appNo: json['appNo'] ??0,
      date: DateTime.parse(json['date']),
      title: json['title'] ?? '',
      category: json['category'] ?? '',
      remarks: json['remarks'] ?? '',
      createdBy: json['created_by'] ?? 0,
      createdDate: DateTime.parse(json['created_date']),
      modifiedBy: json['modified_by'] ?? 0,
      modifiedDate: json['modified_date'] == null ||
          json['modified_date'] == "0001-01-01T00:00:00"
          ? null
          : DateTime.parse(json['modified_date']),
    );
  }
}