import 'package:medlink/utils/app_imports.dart';

class UserProfileModel {
  final int id;
  final String phone;
  final String email;
  final String userType;
  final String name;
  final String gender;
  String avatar;
  final String address;
  final String country;
  final String city;
  final String state;
  final String zipCode;
  final String status;

  // Patient specific fields
  final int? patientProfileId;
  final String? gps;
  final String? birthDate;
  final int? age;
  final int? height;
  final int? weight;
  final String? bloodGroup;
  final String? medicalHistory;
  final String? insuranceType;
  final String? insuranceNumber;
  final String? insuranceRegistry;
  final String? insuranceIssuer;
  final String? insuranceVaildFrom;

  // Doctor specific fields
  final int? doctorProfileId;
  final String? identity;
  final String? latitude;
  final String? longitude;
  final String? professionalNumber;
  final String? introduce;
  final String? medicalCategory;
  final String? officeAddress;
  final String? companyName;
  final double? profileCompleteness;
  final bool? isAvailable;

  UserProfileModel({
    required this.id,
    required this.phone,
    required this.email,
    required this.userType,
    required this.name,
    required this.gender,
    required this.avatar,
    required this.address,
    required this.country,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.status,
    // Patient fields
    this.patientProfileId,
    this.gps,
    this.birthDate,
    this.age,
    this.height,
    this.weight,
    this.bloodGroup,
    this.medicalHistory,
    this.insuranceType,
    this.insuranceNumber,
    this.insuranceRegistry,
    this.insuranceIssuer,
    this.insuranceVaildFrom,
    // Doctor fields
    this.doctorProfileId,
    this.identity,
    this.latitude,
    this.longitude,
    this.professionalNumber,
    this.introduce,
    this.medicalCategory,
    this.officeAddress,
    this.companyName,
    this.profileCompleteness,
    this.isAvailable,
  });

