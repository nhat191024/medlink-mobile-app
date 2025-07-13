class TopReviewModel {
  int id;
  double rate;
  String review;
  String name;
  String avatar;
  String createdAt;

  TopReviewModel({
    required this.id,
    required this.rate,
    required this.review,
    required this.name,
    required this.avatar,
    required this.createdAt,
  });

  TopReviewModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      rate = (json['rate'] as num).toDouble(),
      review = json['review'],
      name = json['name'],
      avatar = json['avatar'],
      createdAt = json['created_at'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'review': review,
      'name': name,
      'avatar': avatar,
      'created_at': createdAt,
    };
  }
}
