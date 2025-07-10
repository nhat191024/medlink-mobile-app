class PaymentMethodModel {
  String name;
  String id;
  String icon;
  String info;
  String provider;
  String? expiry;
  bool isCard;

  PaymentMethodModel({
    required this.name,
    required this.id,
    required this.icon,
    required this.info,
    required this.provider,
    this.expiry,
    this.isCard = false,
  });

  PaymentMethodModel.fromJson(Map<String, dynamic> json)
    : name = json['name'],
      id = json['id'],
      icon = json['icon'],
      info = json['info'],
      provider = json['provider'],
      expiry = json['expiry'],
      isCard = json['is_card'];

  Map<String, dynamic> toJson() {
    return {'name': name, 'icon': icon, 'info': info, 'provider': provider, 'expiry': expiry};
  }
}
