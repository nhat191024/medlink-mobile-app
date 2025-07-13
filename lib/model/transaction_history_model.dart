class TransactionHistoryModel {
  int id;
  int type; // 1: income, 2: expense
  String name;
  double amount;
  String date;

  TransactionHistoryModel({
    required this.id,
    required this.type,
    required this.name,
    required this.amount,
    required this.date,
  });

  TransactionHistoryModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      type = json['type'],
      name = json['name'],
      amount = json['amount'].toDouble(),
      date = json['date'];

  Map<String, dynamic> toJson() {
    return {'id': id, 'type': type, 'name': name, 'amount': amount, 'date': date};
  }
}