  // Factory constructor for Patient from API
  factory UserProfileModel.fromPatientApiJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['profile']['id'] ?? 0,
      phone: json['profile']['phone'] ?? '',
      email: json['profile']['email'] ?? '',
      userType: json['profile']['userType'] ?? '',
      name: json['profile']['name'] ?? '',
      gender: json['profile']['gender'] ?? '',
      avatar: json['profile']['avatar'] ?? '',
      address: json['profile']['address'] ?? '',
      country: json['profile']['country'] ?? '',
      city: json['profile']['city'] ?? '',
      state: json['profile']['state'] ?? '',
      zipCode: json['profile']['zip_code'] ?? '',
      status: 'active',
      // Patient specific
      patientProfileId: json['profile']['patientProfileId'] ?? 0,
      gps: '${json['profile']['langtitu'] ?? ''},${json['profile']['longtitu'] ?? ''}',
      birthDate: json['profile']['birthDate'] ?? '',
      age: json['profile']['age'] ?? 0,
      height: json['profile']['height'] ?? 0,
      weight: json['profile']['weight'] ?? 0,
      bloodGroup: json['profile']['bloodGroup'] ?? '',
      medicalHistory: json['profile']['medicalHistory'] ?? '',
      insuranceType: json['insurance']['insurance_type'] ?? '',
      insuranceNumber: json['insurance']['insurance_number'] ?? '',
      insuranceRegistry: json['insurance']['registry'] ?? '',
      insuranceIssuer: json['insurance']['issuer'] ?? '',
      insuranceVaildFrom: json['insurance']['valid_from'] ?? '',
    );
  }

  // Factory constructor for Doctor from API
  factory UserProfileModel.fromDoctorApiJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['profile']['id'],
      phone: json['profile']['phone'] ?? '',
      email: json['profile']['email'] ?? '',
      userType: json['profile']['userType'] ?? 'doctor',
      name: json['profile']['name'] ?? '',
      gender: json['profile']['gender'] ?? '',
      avatar: json['profile']['avatar'] ?? '',
      address: json['profile']['address'] ?? '',
      country: json['profile']['country'] ?? '',
      city: json['profile']['city'] ?? '',
      state: json['profile']['state'] ?? '',
      zipCode: json['profile']['zipCode'] ?? '',
      status: json['profile']['status'] ?? 'active',
      // Doctor specific
      doctorProfileId: json['profile']['doctorProfileId'],
      identity: json['profile']['identity'] ?? '',
      latitude: json['profile']['latitude'] ?? '',
      longitude: json['profile']['longitude'] ?? '',
      professionalNumber: json['profile']['professionalNumber'] ?? '',
      introduce: json['profile']['introduce'] ?? '',
      medicalCategory: json['profile']['medicalCategory']?['name'] ?? '',
      officeAddress: json['profile']['officeAddress'] ?? '',
      companyName: json['profile']['companyName'] ?? '',
      profileCompleteness: (json['profile']['profileCompleteness'] as num?)?.toDouble() ?? 0.0,
      isAvailable: json['isAvailable'] ?? false,
    );
  }

  // Named constructor for Patient from local JSON
  UserProfileModel.fromPatientJson(Map<String, dynamic> json)
    : id = json['profile']['id'],
      phone = json['profile']['phone'] ?? 'not_setup',
      email = json['profile']['email'] ?? 'not_setup',
      userType = json['profile']['user_type'] ?? 'patient',
      name = json['profile']['name'] ?? 'not_setup',
      gender = json['profile']['gender'] ?? 'not_setup',
      avatar = json['profile']['avatar'] ?? 'not_setup',
      address = json['profile']['address'] ?? 'not_setup',
      country = json['profile']['country'] ?? 'not_setup',
      city = json['profile']['city'] ?? 'not_setup',
      state = json['profile']['state'] ?? 'not_setup',
      zipCode = json['profile']['zip_code'] ?? 'not_setup',
      status = 'active',
      patientProfileId = json['profile']['patient_profile_id'],
      gps = (json['profile']['langtitu'] != null && json['profile']['longtitu'] != null)
          ? '${json['profile']['langtitu']},${json['profile']['longtitu']}'
          : 'not_setup',
      birthDate = json['profile']['birth_date'] ?? 'not_setup',
      age = json['profile']['age'] ?? 0,
      height = json['profile']['height'] ?? 0,
      weight = json['profile']['weight'] ?? 0,
      bloodGroup = json['profile']['blood_group'] ?? 'not_setup',
      medicalHistory = json['profile']['medical_history'] ?? 'not_setup',
      insuranceType = json['insurance']['insurance_type'] ?? 'not_setup',
      insuranceNumber = json['insurance']['insurance_number'] ?? 'not_setup',
      insuranceRegistry = json['insurance']['registry'] ?? 'not_setup',
      insuranceIssuer = json['insurance']['issuer'] ?? 'not_setup',
      insuranceVaildFrom = json['insurance']['valid_from'] ?? 'not_setup',
      // Doctor fields null for patient
      doctorProfileId = null,
      identity = null,
      latitude = null,
      longitude = null,
      professionalNumber = null,
      introduce = null,
      medicalCategory = null,
      officeAddress = null,
      companyName = null,
      profileCompleteness = null,
      isAvailable = null;

  // Named constructor for Doctor from local JSON
  UserProfileModel.fromDoctorJson(Map<String, dynamic> json)
    : id = json['profile']['id'],
      phone = json['profile']['phone'] ?? 'not_setup'.tr,
      email = json['profile']['email'] ?? 'not_setup',
      userType = json['profile']['userType'] ?? 'doctor',
      name = json['profile']['name'] ?? 'not_setup'.tr,
      gender = json['profile']['gender'] ?? 'not_setup'.tr,
      avatar = json['profile']['avatar'] ?? 'not_setup',
      address = json['profile']['address'] ?? 'not_setup'.tr,
      country = json['profile']['country'] ?? 'not_setup'.tr,
      city = json['profile']['city'] ?? 'not_setup'.tr,
      state = json['profile']['state'] ?? 'not_setup'.tr,
      zipCode = json['profile']['zipCode'] ?? 'not_setup'.tr,
      status = json['profile']['status'] ?? 'active',
      doctorProfileId = json['profile']['doctorProfileId'],
      identity = json['profile']['identity'] ?? 'not_setup'.tr,
      latitude = json['profile']['latitude'] ?? 'not_setup'.tr,
      longitude = json['profile']['longitude'] ?? 'not_setup'.tr,
      professionalNumber = json['profile']['professionalNumber'] ?? 'not_setup',
      introduce = json['profile']['introduce'] ?? 'not_setup'.tr,
      medicalCategory = json['profile']['medicalCategory']?['name'] ?? 'not_setup',
      officeAddress = json['profile']['officeAddress'] ?? 'not_setup'.tr,
      companyName = json['profile']['companyName'] ?? 'not_setup'.tr,
      profileCompleteness = (json['profile']['profileCompleteness'] as num?)?.toDouble() ?? 0.0,
      isAvailable = json['isAvailable'] ?? false,
      // Patient fields null for doctor
      patientProfileId = null,
      gps = null,
      birthDate = null,
      age = null,
      height = null,
      weight = null,
      bloodGroup = null,
      medicalHistory = null,
      insuranceType = null,
      insuranceNumber = null,
      insuranceRegistry = null,
      insuranceIssuer = null,
      insuranceVaildFrom = null;

  Map<String, dynamic> toJson() {
    Map<String, dynamic> baseData = {
      'id': id,
      'phone': phone,
      'email': email,
      'user_type': userType,
      'name': name,
      'gender': gender,
      'avatar': avatar,
      'address': address,
      'country': country,
      'city': city,
      'state': state,
      'zip_code': zipCode,
      'status': status,
    };

    // Add patient specific fields if this is a patient
    if (userType == 'patient') {
      baseData.addAll({
        'patient_profile_id': patientProfileId,
        'gps': gps,
        'birth_date': birthDate,
        'age': age,
        'height': height,
        'weight': weight,
        'blood_group': bloodGroup,
        'medical_history': medicalHistory,
        'insurance_type': insuranceType,
        'insurance_number': insuranceNumber,
        'insurance_registry': insuranceRegistry,
        'insurance_issuer': insuranceIssuer,
        'insurance_vaild_from': insuranceVaildFrom,
      });
    }

    // Add doctor specific fields if this is a doctor
    if (userType == 'doctor') {
      baseData.addAll({
        'doctor_profile_id': doctorProfileId,
        'identity': identity,
        'latitude': latitude,
        'longitude': longitude,
        'professional_number': professionalNumber,
        'introduce': introduce,
        'medical_category': medicalCategory,
        'office_address': officeAddress,
        'company_name': companyName,
        'profile_completeness': profileCompleteness,
        'is_available': isAvailable,
      });
    }

    return baseData;
  }

  // Helper methods to check user type
  bool get isPatient => userType == 'patient';
  bool get isDoctor => userType == 'doctor';

  // Helper method to create a copy with modified fields
  UserProfileModel copyWith({
    int? id,
    String? phone,
    String? email,
    String? userType,
    String? name,
    String? gender,
    String? avatar,
    String? address,
    String? country,
    String? city,
    String? state,
    String? zipCode,
    String? status,
    // Patient fields
    int? patientProfileId,
    String? gps,
    String? birthDate,
    int? age,
    int? height,
    int? weight,
    String? bloodGroup,
    String? medicalHistory,
    // Doctor fields
    int? doctorProfileId,
    String? identity,
    String? latitude,
    String? longitude,
    String? professionalNumber,
    String? introduce,
    String? medicalCategory,
    String? officeAddress,
    String? companyName,
    double? profileCompleteness,
    bool? isAvailable,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      userType: userType ?? this.userType,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      avatar: avatar ?? this.avatar,
      address: address ?? this.address,
      country: country ?? this.country,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      status: status ?? this.status,
      // Patient fields
      patientProfileId: patientProfileId ?? this.patientProfileId,
      gps: gps ?? this.gps,
      birthDate: birthDate ?? this.birthDate,
      age: age ?? this.age,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      // Doctor fields
      doctorProfileId: doctorProfileId ?? this.doctorProfileId,
      identity: identity ?? this.identity,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      professionalNumber: professionalNumber ?? this.professionalNumber,
      introduce: introduce ?? this.introduce,
      medicalCategory: medicalCategory ?? this.medicalCategory,
      officeAddress: officeAddress ?? this.officeAddress,
      companyName: companyName ?? this.companyName,
      profileCompleteness: profileCompleteness ?? this.profileCompleteness,
      isAvailable: isAvailable ?? this.isAvailable,
    );
  }
}
