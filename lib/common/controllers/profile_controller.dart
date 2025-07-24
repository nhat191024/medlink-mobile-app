import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'package:medlink/model/profile_model.dart';
import 'package:medlink/model/language_model.dart';
import 'package:medlink/model/service_model.dart';
import 'package:medlink/model/testimonials_model.dart';
import 'package:medlink/model/review_model.dart';

class ProfileController extends GetxController {
  //========================================
  // CORE PROPERTIES
  //========================================
  final token = StorageService.readData(key: LocalStorageKeys.token);
  RxBool isLoading = true.obs;
  RxString error = ''.obs;
  RxBool isEdit = false.obs;
  RxString oldAvatar = ''.obs;
  RxString identity = ''.obs;

  //========================================
  // USER DATA
  //========================================
  Rx<ProfileModel> userData = ProfileModel(
    id: 0,
    phone: '',
    userType: '',
    email: '',
    identity: '',
    latitude: '',
    longitude: '',
    name: '',
    gender: '',
    avatar: '',
    address: '',
    country: '',
    city: '',
    state: '',
    zipCode: '',
    status: '',
    doctorProfileId: 0,
    professionalNumber: '',
    introduce: '',
    medicalCategory: '',
    officeAddress: '',
    companyName: '',
    profileCompleteness: 0.0,
    isAvailable: false,
  ).obs;

  //========================================
  // PROFILE RELATED DATA
  //========================================
  List<LanguageModel> languages = [];
  List<ServiceModel> services = [];
  List<TestimonialsModel> testimonials = [];
  List testimonialsTitle = ['Bad', 'Not happy', 'Average', 'Good', 'Excellent'];
  List<ReviewModel> topReviews = [];
  List<ReviewModel> allReviews = [];
  List<String> medicalCategories = [];
  RxInt reviewCounts = 0.obs;
  RxDouble avgTotal = 0.0.obs;

  //========================================
  // EDIT PROFILE FORM CONTROLLERS
  //========================================
  final Rx<File?> avatarImage = Rx<File?>(null);
  final RxBool isDefaultAvatar = false.obs;

  // Basic Info Controllers
  final TextEditingController fullName = TextEditingController();
  final RxBool isFullnameError = false.obs;
  final TextEditingController introduce = TextEditingController();
  final RxBool isIntroduceError = false.obs;
  final RxString gender = ''.obs;
  final RxBool isGenderError = false.obs;

  // Professional Info Controllers (Doctor only)
  final TextEditingController professionalNo = TextEditingController();
  final RxBool isProfessionalNoError = false.obs;
  final RxString medicalCategory = ''.obs;
  final RxBool isMedicalCategoryError = false.obs;
  final TextEditingController companyName = TextEditingController();
  final RxBool isCompanyNameError = false.obs;

  // Contact Info Controllers
  final TextEditingController email = TextEditingController();
  final RxBool isEmailError = false.obs;
  final TextEditingController phoneNumber = TextEditingController();
  final Rx<Country> selectedCountry = Country.unitedStates.obs;

  // Location Controllers
  final TextEditingController officeAddress = TextEditingController();
  final RxBool isOfficeAddressError = false.obs;
  final TextEditingController gps = TextEditingController();
  final RxBool isGpsError = false.obs;
  final TextEditingController country = TextEditingController();
  final RxBool isCountryError = false.obs;
  final TextEditingController city = TextEditingController();
  final RxBool isCityError = false.obs;

  // Language Controllers
  final RxString language = ''.obs;
  final RxBool isLanguageError = false.obs;

  //========================================
  // INITIALIZATION
  //========================================
  @override
  void onInit() {
    _initializeIdentity();
    _initializeData();
    super.onInit();
  }

  void _initializeIdentity() {
    if (StorageService.checkData(key: 'identity')) {
      identity.value = StorageService.readData(key: 'identity');
    }
  }

  void _initializeData() {
    fetchUserData();
    fetchAllMedicalCategories();

    if (StorageService.checkData(key: 'avatar')) {
      oldAvatar.value = StorageService.readData(key: 'avatar');
    }
  }

  //========================================
  // DATA FETCHING METHODS
  //========================================
  Future fetchUserData() async {
    final url = _buildApiUrl();
    final response = await _makeApiCall(url);

    if (response.statusCode == 200) {
      _processUserDataResponse(response);
    }
  }

  String _buildApiUrl() {
    return identity.value == "doctor" ? '${Apis.api}profile/doctor' : '${Apis.api}profile/patient';
  }

  Future<http.Response> _makeApiCall(String url) async {
    return await get(Uri.parse(url), headers: {'Authorization': 'Bearer $token'});
  }

  void _processUserDataResponse(http.Response response) {
    final data = jsonDecode(response.body);

    _processLanguages(data['languages']);
    _processServices(data['services']);
    _processReviews(data['reviews'], data['allReviews']);
    _processTestimonials(data['testimonials']);
    _processRatings(data);

    userData.value = ProfileModel.fromJson(data);
    isLoading.value = false;
  }

  void _processLanguages(dynamic languageData) {
    languages.clear();
    for (var lang in languageData) {
      languages.add(LanguageModel.fromJson(lang));
    }
  }

