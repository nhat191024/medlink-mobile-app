import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/messages_controller.dart';

class MessagesScreen extends GetView<MessagesController> {
  MessagesScreen({super.key});

  final MessagesController controllers = Get.put(
    MessagesController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('${"message".tr} (${controllers.totalMessage})'),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: const TextStyle(
          color: AppColors.primaryText,
          fontSize: 18,
          fontFamily: AppFontStyleTextStrings.bold,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Row(
                children: [
                  SvgPicture.asset(AppImages.searchIcon),
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      onChanged: controllers.searchMessages,
                      decoration: InputDecoration(
                        hintText: 'search_by_name'.tr,
                        hintStyle: const TextStyle(
                          color: AppColors.disable,
                          fontSize: 16,
                          fontFamily: AppFontStyleTextStrings.regular,
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                if (controllers.filteredMessages.isEmpty) ...[
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppImages.mailBox,
                          scale: 1,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'no_message'.tr,
                          style: const TextStyle(
                            color: AppColors.primaryText,
                            fontSize: 20,
                            fontFamily: AppFontStyleTextStrings.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(40, 10, 40, 0),
                          child: Text(
                            'no_message_description'.tr,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.secondaryText,
                              fontSize: 14,
                              fontFamily: AppFontStyleTextStrings.regular,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Obx(() => ListView.builder(
                        itemCount: controllers.filteredMessages.length + 1,
                        itemBuilder: (context, index) {
                          if (index == controllers.filteredMessages.length) {
                            return Column(
                              children: [
                                const Divider(color: AppColors.dividers),
                                Padding(
                                  padding: const EdgeInsets.all(20.0),
                                  child: Center(
                                    child: Text(
                                      'no_further_message'.tr,
                                      style: const TextStyle(
                                        color: AppColors.disable,
                                        fontSize: 14,
                                        fontFamily: AppFontStyleTextStrings.regular,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }
                          final message = controllers.filteredMessages[index];
                          return Column(
                            children: [
                              if (index != 0) const Divider(color: AppColors.dividers),
                              GestureDetector(
                                onTap: () {
                                  Get.toNamed(Routes.detailMessageScreen);
                                  controllers.id = message.id;
                                },
                                child: Container(
                                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundImage: AssetImage(message.avatar),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  message.name,
                                                  style: TextStyle(
                                                    color: message.isRead ? AppColors.primaryText : AppColors.primary600,
                                                    fontSize: 14,
                                                    fontFamily: AppFontStyleTextStrings.bold,
                                                  ),
                                                ),
                                                const Spacer(),
                                                Text(
                                                  message.time,
                                                  style: const TextStyle(
                                                    color: AppColors.disable,
                                                    fontSize: 12,
                                                    fontFamily: AppFontStyleTextStrings.regular,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 5),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    message.newestMessage,
                                                    style: TextStyle(
                                                      color: message.isRead ? AppColors.secondaryText : AppColors.primary600,
                                                      fontSize: 13,
                                                      fontFamily: message.isRead ? AppFontStyleTextStrings.regular : AppFontStyleTextStrings.medium,
                                                    ),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                                if (message.unreadMessages > 0) ...[
                                                  Container(
                                                    padding: const EdgeInsets.all(7),
                                                    decoration: const BoxDecoration(
                                                      color: AppColors.primary600,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Text(
                                                      message.unreadMessages.toString(),
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontFamily: AppFontStyleTextStrings.regular,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
