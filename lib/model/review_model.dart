class ReviewModel {
  int id;
  int rate;
  String review;
  String fullName;
  String avatar;
  String createdAt;
  String formattedDate;

  ReviewModel({
    required this.id,
    required this.rate,
    required this.review,
    required this.fullName,
    required this.avatar,
    required this.createdAt,
    required this.formattedDate,
  });

  ReviewModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      rate = json['rate'],
      review = json['review'],
      fullName = json['full_name'],
      avatar = json['avatar'],
      createdAt = json['created_at'],
      formattedDate = json['formatted_date'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'rate': rate,
      'review': review,
      'full_name': fullName,
      'avatar': avatar,
      'created_at': createdAt,
      'formatted_date': formattedDate,
    };
  }
}
