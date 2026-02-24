class SRequestModel {
  final int createdBy;
  final String createdDate;
  final int modifiedBy;
  final String modifiedDate;
  final int suggestionId;
  final int appNo;
  final String date;
  final String title;
  final String category;
  final String remarks;

  SRequestModel({
    required this.createdBy,
    required this.createdDate,
    required this.modifiedBy,
    required this.modifiedDate,
    required this.suggestionId,
    required this.appNo,
    required this.date,
    required this.title,
    required this.category,
    required this.remarks,
  });

  Map<String, dynamic> toJson() {
    return {
      "created_by": createdBy,
      "created_date": createdDate,
      "modified_by": modifiedBy,
      "modified_date": modifiedDate,
      "suggestionId": suggestionId,
      "appNo": appNo,
      "date": date,
      "title": title,
      "category": category,
      "remarks": remarks,
    };
  }
}