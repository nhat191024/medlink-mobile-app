part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const splashScreen = _Paths.splashScreen;
  static const loginScreen = _Paths.loginScreen;

// create account
  static const telephoneScreen = _Paths.telephoneScreen;
  static const countryCodeScreen = _Paths.countryCodeScreen;
  static const verifyScreen = _Paths.verifyScreen;
  static const userTypeScreen = _Paths.userTypeScreen;
  static const createAccountScreen = _Paths.createAccountScreen;
  static const informationScreen = _Paths.informationScreen;
  static const identifyScreen = _Paths.identifyScreen;
  static const licenseScreen = _Paths.licenseScreen;
  static const addAvatarScreen = _Paths.addAvatarScreen;
  static const creatingAccountScreen = _Paths.creatingAccountScreen;
  static const accountSubmitScreen = _Paths.accountSubmitScreen;
  static const accountSuccessScreen = _Paths.accountSuccessScreen;

// forget password
  static const forgetPasswordTelephoneScreen = _Paths.forgetPasswordTelephoneScreen;
  static const forgetPasswordInputCountryScreen = _Paths.forgetPasswordInputCountryScreen;
  static const forgetPasswordVerifyScreen = _Paths.forgetPasswordVerifyScreen;
  static const forgetPasswordNewPasswordScreen = _Paths.forgetPasswordNewPasswordScreen;

  //doctor home screen
  static const doctorHomeScreen = _Paths.doctorHomeScreen;

  //doctor my appointment screen
  static const doctorMyAppointmentScreen = _Paths.doctorMyAppointmentScreen;

  //message screen
  static const messageScreen = _Paths.messageScreen;
  static const detailMessageScreen = _Paths.detailMessageScreen;

  //setting screen
  static const doctorSettingScreen = _Paths.doctorSettingScreen;
  static const profileScreen = _Paths.profileScreen;
  static const profileEditScreen = _Paths.profileEditScreen;
  static const changePasswordScreen = _Paths.changePasswordScreen;
  static const supportScreen = _Paths.supportScreen;
  static const notificationsSettingScreen = _Paths.notificationsSettingScreen;
  static const messageSettingScreen = _Paths.messageSettingScreen;
  static const logoutScreen = _Paths.logoutScreen;
  static const patientListRecordScreen = _Paths.patientListRecordScreen;
  static const patientFavoriteListRecords = _Paths.patientFavoriteListRecords;
  static const patientDetailRecordScreen = _Paths.patientDetailRecordScreen;
  static const workSchedulesScreen = _Paths.workSchedulesScreen;
  static const myServiceScreen = _Paths.myServiceScreen;
  static const allReviewScreen = _Paths.allReviewScreen;

  //notification screen
  static const notificationScreen = _Paths.notificationScreen;

  //patient home screen
  static const patientHomeScreen = _Paths.patientHomeScreen;
  static const patientMyAppointmentScreen = _Paths.patientMyAppointmentScreen;

  static const doctorTabScreen = _Paths.doctorTabScreen;
  static const photoViewerScreen = _Paths.photoViewerScreen;
  static const videoPlayerScreen = _Paths.videoPlayerScreen;
  // static const videoThumbnailScreenScreen = _Paths.videoThumbnailScreenScreen;
  static const chatScreen = _Paths.chatScreen;
  static const incomingCallScreen = _Paths.incomingCallScreen;
  static const callScreen = _Paths.callScreen;

  /// doctor side screen
  static const doctorRegisterScreen = _Paths.doctorRegisterScreen;
  static const chooseYourPlanScreen = _Paths.chooseYourPlanScreen;
  static const dMyPhotoViewerScreen = _Paths.dMyPhotoViewerScreen;
  static const dChangePasswordScreen = _Paths.dChangePasswordScreen;
  static const dSubscriptionListScreen = _Paths.dSubscriptionListScreen;
  static const dIncomeReportScreen = _Paths.dIncomeReportScreen;
  static const dBankDetailsScreen = _Paths.dBankDetailsScreen;
  static const dAllAppointmentsScreen = _Paths.dAllAppointmentsScreen;
  static const dAppointmentDetailScreen = _Paths.dAppointmentDetailScreen;
  static const dSearchMedicineScreen = _Paths.dSearchMedicineScreen;
  static const dStepThreeDetailScreen = _Paths.dStepThreeDetailScreen;
  static const dHolidayManageScreen = _Paths.dHolidayManageScreen;
  // static const dAddMedicineScreen = _Paths.dAddMedicineScreen;

  /// patient side screen
  static const userTabScreen = _Paths.userTabScreen;
  static const termsAndConditionScreen = _Paths.termsAndConditionScreen;
  static const aboutUSScreen = _Paths.aboutUSScreen;
  static const reportIssuesScreen = _Paths.reportIssuesScreen;
  static const editProfileScreen = _Paths.editProfileScreen;
  static const specialityScreen = _Paths.specialityScreen;
  static const specialityDoctorScreen = _Paths.specialityDoctorScreen;
  static const doctorDetailScreen = _Paths.doctorDetailScreen;
  static const doctorReviewScreen = _Paths.doctorReviewScreen;
  static const loginUserScreen = _Paths.loginUserScreen;
  static const makeAppointmentScreen = _Paths.makeAppointmentScreen;
  static const inAppWebViewScreen = _Paths.inAppWebViewScreen;
  static const patientRegisterScreen = _Paths.patientRegisterScreen;
  static const uAppointmentDetailScreen = _Paths.uAppointmentDetailScreen;
  static const uAllAppointmentsScreen = _Paths.uAllAppointmentsScreen;
  static const dAllNearbyScreen = _Paths.dAllNearbyScreen;
  static const dSearchScreen = _Paths.dSearchScreen;
  static const uAppointmentPdfScreen = _Paths.uAppointmentPdfScreen;
  static const pharmacyMedicineScreen = _Paths.pharmacyMedicineScreen;
  static const viewCartMedicineScreen = _Paths.viewCartMedicineScreen;
  static const medicineOrderScreen = _Paths.medicineOrderScreen;
  static const selectAddressScreen = _Paths.selectAddressScreen;
  static const addressAddUpdateScreen = _Paths.addressAddUpdateScreen;
}

