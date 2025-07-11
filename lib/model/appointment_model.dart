class AppointmentModel {
  final String id;
  final String avatar;
  final String patientName;
  final String phone;
  final String email;
  final String officeAddress;
  final String patientAddress;
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
  final String service;
  final int price;
  final int tax;
  final int total;
  final String date;
  final String time;
  final String status;

  AppointmentModel({
    required this.id,
    required this.avatar,
    required this.patientName,
    required this.phone,
    required this.email,
    required this.officeAddress,
    required this.patientAddress,
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
    required this.service,
    required this.price,
    required this.tax,
    required this.total,
    required this.date,
    required this.time,
    required this.status,
  });

  factory AppointmentModel.fromApiJson(
    Map<String, dynamic> json,
    String officeAddress,
    String Function(String, String) formatDateTime,
  ) {
    return AppointmentModel(
      id: json['id'].toString(),
      avatar: json['patient']['avatar'] ?? '',
      patientName: json['patient']['full_name'] ?? '',
      phone: json['patient']['phone'] ?? '',
      email: json['patient']['email'] ?? '',
      officeAddress: officeAddress,
      patientAddress: json['patient']['address'] ?? '',
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
      service: json['service']['name'] ?? '',
      price: json['service']['price'] ?? 0,
      tax: json['bill']['taxVAT'] ?? 0,
      total: json['bill']['total'] ?? 0,
      date: formatDateTime(json['date'] ?? '', json['day_of_week'] ?? ''),
      time: json['time'] ?? '',
      status: json['status'] ?? '',
    );
  }

  AppointmentModel.fromJson(Map<String, dynamic> json)
    : id = json['id'],
      avatar = json['avatar'],
      patientName = json['patient_name'],
      phone = json['phone'],
      email = json['email'],
      officeAddress = json['office_address'],
      patientAddress = json['patient_address'],
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
      'patient_name': patientName,
      'phone': phone,
      'email': email,
      'office_address': officeAddress,
      'patient_address': patientAddress,
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
  AppointmentModel copyWith({
    String? id,
    String? avatar,
    String? patientName,
    String? phone,
    String? email,
    String? officeAddress,
    String? patientAddress,
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
    String? service,
    int? price,
    int? tax,
    int? total,
    String? date,
    String? time,
    String? status,
  }) {
    return AppointmentModel(
      id: id ?? this.id,
      avatar: avatar ?? this.avatar,
      patientName: patientName ?? this.patientName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      officeAddress: officeAddress ?? this.officeAddress,
      patientAddress: patientAddress ?? this.patientAddress,
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
