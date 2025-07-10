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

  //webview
  static const webViewScreen = _Paths.webViewScreen;

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
  static const searchDoctorScreen = _Paths.searchDoctorScreen;

  //booking screen
  static const bookingScreen = _Paths.bookingScreen;

  static const doctorTabScreen = _Paths.doctorTabScreen;
  static const photoViewerScreen = _Paths.photoViewerScreen;
  static const videoPlayerScreen = _Paths.videoPlayerScreen;
  // static const videoThumbnailScreenScreen = _Paths.videoThumbnailScreenScreen;
  static const incomingCallScreen = _Paths.incomingCallScreen;
  static const callScreen = _Paths.callScreen;
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

  //webview
  static const webViewScreen = '/web-view-screen';

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
  static const searchDoctorScreen = '/search-doctor-screen';

  //booking screen
  static const bookingScreen = '/booking-screen';

  //notification screen
  static const notificationScreen = '/notification-screen';

  static const doctorTabScreen = '/doctor-tab-screen';
  static const photoViewerScreen = '/photo-viewer-screen';
  static const videoPlayerScreen = '/video-player-screen';
  // static const videoThumbnailScreenScreen = '/video-thumbnail-screen';
  static const incomingCallScreen = '/incoming-call-screen';
  static const callScreen = '/call-screen';
}
