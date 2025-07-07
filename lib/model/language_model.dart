class LanguageModel {
  String? code;
  String? name;

  LanguageModel({this.code, this.name});

  LanguageModel.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {'code': code, 'name': name};
  }
}
