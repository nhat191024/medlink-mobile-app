class TransactionHistoryModel {
  int id;
  String type;
  int amount;
  String description;
  String date;
  DateTime dateTime;

  TransactionHistoryModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
    required this.dateTime,
  });

  TransactionHistoryModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      type = json['type'],
      description = json['description'] ?? '',
      amount = int.parse(json['amount'].toString()),
      date = json['created_at_time_human'],
      dateTime = DateTime.parse(json['created_at']);

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'description': description, 'amount': amount, 'date': date};
  }
}
