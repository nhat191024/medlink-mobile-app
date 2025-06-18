import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  final double imageBgHeightRatio = 0.6;
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.color3,
      body: Obx(
        () => Stack(
          children: [
            if (controller.isLoading.value) ...[
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            ] else ...[
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: Get.height * imageBgHeightRatio,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(AppImages.splashBg),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: Get.height * 0.54,
                left: 0,
                right: 0,
                child: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: Get.height * 0.46,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.color3.withOpacity(0.5),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'splash_title'.tr,
                            style: const TextStyle(fontSize: 28, fontFamily: AppFontStyleTextStrings.semiBold),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 25),
                          ElevatedButton(
                            onPressed: () {
                              Get.toNamed(Routes.loginScreen);
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: AppColors.BLACK,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(
                              'login'.tr,
                              style: const TextStyle(fontSize: 16, fontFamily: AppFontStyleTextStrings.bold),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: ElevatedButton(
                              onPressed: () {
                                Get.toNamed(Routes.telephoneScreen);
                              },
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 50),
                                backgroundColor: AppColors.WHITE,
                                shape:
                                    RoundedRectangleBorder(borderRadius: BorderRadius.circular(25), side: const BorderSide(color: AppColors.BLACK)),
                              ),
                              child: Text(
                                'sign_up'.tr,
                                style: const TextStyle(color: AppColors.BLACK, fontSize: 16, fontFamily: AppFontStyleTextStrings.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: AppColors.greyShade3,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                ),
                                Text('or'.tr,
                                    style: TextStyle(
                                      color: AppColors.grey,
                                      fontSize: 14,
                                      fontFamily: AppFontStyleTextStrings.regular,
                                    )),
                                Expanded(
                                  child: Divider(
                                    color: AppColors.greyShade3,
                                    thickness: 1,
                                    indent: 10,
                                    endIndent: 10,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 15.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (Platform.isIOS)
                                  Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.WHITE, boxShadow: [
                                      BoxShadow(
                                        color: AppColors.BLACK.withOpacity(0.1),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 0),
                                      )
                                    ]),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SvgPicture.asset(
                                        AppImages.appleIcon,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.WHITE, boxShadow: [
                                    BoxShadow(
                                      color: AppColors.BLACK.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    )
                                  ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                      AppImages.googleIcon,
                                      fit: BoxFit.fill,
                                      width: 20,
                                      height: 20,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 50,
                                  height: 50,
                                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                                  decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.WHITE, boxShadow: [
                                    BoxShadow(
                                      color: AppColors.BLACK.withOpacity(0.1),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: const Offset(0, 0),
                                    )
                                  ]),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: SvgPicture.asset(
                                      AppImages.linkedinIcon,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                right: 20,
                child: Image.asset(
                  AppImages.logo,
                  width: 70,
                  height: 70,
                ),
              )
            ],
          ],
        ),
      ),
    );
  }
}
