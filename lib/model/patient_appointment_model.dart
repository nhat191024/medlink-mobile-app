class PatientAppointmentModel {
  final String id;
  final String avatar;
  final String doctorName;
  final String medicalCategory;
  final String phone;
  final String email;
  final String officeAddress;
  final String address;
  final String link;
  final String reason;
  final String meetType;
  final int duration;
  final String medicalProblem;
  final String payType;
  final String cardNumber;
  final String provider;
  final String cardExpireDate;
  final bool isReviewed;
  final String service;
  final int price;
  final int tax;
  final int total;
  final String date;
  final String time;
  final String status;

  PatientAppointmentModel({
    required this.id,
    required this.avatar,
    required this.doctorName,
    required this.medicalCategory,
    required this.phone,
    required this.email,
    required this.officeAddress,
    required this.address,
    required this.link,
    required this.reason,
    required this.meetType,
    required this.duration,
    required this.medicalProblem,
    required this.payType,
    required this.cardNumber,
    required this.provider,
    required this.cardExpireDate,
    required this.isReviewed,
    required this.service,
    required this.price,
    required this.tax,
    required this.total,
    required this.date,
    required this.time,
    required this.status,
  });

  factory PatientAppointmentModel.fromApiJson(
    Map<String, dynamic> json,
    String Function(String, String) formatDateTime,
  ) {
    return PatientAppointmentModel(
      id: json['id'].toString(),
      avatar: json['doctor']['avatar'] ?? '',
      doctorName: json['doctor']['full_name'] ?? '',
      medicalCategory: json['doctor']['medical_category_name'] ?? '',
      phone: json['doctor']['phone'] ?? '',
      email: json['doctor']['email'] ?? '',
      officeAddress: json['doctor']['office_address'],
      address: json['address'] ?? '',
      link: json['link'] ?? '',
      reason: json['reason'] ?? 'No reason given',
      meetType: json['service']['name'] ?? '',
      duration: json['service']['duration'] ?? 0,
      medicalProblem: json['medical_problem'] ?? '',
      payType: json['pay_type'] ?? '',
      cardNumber: '1234',
      provider: json['provider'],
      cardExpireDate: '31/12',
      isReviewed: json['is_reviewed'],
      service: json['service']['name'] ?? '',
      price: json['service']['price'] ?? 0,
      tax: json['bill']['taxVAT'] ?? 0,
      total: json['bill']['total'] ?? 0,
      date: formatDateTime(json['date'] ?? '', json['day_of_week'] ?? ''),
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }

  PatientAppointmentModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      avatar = json['avatar'],
      doctorName = json['doctorName'],
      medicalCategory = json['medical_category'] ?? '',
      phone = json['phone'],
      email = json['email'],
      officeAddress = json['office_address'],
      address = json['address'],
      link = json['link'],
      reason = json['reason'],
      meetType = json['meet_type'],
      duration = json['duration'],
      medicalProblem = json['medical_problem'],
      payType = json['pay_type'],
      cardNumber = json['card_number'],
      provider = json['provider'],
      cardExpireDate = json['card_expire_date'],
      isReviewed = json['is_reviewed'],
      service = json['service'],
      price = json['price'],
      tax = json['tax'],
      total = json['total'],
      date = json['date'],
      time = json['time'],
      status = json['status'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'doctorName': doctorName,
      'phone': phone,
      'email': email,
      'office_address': officeAddress,
      'address': address,
      'link': link,
      'reason': reason,
      'meet_type': meetType,
      'duration': duration,
      'medical_problem': medicalProblem,
      'pay_type': payType,
      'card_number': cardNumber,
      'card_expire_date': cardExpireDate,
      'service': service,
      'price': price,
      'tax': tax,
      'total': total,
      'date': date,
      'time': time,
      'status': status,
    };
  }

  // Helper method to create a copy with modified fields
  PatientAppointmentModel copyWith({
    String? id,
    String? avatar,
    String? doctorName,
    String? medicalCategory,
    String? phone,
    String? email,
    String? officeAddress,
    String? address,
    String? link,
    String? reason,
    String? meetType,
    int? duration,
    String? medicalProblem,
    String? payType,
    String? cardNumber,
    String? provider,
    String? cardExpireDate,
    bool? isReviewed,
    String? service,
    int? price,
    int? tax,
    int? total,
    String? date,
    String? time,
    String? status,
  }) {
    return PatientAppointmentModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      doctorName: doctorName ?? this.doctorName,
      medicalCategory: medicalCategory ?? this.medicalCategory,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      officeAddress: officeAddress ?? this.officeAddress,
      address: address ?? this.address,
      link: link ?? this.link,
      reason: reason ?? this.reason,
      meetType: meetType ?? this.meetType,
      duration: duration ?? this.duration,
      medicalProblem: medicalProblem ?? this.medicalProblem,
      payType: payType ?? this.payType,
      cardNumber: cardNumber ?? this.cardNumber,
      provider: provider ?? this.provider,
      cardExpireDate: cardExpireDate ?? this.cardExpireDate,
      isReviewed: isReviewed ?? this.isReviewed,
      service: service ?? this.service,
      price: price ?? this.price,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      date: date ?? this.date,
      time: time ?? this.time,
      status: status ?? this.status,
    );
  }
}
