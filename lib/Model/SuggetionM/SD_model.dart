class SDModel {
  final int data;
  final List<String> messages;
  final String? message;
  final bool succeeded;

  SDModel({
    required this.data,
    required this.messages,
    required this.message,
    required this.succeeded,
  });

  factory SDModel.fromJson(Map<String, dynamic> json) {
    return SDModel(
      data: json['data'] ?? 0,
      messages: List<String>.from(json['messages'] ?? []),
      message: json['message'],
      succeeded: json['succeeded'] ?? false,
    );
  }
}