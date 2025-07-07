import 'package:get/get.dart';

class HospitalModel {
  final String avatar;
  final String name;
  final String address;
  final double rating;
  final bool isAvailable;
  final RxBool isFavorite;

  HospitalModel({
    required this.avatar,
    required this.name,
    required this.address,
    required this.rating,
    required this.isAvailable,
    required this.isFavorite,
  });

  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      isAvailable: json['is_available'] ?? false,
      isFavorite: RxBool(json['is_favorite'] ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'address': address,
      'rating': rating,
      'is_available': isAvailable,
      'is_favorite': isFavorite.value,
    };
  }
}

class PharmacyModel {
  final String avatar;
  final String name;
  final String address;
  final double rating;
  final bool isAvailable;
  final RxBool isFavorite;

  PharmacyModel({
    required this.avatar,
    required this.name,
    required this.address,
    required this.rating,
    required this.isAvailable,
    required this.isFavorite,
  });

  factory PharmacyModel.fromJson(Map<String, dynamic> json) {
    return PharmacyModel(
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      rating: double.tryParse(json['rating'].toString()) ?? 0.0,
      isAvailable: json['is_available'] ?? false,
      isFavorite: RxBool(json['is_favorite'] ?? false),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avatar': avatar,
      'name': name,
      'address': address,
      'rating': rating,
      'is_available': isAvailable,
      'is_favorite': isFavorite.value,
    };
  }
}

class AmbulanceModel {
  final String name;
  final String address;
  final String phone;

  AmbulanceModel({
    required this.name,
    required this.address,
    required this.phone,
  });

  factory AmbulanceModel.fromJson(Map<String, dynamic> json) {
    return AmbulanceModel(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
    };
  }
}