abstract class _Paths {
  static const splashScreen = '/splash-screen';
  static const loginScreen = '/login-screen';

// create account
  static const telephoneScreen = '/telephone-screen';
  static const countryCodeScreen = '/country-screen';
  static const verifyScreen = '/verify-screen';
  static const userTypeScreen = '/user-type';
  static const createAccountScreen = '/create-account-screen';
  static const identifyScreen = '/identify-screen';
  static const licenseScreen = '/license-screen';
  static const addAvatarScreen = '/add-avatar-screen';
  static const creatingAccountScreen = '/creating-account-screen';
  static const informationScreen = '/information-screen';
  static const accountSubmitScreen = '/account-submit-screen';
  static const accountSuccessScreen = '/account-success-screen';

//forgot password
  static const forgetPasswordTelephoneScreen = '/forget-password-telephone-screen';
  static const forgetPasswordInputCountryScreen = '/forget-password-country-screen';
  static const forgetPasswordVerifyScreen = '/forget-password-verify-screen';
  static const forgetPasswordNewPasswordScreen = '/forget-password-new-password-screen';

//doctor home screen
  static const doctorHomeScreen = '/doctor-home-screen';

//doctor my appointment screen
  static const doctorMyAppointmentScreen = '/doctor-my-appointment-screen';

//message screen
  static const messageScreen = '/chat-screen';
  static const detailMessageScreen = '/detail-message-screen';

//setting screen
  static const doctorSettingScreen = '/setting-screen';
  static const profileScreen = '/profile-screen';
  static const profileEditScreen = '/profile-edit-screen';
  static const changePasswordScreen = '/change-password-screen';
  static const notificationsSettingScreen = '/notifications-setting-screen';
  static const supportScreen = '/support-screen';
  static const messageSettingScreen = '/message-setting-screen';
  static const logoutScreen = '/logout-screen';
  static const patientListRecordScreen = '/patient-list-record-screen';
  static const patientFavoriteListRecords = '/patient-favorite-list-records';
  static const patientDetailRecordScreen = '/patient-detail-record-screen';
  static const workSchedulesScreen = '/work-schedules-screen';
  static const myServiceScreen = '/my-service-screen';
  static const allReviewScreen = '/all-review-screen';

