import 'dart:ui';
import 'package:medlink/utils/app_imports.dart';
import 'package:medlink/common/controllers/messages_controller.dart';

class MessagesDetailScreen extends GetView<MessagesController> {
  MessagesDetailScreen({super.key});

  final MessagesController s = Get.put(MessagesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white.withValues(alpha: 0.5),
        automaticallyImplyLeading: false,
        toolbarHeight: 80,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: Container(
                    width: 45,
                    height: 45,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.background,
                    ),
                    child: const Center(
                      child: Icon(Icons.arrow_back, color: AppColors.primaryText),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'conversation'.tr,
                      style: const TextStyle(
                        color: AppColors.secondaryText,
                        fontSize: 13,
                        fontFamily: AppFontStyleTextStrings.regular,
                      ),
                    ),
                    const Text(
                      'Stanley Cohen',
                      style: TextStyle(
                        color: AppColors.primaryText,
                        fontSize: 16,
                        fontFamily: AppFontStyleTextStrings.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const CircleAvatar(radius: 25, backgroundImage: AssetImage('assets/images/demoAvt.jpg')),
          ],
        ),
        flexibleSpace: ClipRRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              return ListView.builder(
                itemCount: s.messagesDetail.length,
                itemBuilder: (context, index) {
                  final message = s.messagesDetail[index];
                  return Padding(
                    padding: index == 0
                        ? const EdgeInsets.only(top: 10)
                        : const EdgeInsets.only(top: 0),
                    child: Column(
                      crossAxisAlignment: message.isSender
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment: message.isSender
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (message.isFile) ...[
                                if ([
                                  'jpg',
                                  'jpeg',
                                  'png',
                                  'gif',
                                ].contains(message.fileExtension)) ...[
                                  Container(
                                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    width: MediaQuery.of(context).size.width * 0.65,
                                    height: 200,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: message.fileUrl.contains("assets/image/demoImage.jpg")
                                          ? Image.asset(message.fileUrl, fit: BoxFit.cover)
                                          : Image.file(File(message.fileUrl), fit: BoxFit.cover),
                                    ),
                                  ),
                                ] else ...[
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: MediaQuery.of(context).size.width * 0.7,
                                    ),
                                    margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                    padding: const EdgeInsets.all(12.0),
                                    decoration: BoxDecoration(
                                      color: message.isSender
                                          ? AppColors.dividers
                                          : AppColors.primary50,
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                    child: Row(
                                      children: [
                                        SvgPicture.asset(AppImages.pdf),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              message.fileUrl.length > 14
                                                  ? '${message.fileUrl.substring(0, 14)}... .${message.fileExtension}'
                                                  : ' ${message.fileUrl} .${message.fileExtension}',
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontFamily: AppFontStyleTextStrings.regular,
                                              ),
                                            ),
                                            Text(
                                              "${message.fileSize} MB",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontFamily: AppFontStyleTextStrings.regular,
                                                color: AppColors.secondaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          onPressed: () {},
                                          icon: SvgPicture.asset(AppImages.download),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ] else ...[
                                Container(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width * 0.7,
                                  ),
                                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                                  padding: const EdgeInsets.all(12.0),
                                  decoration: BoxDecoration(
                                    color: message.isSender
                                        ? AppColors.dividers
                                        : AppColors.primary50,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Text(
                                    message.text,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: AppFontStyleTextStrings.regular,
                                    ),
                                  ),
                                ),
                              ],
                              if (index < s.messagesDetail.length - 1) ...[
                                if (s.isWithinFiveMinutes(
                                  message.time,
                                  s.messagesDetail[index + 1].time,
                                  message.isSender,
                                  s.messagesDetail[index + 1].isSender,
                                )) ...[
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      0,
                                      5,
                                      MediaQuery.of(context).size.width * 0.05,
                                      10,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: message.time,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.disable,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                ),
                                              ),
                                              if (s.isNotToday(message.date)) ...[
                                                TextSpan(
                                                  text: ', ${s.convertDateFormat(message.date)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.disable,
                                                    fontFamily: AppFontStyleTextStrings.regular,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ),
                                        if (message.isSender) ...[
                                          const SizedBox(width: 5),
                                          SvgPicture.asset(
                                            AppImages.checkBroken,
                                            colorFilter: const ColorFilter.mode(
                                              AppColors.disable,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ],
                              ] else ...[
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    0,
                                    5,
                                    MediaQuery.of(context).size.width * 0.05,
                                    10,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      RichText(
                                        text: TextSpan(
                                          children: [
                                            if (s.isJustNow(message.time)) ...[
                                              const TextSpan(
                                                text: 'Just now',
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.disable,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                ),
                                              ),
                                            ] else ...[
                                              TextSpan(
                                                text: message.time,
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: AppColors.disable,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                ),
                                              ),
                                              if (s.isNotToday(message.date))
                                                TextSpan(
                                                  text: ', ${s.convertDateFormat(message.date)}',
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                    color: AppColors.disable,
                                                    fontFamily: AppFontStyleTextStrings.regular,
                                                  ),
                                                ),
                                            ],
                                          ],
                                        ),
                                      ),
                                      if (message.isSender) ...[
                                        const SizedBox(width: 5),
                                        SvgPicture.asset(
                                          AppImages.checkBroken,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.disable,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            }),
          ),
          Obx(() {
            if (s.selectedFiles.isNotEmpty) {
              return Container(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 140,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: s.selectedFiles.length,
                    itemBuilder: (context, index) {
                      final file = s.selectedFiles[index];
                      return Stack(
                        alignment: Alignment.topRight,
                        children: [
                          Container(
                            margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                            padding: const EdgeInsets.fromLTRB(2, 4, 2, 0),
                            width: 120,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              color: AppColors.background,
                            ),
                            child: Column(
                              children: [
                                SizedBox(
                                  width: 110,
                                  height: 104,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child:
                                        file.extension != null &&
                                            [
                                              'jpg',
                                              'jpeg',
                                              'png',
                                              'gif',
                                            ].contains(file.extension!.toLowerCase())
                                        ? Image.file(File(file.path!), fit: BoxFit.cover)
                                        : Container(
                                            padding: const EdgeInsets.fromLTRB(35, 30, 35, 30),
                                            decoration: const BoxDecoration(color: AppColors.white),
                                            child: SvgPicture.asset(
                                              AppImages.pdf,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Builder(
                                  builder: (context) {
                                    String fileNameWithoutExtension = s.getFileNameWithoutExtension(
                                      file.name,
                                    );
                                    const int fileNameCharacterLimit = 18;
                                    bool isFileNameTooLong =
                                        fileNameWithoutExtension.length > fileNameCharacterLimit;

                                    if (isFileNameTooLong) {
                                      return Container(
                                        width: 120,
                                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Expanded(
                                              child: Text(
                                                fileNameWithoutExtension.substring(
                                                  0,
                                                  fileNameCharacterLimit,
                                                ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10,
                                                  fontFamily: AppFontStyleTextStrings.regular,
                                                  color: AppColors.primaryText,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              '.${file.extension?.toLowerCase()}',
                                              style: const TextStyle(
                                                fontSize: 10,
                                                fontFamily: AppFontStyleTextStrings.regular,
                                                color: AppColors.primaryText,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    } else {
                                      return SizedBox(
                                        width: 120,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Text(
                                            file.name,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                              fontSize: 10,
                                              fontFamily: AppFontStyleTextStrings.regular,
                                              color: AppColors.primaryText,
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: GestureDetector(
                              onTap: () {
                                s.removeSelectedFile(file);
                              },
                              child: Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.1),
                                      spreadRadius: 0.1,
                                      blurRadius: 10,
                                      offset: const Offset(0, -2), // Shadow position upwards
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.close, color: Colors.black, size: 16),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: controller.messageController,
              maxLines: 4,
              minLines: 1,
              decoration: InputDecoration(
                hintText: "type_message".tr,
                hintStyle: const TextStyle(
                  color: AppColors.disable,
                  fontSize: 16,
                  fontFamily: AppFontStyleTextStrings.regular,
                ),
                contentPadding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50.0),
                  borderSide: const BorderSide(color: AppColors.border, width: 1.0),
                ),
                filled: true,
                fillColor: AppColors.white,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: IconButton(
                    icon: SvgPicture.asset(
                      AppImages.attachment,
                      colorFilter: const ColorFilter.mode(AppColors.primaryText, BlendMode.srcIn),
                    ),
                    onPressed: () {
                      s.pickFiles();
                    },
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.only(right: 2.0),
                  child: Container(
                    width: 45,
                    height: 45,
                    margin: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.primary600,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: SvgPicture.asset(AppImages.send),
                      onPressed: () {
                        s.sendMessage();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
