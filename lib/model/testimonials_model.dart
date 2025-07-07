class TestimonialsModel {
  int? start;
  String? title;
  int? total;
  String? fraction;

  TestimonialsModel({this.start, this.title, this.total, this.fraction});

  TestimonialsModel.fromJson(Map<String, dynamic> json) {
    start = json['start'];
    title = json['title'];
    total = json['total'];
    fraction = json['fraction'];
  }

  Map<String, dynamic> toJson() {
    return {'start': start, 'title': title, 'total': total, 'fraction': fraction};
  }
}
