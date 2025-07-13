class TestimonialsModel {
  int star;
  String title;
  int total;
  String fraction;

  TestimonialsModel({
    required this.star,
    required this.title,
    required this.total,
    required this.fraction,
  });

  TestimonialsModel.fromJson(Map<String, dynamic> json)
    : star = json['star'],
      title = json['title'],
      total = json['total'],
      fraction = json['fraction'];

  Map<String, dynamic> toJson() {
    return {'start': star, 'title': title, 'total': total, 'fraction': fraction};
  }
}
