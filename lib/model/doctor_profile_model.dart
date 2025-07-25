import 'package:medlink/utils/app_imports.dart';

class DoctorProfileModel {
  int id;
  String phone;
  String userType;
  String email;
  String identity;
  String latitude;
  String longitude;
  String name;
  String gender;
  String avatar;
  String address;
  String country;
  String city;
  String state;
  String zipCode;
  String status;
  int doctorProfileId;
  String professionalNumber;
  String introduce;
  String medicalCategory;
  String officeAddress;
  String companyName;
  double profileCompleteness;
  bool isAvailable;

  DoctorProfileModel({
    required this.id,
    required this.phone,
    required this.userType,
    required this.email,
    required this.identity,
    required this.latitude,
    required this.longitude,
    required this.name,
    required this.gender,
    required this.avatar,
    required this.address,
    required this.country,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.status,
    required this.doctorProfileId,
    required this.professionalNumber,
    required this.introduce,
    required this.medicalCategory,
    required this.officeAddress,
    required this.companyName,
    required this.profileCompleteness,
    required this.isAvailable,
  });

  DoctorProfileModel.fromJson(Map<String, dynamic> json)
    : id = json['profile']['id'],
      phone = json['profile']['phone'] ?? 'not_setup'.tr,
      userType = json['profile']['userType'],
      email = json['profile']['email'],
      identity = json['profile']['identity'] ?? 'not_setup'.tr,
      latitude = json['profile']['latitude'] ?? 'not_setup'.tr,
      longitude = json['profile']['longitude'] ?? 'not_setup'.tr,
      name = json['profile']['name'] ?? 'not_setup'.tr,
      gender = json['profile']['gender'] ?? 'not_setup'.tr,
      avatar = json['profile']['avatar'],
      address = json['profile']['address'] ?? 'not_setup'.tr,
      country = json['profile']['country'] ?? 'not_setup'.tr,
      city = json['profile']['city'] ?? 'not_setup'.tr,
      state = json['profile']['state'] ?? 'not_setup'.tr,
      zipCode = json['profile']['zipCode'] ?? 'not_setup'.tr,
      status = json['profile']['status'],
      doctorProfileId = json['profile']['doctorProfileId'],
      professionalNumber = json['profile']['professionalNumber'],
      introduce = json['profile']['introduce'] ?? 'not_setup'.tr,
      medicalCategory = json['profile']['medicalCategory']['name'],
      officeAddress = json['profile']['officeAddress'] ?? 'not_setup'.tr,
      companyName = json['profile']['companyName'] ?? 'not_setup'.tr,
      profileCompleteness = (json['profile']['profileCompleteness'] as num).toDouble(),
      isAvailable = json['isAvailable'];


  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'user_type': userType,
      'email': email,
      'identity': identity,
      'latitude': latitude,
      'longitude': longitude,
      'name': name,
      'gender': gender,
      'avatar': avatar,
      'address': address,
      'country': country,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'status': status,
      'doctor_profile_id': doctorProfileId,
      'professional_number': professionalNumber,
      'introduce': introduce,
      'medical_category': medicalCategory,
      'office_address': officeAddress,
      'company_name': companyName,
      'profile_completeness': profileCompleteness,
      'is_available': isAvailable,
    };
  }
}
