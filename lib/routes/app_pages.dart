import 'package:medlink/patient/screens/search_doctor_screen.dart';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/utils/common_imports.dart';
import 'package:medlink/patient/utils/patient_imports.dart';
import 'package:medlink/doctor/utils/doctor_imports.dart';

// import 'package:videocalling_medical/doctor/utils/doctor_imports.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initialRoute = Routes.splashScreen; // change back to splashScreen after testing

  static final routes = [
    GetPage(
      name: _Paths.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashScreenBinding(),
    ),

    GetPage(name: _Paths.loginScreen, page: () => LoginScreen(), binding: LoginScreenBinding()),

    //create account
    GetPage(
      name: _Paths.telephoneScreen,
      page: () => TelephoneScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.verifyScreen,
      page: () => VerifyCodeScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.userTypeScreen,
      page: () => UserTypeScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.createAccountScreen,
      page: () => CreateAccountScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.informationScreen,
      page: () => InformationScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.identifyScreen,
      page: () => IdentifyScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.licenseScreen,
      page: () => LicenseScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.addAvatarScreen,
      page: () => AddAvatarScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.creatingAccountScreen,
      page: () => CreatingAccountScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.accountSubmitScreen,
      page: () => AccountSubmitScreen(),
      binding: CreateAccountBinding(),
    ),
    GetPage(
      name: _Paths.accountSuccessScreen,
      page: () => AccountSuccessScreen(),
      binding: CreateAccountBinding(),
    ),

    // //forgot password
    // GetPage(
    //   name: _Paths.forgetPasswordTelephoneScreen,
    //   page: () => ForgotPasswordTelephoneScreen(),
    //   binding: ForgotPasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.forgetPasswordInputCountryScreen,
    //   page: () => const ForgotPasswordInputCountryCodeScreen(),
    //   binding: ForgotPasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.forgetPasswordVerifyScreen,
    //   page: () => ForgotPasswordVerifyScreen(),
    //   binding: ForgotPasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.forgetPasswordNewPasswordScreen,
    //   page: () => ForgotPasswordNewPasswordScreen(),
    //   binding: ForgotPasswordBinding(),
    // ),

    //webview
    GetPage(
      name: _Paths.webViewScreen,
      page: () => WebViewScreen(),
      binding: WebViewBinding(),
      participatesInRootNavigator: true,
      preventDuplicates: true,
    ),

    //doctor home screen
    GetPage(
      name: _Paths.doctorHomeScreen,
      page: () => const DoctorBottomNav(),
      binding: DoctorBottomTabBinding(),
    ),

    // //doctor my appointment screen
    // GetPage(
    //   name: _Paths.doctorMyAppointmentScreen,
    //   page: () => DoctorMyAppointmentsScreen(),
    //   binding: DoctorMyAppointmentsBinding(),
    // ),

    // //message screen
    // GetPage(
    //   name: _Paths.messageScreen,
    //   page: () {
    //     // final arguments = Get.arguments as Map<String, dynamic>?;
    //     // final userType = arguments?['type'] == 'patient' ? 0 : 1;
    //     return MessagesScreen();
    //   },
    //   binding: MessagesBinding(),
    // ),
    GetPage(
      name: _Paths.detailMessageScreen,
      page: () => MessagesDetailScreen(),
      binding: MessagesBinding(),
    ),

    // //setting screen
    // GetPage(
    //   name: _Paths.doctorSettingScreen,
    //   page: () => SettingScreen(),
    //   binding: DoctorSettingBinding(),
    // ),
    GetPage(name: _Paths.profileScreen, page: () => ProfileScreen(), binding: ProfileBinding()),
    // GetPage(
    //   name: _Paths.allReviewScreen,
    //   page: () => const AllReviewScreen(),
    //   binding: ProfileBinding(),
    // ),
    // GetPage(
    //   name: _Paths.editProfileScreen,
    //   page: () => ProfileEditScreen(),
    //   binding: SettingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.changePasswordScreen,
    //   page: () => ChangePasswordScreen(),
    //   binding: SettingBinding(),
    // ),
    GetPage(
      name: _Paths.notificationsSettingScreen,
      page: () => NotificationsSettingScreen(),
      binding: SettingBinding(),
    ),
    GetPage(
      name: _Paths.messageSettingScreen,
      page: () => MessageSettingScreen(),
      binding: SettingBinding(),
    ),
    // GetPage(
    //   name: _Paths.supportScreen,
    //   page: () => const SupportScreen(),
    //   binding: SettingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.logoutScreen,
    //   page: () => LogoutScreen(),
    //   binding: SettingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.patientListRecordScreen,
    //   page: () => PatientListRecordsScreen(),
    //   binding: DoctorSettingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.patientFavoriteListRecords,
    //   page: () => PatientFavoriteListRecords(),
    //   binding: DoctorSettingBinding(),
    // ),
    // GetPage(
    //   name: _Paths.patientDetailRecordScreen,
    //   page: () => PatientDetailRecordScreen(),
    //   binding: DoctorSettingBinding(),
    // ),
    GetPage(
      name: _Paths.workSchedulesScreen,
      page: () => WorkSchedulesScreen(),
      binding: WorkingScheduleBinding(),
    ),
    GetPage(
      name: _Paths.myServiceScreen,
      page: () => MyServiceScreen(),
      binding: ServiceSettingBinding(),
    ),

    // //notification screen
    // GetPage(
    //   name: _Paths.notificationScreen,
    //   page: () => const NotificationTabScreen(),
    //   binding: NotificationBinding(),
    // ),

    //patient home screen
    GetPage(
      name: _Paths.patientHomeScreen,
      page: () => const PatientBottomNav(),
      binding: PatientBottomTabBinding(),
    ),

    //patient search doctor screen
    GetPage(
      name: _Paths.searchDoctorScreen,
      page: () => SearchDoctorScreen(),
      binding: SearchDoctorBinding(),
    ),

    //booking screen
    GetPage(
      name: _Paths.bookingScreen,
      page: () => const BookingSceen(),
      binding: BookingBinding(),
    ),

    //payment result screen
    GetPage(
      name: _Paths.paymentResultScreen,
      page: () => PaymentResultScreen(),
      binding: PaymentResultBinding(),
    ),

    // //patient my appointment screen
    // GetPage(
    //   name: _Paths.patientMyAppointmentScreen,
    //   page: () => PatientMyAppointmentsScreen(),
    //   binding: PatientMyAppointmentsBinding(),
    // ),

    // GetPage(
    //   name: _Paths.doctorTabScreen,
    //   page: () => const DoctorTabsScreen(),
    //   binding: TabScreenBinding(),
    // ),
    // GetPage(
    //   name: _Paths.videoPlayerScreen,
    //   page: () => MyVideoPlayer(),
    //   binding: MyVideoPlayerBinding(),
    // ),
    // GetPage(
    //   name: _Paths.photoViewerScreen,
    //   page: () => MyPhotoViewer(),
    //   binding: MyPhotoViewerBinding(),
    // ),
    // GetPage(
    //   name: _Paths.chatScreen,
    //   page: () => ChatScreen(),
    //   binding: ChatBinding(),
    // ),
    // GetPage(
    //   name: _Paths.uAppointmentPdfScreen,
    //   page: () => AppointmentDetailsScreenPdf(),
    //   binding: AppointmentDetailsScreenPdfBinding(),
    // ),
    // GetPage(
    //   name: _Paths.incomingCallScreen,
    //   page: () => IncomingCallScreen(),
    //   binding: IncomingCallBinding(),
    // ),
    // // GetPage(
    // //   name: _Paths.uAppointmentPdfScreen,
    // //   page: () => AppointmentDetailsScreenPdf(),
    // //   binding: AppointmentDetailsScreenPdfBinding(),
    // // ),

    // /// doctor side screen
    // GetPage(
    //   name: _Paths.doctorRegisterScreen,
    //   page: () => RegisterAsDoctor(),
    //   binding: DoctorRegisterBinding(),
    // ),
    // GetPage(
    //   name: _Paths.chooseYourPlanScreen,
    //   page: () => DoctorChooseYourPlanScreen(),
    //   binding: DoctorChooseYourPlanBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dMyPhotoViewerScreen,
    //   page: () => DMyPhotoView(),
    //   binding: DMyPhotoViewBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dChangePasswordScreen,
    //   page: () => ChangePassword(),
    //   binding: DChangePasswordBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dSubscriptionListScreen,
    //   page: () => SubscriptionListScreen(),
    //   binding: SubscriptionListBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dIncomeReportScreen,
    //   page: () => IncomeReportScreen(),
    //   binding: IncomeReportBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dBankDetailsScreen,
    //   page: () => BankDetailScreen(),
    //   binding: BankDetailBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dAllAppointmentsScreen,
    //   page: () => DoctorAllAppointments(),
    //   binding: DAllAppointmentsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dAppointmentDetailScreen,
    //   page: () => DoctorAppointmentDetails(),
    //   binding: DAppointmentDetailsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dSearchMedicineScreen,
    //   page: () => SearchMedicineScreen(),
    //   binding: SearchMedicineBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dStepThreeDetailScreen,
    //   page: () => StepThreeDetailsScreen(),
    //   binding: StepThreeDetailsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dHolidayManageScreen,
    //   page: () => ManageHolidayScreen(),
    //   binding: HolidayManageBinding(),
    // ),
    // // GetPage(
    // //   name: _Paths.dSearchMedicineScreen,
    // //   page: () => MedicinseScreen(),
    // //   binding: AddMedicineToAppointmentBinding(),
    // // ),

    // /// patient side screen
    // GetPage(
    //   name: _Paths.userTabScreen,
    //   page: () => const PatientTabsScreen(),
    //   binding: PatientTabScreenBinding(),
    // ),
    // GetPage(
    //   name: _Paths.termsAndConditionScreen,
    //   page: () => TermAndConditions(),
    //   binding: TermAndConditionsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.aboutUSScreen,
    //   page: () => AboutUSScreen(),
    //   binding: AboutUSBinding(),
    // ),
    // GetPage(
    //   name: _Paths.reportIssuesScreen,
    //   page: () => ReportIssuesScreen(),
    //   binding: ReportIssueBinding(),
    // ),
    // GetPage(
    //   name: _Paths.editProfileScreen,
    //   page: () => UserEditProfile(),
    //   binding: UserEditBinding(),
    // ),
    // GetPage(
    //   name: _Paths.specialityScreen,
    //   page: () => SpecialityScreen(),
    //   binding: SpecialityBinding(),
    // ),
    // GetPage(
    //   name: _Paths.specialityDoctorScreen,
    //   page: () => SpecialityDoctorScreen(),
    //   binding: SpecialityDoctorBinding(),
    // ),
    // GetPage(
    //   name: _Paths.doctorDetailScreen,
    //   page: () => DoctorDetailScreen(),
    //   binding: DoctorDetailBinding(),
    // ),
    // GetPage(
    //   name: _Paths.doctorReviewScreen,
    //   page: () => ReviewsScreen(),
    //   binding: ReviewBinding(),
    // ),
    // GetPage(
    //   name: _Paths.loginUserScreen,
    //   page: () => LoginAsUser(),
    //   binding: UserLoginBinding(),
    // ),
    // GetPage(
    //   name: _Paths.makeAppointmentScreen,
    //   page: () => MakeAppointment(),
    //   binding: MakeAppointmentBinding(),
    // ),
    // GetPage(
    //   name: _Paths.inAppWebViewScreen,
    //   page: () => InAppWebViewScreen(),
    //   binding: InAppWebViewBinding(),
    // ),
    // GetPage(
    //   name: _Paths.patientRegisterScreen,
    //   page: () => RegisterAsPatient(),
    //   binding: RegisterPatientBinding(),
    // ),
    // GetPage(
    //   name: _Paths.uAppointmentDetailScreen,
    //   page: () => UserAppointmentDetailsScreen(),
    //   binding: UserAppointmentDetailsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.uAllAppointmentsScreen,
    //   page: () => UAllAppointments(),
    //   binding: UAllAppointmentsBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dAllNearbyScreen,
    //   page: () => DAllNearbyScreen(),
    //   binding: DAllNearbyBinding(),
    // ),
    // GetPage(
    //   name: _Paths.dSearchScreen,
    //   page: () => DoctorSearchScreen(),
    //   binding: DoctorSearchBinding(),
    // ),
    // GetPage(
    //   name: _Paths.pharmacyMedicineScreen,
    //   page: () => PharmacyMedicineScreen(),
    //   binding: PharmacyMedicineBinding(),
    // ),
    // GetPage(
    //   name: _Paths.viewCartMedicineScreen,
    //   page: () => ViewCartScreen(),
    //   binding: ViewCartBinding(),
    // ),
    // GetPage(
    //   name: _Paths.medicineOrderScreen,
    //   page: () => MedicineOrderScreen(),
    //   binding: MedicineOrderBinding(),
    // ),
    // GetPage(
    //   name: _Paths.selectAddressScreen,
    //   page: () => SelectAddressScreen(),
    //   binding: SelectAddressBinding(),
    // ),
    // GetPage(
    //   name: _Paths.addressAddUpdateScreen,
    //   page: () => AddressAddUpdateScreen(),
    //   binding: AddressAddUpdateBinding(),
    // ),
  ];
}
