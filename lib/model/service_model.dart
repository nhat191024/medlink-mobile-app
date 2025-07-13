class ServiceModel {
  int id;
  String icon;
  String name;
  String description;
  int price;
  int duration;
  int bufferTime;
  String seat;
  bool isActive;

  ServiceModel({
    required this.id,
    required this.icon,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.bufferTime,
    required this.seat,
    required this.isActive,
  });

  ServiceModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      icon = json['icon'],
      name = json['name'],
      description = json['description'],
      price = json['price'],
      duration = json['duration'],
      bufferTime = json['buffer_time'],
      seat = json['seat'],
      isActive = json['is_active'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'icon': icon,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'buffer_time': bufferTime,
      'seat': seat,
      'is_active': isActive,
    };
  }
}