  void _processServices(dynamic serviceData) {
    services.clear();
    for (var serv in serviceData) {
      services.add(ServiceModel.fromJson(serv));
    }
  }

  void _processReviews(dynamic reviewsData, dynamic allReviewsData) {
    // Process all reviews
    allReviews.clear();
    if (allReviewsData != null && allReviewsData.isNotEmpty) {
      for (var review in allReviewsData) {
        allReviews.add(ReviewModel.fromJson(review));
      }
    }

    // Process top reviews
    topReviews.clear();
    if (reviewsData != null && reviewsData.isNotEmpty) {
      for (var review in reviewsData) {
        topReviews.add(ReviewModel.fromJson(review));
      }
    }
  }

  void _processTestimonials(dynamic testimonialData) {
    testimonials.clear();
    if (testimonialData != null) {
      for (var testimonial in testimonialData) {
        testimonials.add(TestimonialsModel.fromJson(testimonial));
      }
    }
  }

  void _processRatings(Map<String, dynamic> data) {
    reviewCounts.value = data['reviewCount'] ?? 0;
    avgTotal.value = double.parse(data['avgTotal'].toString());
  }

  Future<void> fetchAllMedicalCategories() async {
    final response = await get(
      Uri.parse('${Apis.api}medical-categories'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      _processMedicalCategories(data);
    }
  }

  void _processMedicalCategories(dynamic data) {
    medicalCategories.clear();
    for (var category in data) {
      medicalCategories.add(category['name'] as String);
    }
  }

  //========================================
  // EDIT PROFILE METHODS
  //========================================
  void loadDataToEdit() {
    _loadPhoneData();
    _loadBasicInfo();
    _loadProfessionalInfo();
    _loadLocationInfo();
    _loadContactInfo();
  }

  void _loadPhoneData() {
    final phone = userData.value.phone == "not_setup".tr ? "" : userData.value.phone;
    final match = RegExp(r'^(\+\d+)\s*(.*)').firstMatch(phone);

    if (match != null) {
      final countryCode = match.group(1);
      final phoneNum = match.group(2);

      phoneNumber.text = phoneNum == "not_setup".tr ? "" : phoneNum!;
      selectedCountry.value = Country.values.firstWhere(
        (country) => country.dialCode == countryCode,
      );
    }
  }

  void _loadBasicInfo() {
    fullName.text = userData.value.name == "not_setup".tr ? "" : userData.value.name;
    gender.value = userData.value.gender == "not_setup".tr ? "" : userData.value.gender;
    introduce.text = userData.value.introduce == "not_setup".tr ? "" : userData.value.introduce;
  }

  void _loadProfessionalInfo() {
    professionalNo.text = userData.value.professionalNumber == "not_setup".tr
        ? ""
        : userData.value.professionalNumber;
    medicalCategory.value = userData.value.medicalCategory == "not_setup".tr
        ? ""
        : userData.value.medicalCategory;
    companyName.text = userData.value.companyName == "not_setup".tr
        ? ""
        : userData.value.companyName;
  }

  void _loadLocationInfo() {
    officeAddress.text = userData.value.officeAddress == "not_setup".tr
        ? ""
        : userData.value.officeAddress;

    country.text = userData.value.country == "not_setup".tr ? "" : userData.value.country;
    city.text = userData.value.city == "not_setup".tr ? "" : userData.value.city;

    gps.text = userData.value.latitude == ""
        ? ""
        : '${userData.value.latitude}, ${userData.value.longitude}';
  }

  void _loadContactInfo() {
    email.text = userData.value.email == "not_setup".tr ? "" : userData.value.email;
  }

  //========================================
  // PROFILE UPDATE METHODS
  //========================================
  Future<void> updateProfile() async {
    if (!validation()) {
      Get.snackbar('error'.tr, "full_fill_required".tr, colorText: AppColors.errorMain);
      return;
    }

    final uri = Uri.parse('${Apis.api}profile/doctor/edit');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Content-Type'] = 'multipart/form-data';
    request.headers['Accept'] = 'application/json';

    if (avatarImage.value != null && !isDefaultAvatar.value) {
      await _addAvatarFile(request);
    }

    // Basic fields
    request.fields['useDefaultAvatar'] = _getDefaultAvatarFlag();
    request.fields['user_type'] = userData.value.userType;
    request.fields['identity'] = userData.value.identity;
    request.fields['name'] = fullName.text;
    request.fields['gender'] = gender.value;
    request.fields['languages'] = jsonEncode(languages.map((lang) => lang.toJson()).toList());

    // Contact fields
    request.fields['country_code'] = selectedCountry.value.dialCode;
    request.fields['phone'] = phoneNumber.text;
    request.fields['email'] = email.text;

    // Location fields
    request.fields['latitude'] = gps.text.split(',')[0];
    request.fields['longitude'] = gps.text.split(',')[1];
    request.fields['city'] = city.text;
    request.fields['country'] = country.text;

    // Doctor specific fields
    if (userData.value.identity == "doctor") {
      request.fields['professional_number'] = professionalNo.text;
      request.fields['introduce'] = introduce.text;
      request.fields['medical_category_name'] = medicalCategory.value;
      request.fields['company_name'] = companyName.text;
      request.fields['office_address'] = officeAddress.text;
    }

    debugPrint('Updating profile with data:');
    for (var field in request.fields.entries) {
      debugPrint('${field.key}: ${field.value}');
    }

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();
    var json = jsonDecode(responseBody);

    if (response.statusCode == 200) {
      _handleUpdateSuccess();
    } else {
      debugPrint('Update failed with status code: ${response.statusCode}');
      // debugPrint(json);
      debugPrint('Error: ${json['message']}');

      // error.value = '';
      // for (var key in data['message']) {
      //   error.value += key + '\n';
      // }
      // Get.snackbar('Error', error.value, colorText: AppColors.errorMain);
    }

    // final response = await request.send();
    // await _handleUpdateResponse(response);
  }

  String _getDefaultAvatarFlag() {
    return avatarImage.value == null
        ? checkIfDefaultAvatar(userData.value.avatar)
              ? '1'
              : '0'
        : '0';
  }

  Future<void> _addAvatarFile(http.MultipartRequest request) async {
    final avatarFile = await http.MultipartFile.fromPath(
      'avatar',
      avatarImage.value!.path,
      filename: avatarImage.value!.path.split('/').last,
    );
    request.files.add(avatarFile);
  }

  void _handleUpdateSuccess() {
    avatarImage.value = null;
    isEdit.value = true;
    oldAvatar.value = userData.value.avatar;
    Get.back();
    Get.snackbar('Success', 'Profile updated successfully');
  }

  //========================================
  // VALIDATION METHODS
  //========================================

  bool validation() {
    final textControllers = {
      'fullName': {'controller': fullName, 'errorFlag': isFullnameError},
      'country': {'controller': country, 'errorFlag': isCountryError},
      'city': {'controller': city, 'errorFlag': isCityError},
      if (userData.value.identity == "doctor")
        'professionalNo': {'controller': professionalNo, 'errorFlag': isProfessionalNoError},
      'introduce': {'controller': introduce, 'errorFlag': isIntroduceError},
      'officeAddress': {'controller': officeAddress, 'errorFlag': isOfficeAddressError},
      'gps': {'controller': gps, 'errorFlag': isGpsError},
      if (userData.value.identity == "doctor")
        'companyName': {'controller': companyName, 'errorFlag': isCompanyNameError},
      'email': {'controller': email, 'errorFlag': isEmailError},
    };

    final noneControllers = {
      if (userData.value.identity == "doctor")
        'gender': {'controller': gender, 'errorFlag': isGenderError},
      if (userData.value.identity == "doctor")
        'medicalCategory': {'controller': medicalCategory, 'errorFlag': isMedicalCategoryError},
    };

    bool isValid = true;

    textControllers.forEach((key, value) {
      if ((value['controller'] as TextEditingController).text.isEmpty) {
        (value['errorFlag'] as RxBool).value = true;
        isValid = false;
      } else {
        (value['errorFlag'] as RxBool).value = false;
      }
    });

    noneControllers.forEach((key, value) {
      if ((value['controller'] as RxString).value.isEmpty) {
        (value['errorFlag'] as RxBool).value = true;
        isValid = false;
      } else {
        (value['errorFlag'] as RxBool).value = false;
      }
    });
    return isValid;
  }

  void clearError() {
    isFullnameError.value = false;
    isProfessionalNoError.value = false;
    isGenderError.value = false;
    isIntroduceError.value = false;
    isMedicalCategoryError.value = false;
    isLanguageError.value = false;
    isOfficeAddressError.value = false;
    isGpsError.value = false;
    isCompanyNameError.value = false;
    isEmailError.value = false;
  }

  //========================================
  // UTILITY METHODS
  //========================================
  String getImageForLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'en':
        return AppImages.english;
      case 'vi':
        return AppImages.vietnamese;
      default:
        return '';
    }
  }

  String formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    DateFormat formatter = DateFormat('MMM dd, yyyy HH:mm');
    return formatter.format(dateTime);
  }

  bool checkIfDefaultAvatar(String avatar) {
    avatar = avatar.split('/').last;
    if (avatar.contains('default.png')) {
      return true;
    } else {
      return false;
    }
  }

  //format price with thousand separator
  String formatPrice(int price) {
    final formatted = NumberFormat('#,##0', 'en_US').format(price);
    return '$formatted ${"currency".tr}';
  }

  //========================================
  // GETTER METHODS
  //========================================
  bool get isDoctor => userData.value.identity == "doctor";

  String get userAvatar => userData.value.avatar;

  String get userName => userData.value.name;

  double get profileCompleteness => userData.value.profileCompleteness;

  //========================================
  // LIFECYCLE METHODS
  //========================================
  @override
  void onClose() {
    // Dispose controllers
    fullName.dispose();
    introduce.dispose();
    professionalNo.dispose();
    companyName.dispose();
    email.dispose();
    phoneNumber.dispose();
    officeAddress.dispose();
    gps.dispose();
    super.onClose();
  }
}
