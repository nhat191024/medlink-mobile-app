import 'package:get/get.dart';
import 'package:medlink/model/language_model.dart';
import 'package:medlink/model/service_model.dart';
import 'package:medlink/model/testimonials_model.dart';
import 'package:medlink/model/top_review_model.dart';
import 'package:medlink/model/work_schedule_model.dart';

class DoctorModel {
  int? id;
  int? doctorProfileId;
  String? avatar;
  String? name;
  String? specialty;
  String? introduce;
  bool? isPopular;
  double? rating;
  int? totalRate;
  String? location;
  int? minPrice;
  bool? isAvailable;
  RxBool? isFavorite;
  List<LanguageModel>? languages;
  List<ServiceModel>? services;
  String? longitude;
  String? latitude;
  List<TestimonialsModel>? testimonials;
  List<TopReviewModel>? topReviews;
  WorkScheduleModel? workSchedule;

  DoctorModel({
    required this.id,
    required this.doctorProfileId,
    required this.avatar,
    required this.name,
    required this.specialty,
    required this.introduce,
    required this.isPopular,
    required this.rating,
    required this.totalRate,
    required this.location,
    required this.minPrice,
    required this.isAvailable,
    required this.isFavorite,
    required this.languages,
    required this.services,
    required this.longitude,
    required this.latitude,
    required this.testimonials,
    required this.topReviews,
    required this.workSchedule,
  });

  DoctorModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    doctorProfileId = json['doctor_profile_id'];
    avatar = json['avatar'];
    name = json['name'];
    specialty = json['specialty'];
    introduce = json['introduce'];
    isPopular = json['is_popular'];
    rating = json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0;
    totalRate = json['total_rate'];
    location = json['location'];
    minPrice = json['min_price'];
    isAvailable = json['is_available'];
    isFavorite = RxBool(json['is_favorite']);
    languages = List<LanguageModel>.from(
      json['languages']?.map((x) => LanguageModel.fromJson(x)) ?? [],
    );
    services = List<ServiceModel>.from(
      json['services']?.map((x) => ServiceModel.fromJson(x)) ?? [],
    );
    longitude = json['longitude'];
    latitude = json['latitude'];
    testimonials = List<TestimonialsModel>.from(
      json['testimonials']?.map((x) => TestimonialsModel.fromJson(x)) ?? [],
    );
    topReviews = List<TopReviewModel>.from(
      json['top_reviews']?.map((x) => TopReviewModel.fromJson(x)) ?? [],
    );
    workSchedule = json['work_schedule'] != null
        ? WorkScheduleModel.fromJson(json['work_schedule'])
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_profile_id': doctorProfileId,
      'avatar': avatar,
      'name': name,
      'specialty': specialty,
      'introduce': introduce,
      'is_popular': isPopular,
      'rating': rating,
      'total_rate': totalRate,
      'location': location,
      'min_price': minPrice,
      'is_available': isAvailable,
      'is_favorite': isFavorite,
      'languages': languages,
      'services': services,
      'longitude': longitude,
      'latitude': latitude,
      'testimonials': testimonials,
      'top_reviews': topReviews,
    };
  }
}