  //patient home screen
  static const patientHomeScreen = '/patient-home-screen';
  static const patientMyAppointmentScreen = '/patient-my-appointment-screen';

  //notification screen
  static const notificationScreen = '/notification-screen';

  static const doctorTabScreen = '/doctor-tab-screen';
  static const photoViewerScreen = '/photo-viewer-screen';
  static const videoPlayerScreen = '/video-player-screen';
  // static const videoThumbnailScreenScreen = '/video-thumbnail-screen';
  static const incomingCallScreen = '/incoming-call-screen';
  static const callScreen = '/call-screen';

  /// doctor side screen
  static const doctorRegisterScreen = '/doctor-register-screen';
  static const chooseYourPlanScreen = '/doctor-choose-your-plan-screen';
  static const dMyPhotoViewerScreen = '/doctor-my-photo-viewer-screen';
  static const dChangePasswordScreen = '/doctor-change-password-screen';
  static const dSubscriptionListScreen = '/doctor-subscription-list-screen';
  static const dIncomeReportScreen = '/doctor-income-report-screen';
  static const dBankDetailsScreen = '/doctor-bank-details-screen';
  static const dAllAppointmentsScreen = '/doctor-all-appointments-screen';
  static const dAppointmentDetailScreen = '/doctor-appointment-detail-screen';
  static const dSearchMedicineScreen = '/doctor-search-medicine-screen';
  static const dStepThreeDetailScreen = '/doctor-step-three-detail-screen';
  static const dHolidayManageScreen = '/doctor-holiday-manage-screen';
  // static const dAddMedicineScreen = '/doctor-add-medicine-screen';

  /// patient side screen
  static const userTabScreen = '/user-tab-screen';
  static const termsAndConditionScreen = '/terms-and-condition-screen';
  static const aboutUSScreen = '/about-us-screen';
  static const reportIssuesScreen = '/report-issues-screen';
  static const editProfileScreen = '/edit-profile-screen';
  static const specialityScreen = '/speciality-screen';
  static const specialityDoctorScreen = '/speciality-doctor-screen';
  static const doctorDetailScreen = '/doctor-detail-screen';
  static const doctorReviewScreen = '/doctor-review-screen';
  static const loginUserScreen = '/login-user-screen';
  static const makeAppointmentScreen = '/make-appointment-screen';
  static const inAppWebViewScreen = '/in-app-web-view-screen';
  static const patientRegisterScreen = '/patient-register-screen';
  static const uAppointmentDetailScreen = '/user-appointment-detail-screen';
  static const uAllAppointmentsScreen = '/user-all-appointments-screen';
  static const dAllNearbyScreen = '/doctor-all-nearby-screen';
  static const dSearchScreen = '/doctor-search-screen';
  static const chatScreen = '/chat-screen';
  static const uAppointmentPdfScreen = '/user-appointment-pdf-screen';
  static const pharmacyMedicineScreen = '/pharmacy-medicine-screen';
  static const viewCartMedicineScreen = '/view-cart-medicine-screen';
  static const medicineOrderScreen = '/medicine-order-screen';
  static const selectAddressScreen = '/select-address-screen';
  static const addressAddUpdateScreen = '/address-add-update-screen';
}
