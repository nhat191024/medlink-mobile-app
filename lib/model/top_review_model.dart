class TopReviewModel {
  int? id;
  double? rate;
  String? review;
  String? name;
  String? avatar;
  String? createdAt;

  TopReviewModel({this.id, this.rate, this.review, this.name, this.avatar, this.createdAt});

  TopReviewModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    rate = json['rate'] != null ? (json['rate'] as num).toDouble() : 0.0;
    review = json['review'];
    name = json['name'];
    avatar = json['avatar'];
    createdAt = json['created_at'];
  }

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
