import 'package:medlink/utils/app_imports.dart';
import 'package:intl/intl.dart';

class Message {
  final String text;
  final bool isSender;
  final bool sended;
  final String time;
  final String date;
  final bool isFile;
  final String fileUrl;
  final String fileSize;
  final String fileExtension;

  Message({
    required this.text,
    required this.isSender,
    required this.sended,
    required this.time,
    required this.date,
    this.isFile = false,
    this.fileUrl = '',
    this.fileSize = '',
    this.fileExtension = '',
  });
}

class MessagesDataDemo {
  final String id;
  final String avatar;
  final String name;
  final String newestMessage;
  final String time;
  final bool isRead;
  final int unreadMessages;

  MessagesDataDemo({
    required this.id,
    required this.avatar,
    required this.name,
    required this.newestMessage,
    required this.time,
    required this.isRead,
    required this.unreadMessages,
  });
}

class MessagesController extends GetxController {
  final List<MessagesDataDemo> messages = <MessagesDataDemo>[
    MessagesDataDemo(
      id: '1',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Dr. John Doe',
      newestMessage:
          'Hello, how are you? Hello, how are you? Hello, how are you? Hello, how are you?',
      time: '10m',
      isRead: false,
      unreadMessages: 2,
    ),
    MessagesDataDemo(
      id: '2',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Jane',
      newestMessage: 'Hello, how are you?',
      time: '2m',
      isRead: false,
      unreadMessages: 1,
    ),
    MessagesDataDemo(
      id: '3',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Dr. James',
      newestMessage: 'Hello, how are you?',
      time: '13m',
      isRead: true,
      unreadMessages: 0,
    ),
    MessagesDataDemo(
      id: '4',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Isabella',
      newestMessage: 'Hello, how are you?',
      time: '20m',
      isRead: true,
      unreadMessages: 0,
    ),
    MessagesDataDemo(
      id: '5',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Rita',
      newestMessage: 'Hello, how are you?',
      time: '1h',
      isRead: true,
      unreadMessages: 0,
    ),
    MessagesDataDemo(
      id: '6',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Micheal',
      newestMessage: 'Hello, how are you?',
      time: '45m',
      isRead: true,
      unreadMessages: 0,
    ),
    MessagesDataDemo(
      id: '7',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Dr. John Doe',
      newestMessage: 'Hello, how are you?',
      time: '1m',
      isRead: true,
      unreadMessages: 0,
    ),
    MessagesDataDemo(
      id: '8',
      avatar: 'assets/images/demoAvt.jpg',
      name: 'Dr. Jane Doe',
      newestMessage: 'Hello, how are you?',
      time: '9m',
      isRead: true,
      unreadMessages: 0,
    ),
  ];

  final RxList<Message> messagesDetail = <Message>[
    Message(
      text: 'Thank you for booking an appointment with me.',
      isSender: true,
      sended: true,
      time: '10:00',
      date: '2024-10-31',
    ),
    Message(
      text: 'And if you have any questions or inquires do let me know.',
      isSender: true,
      sended: true,
      time: '10:01',
      date: '2024-10-31',
    ),
    Message(text: 'Hi, Doctor', isSender: false, sended: true, time: '10:02', date: '2024-11-01'),
    Message(
      text: 'Can my wife also be present for the meeting?',
      isSender: false,
      sended: true,
      time: '10:04',
      date: '2024-11-01',
    ),
    Message(
      text: 'Yes, it won’t be a problem.',
      isSender: true,
      sended: true,
      time: '15:01',
      date: '2024-11-01',
    ),
    Message(
      text: '',
      isSender: false,
      sended: true,
      time: '14:01',
      date: '2024-11-01',
      isFile: true,
      fileUrl: 'assets/images/demoImage.jpg',
      fileSize: '1.2 MB',
      fileExtension: 'jpg',
    ),
    Message(
      text: 'Here is the prescription for the medicine you need to take.',
      isSender: true,
      sended: true,
      time: '14:01',
      date: '2024-11-01',
      isFile: true,
      fileUrl: 'Prescription-medicine',
      fileSize: '82',
      fileExtension: 'pdf',
    ),
    // Message(
    //   text: 'Hello, how are you?',
    //   isSender: false,
    //   sended: true,
    //   time: '10:07',
    //   date: '2024-10-20',
    // ),
  ].obs;

  late String id;
  late int totalMessage;

  final TextEditingController messageController = TextEditingController();

  var selectedFiles = <PlatformFile>[].obs;

  Future<void> pickFiles() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(allowMultiple: true);

      if (result != null) {
        // print(result.files);
        selectedFiles.addAll(result.files);
        // Optionally, you can start uploading files here using flutter_uploader
        // uploadFiles(result.files);
      }
    } catch (e) {
      // print('Error picking files: $e');
    }
  }

  //   Future<void> uploadFiles(List<PlatformFile> files) async {
  //   FlutterUploader uploader = FlutterUploader();
  //   for (var file in files) {
  //     final taskId = await uploader.enqueue(
  //       RawUpload(
  //         url: 'YOUR_UPLOAD_URL',
  //         path: file.path!,
  //         method: UploadMethod.POST,
  //         headers: {"key": "value"},
  //         data: {"fieldname": "value"},
  //       ),
  //     );
  //     Handle taskId if needed
  //   }
  // }

  void removeSelectedFile(PlatformFile file) {
    selectedFiles.remove(file);
  }

  final RxList<MessagesDataDemo> filteredMessages = <MessagesDataDemo>[].obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    totalMessage = messages.length;
    filteredMessages.assignAll(messages);
    super.onInit();
  }

  void searchMessages(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredMessages.assignAll(messages);
    } else {
      filteredMessages.assignAll(
        messages
            .where((message) => message.name.toLowerCase().contains(query.toLowerCase()))
            .toList(),
      );
    }
  }

  bool isNotToday(String dateString) {
    final now = DateTime.now();

    final date = DateFormat("yyyy-MM-dd").parse(dateString);
    return !(date.year == now.year && date.month == now.month && date.day == now.day);
  }

  String convertDateFormat(String dateString) {
    DateTime date = DateFormat("yyyy-MM-dd").parse(dateString);
    return DateFormat("dd/MM/yy").format(date);
  }

  bool isWithinFiveMinutes(String time1, String time2, bool user1, bool user2) {
    if (user1 != user2) return true;

    final format = DateFormat("HH:mm");
    DateTime dateTime1 = format.parse(time1);
    DateTime dateTime2 = format.parse(time2);

    int totalMinutes1 = dateTime1.hour * 60 + dateTime1.minute;
    int totalMinutes2 = dateTime2.hour * 60 + dateTime2.minute;

    final difference = (totalMinutes1 - totalMinutes2).abs();

    return difference > 5;
  }

  bool isJustNow(String time) {
    final now = DateTime.now();
    final format = DateFormat("HH:mm");

    DateTime dateTime = format.parse(time);

    final difference = (now.hour * 60 + now.minute) - (dateTime.hour * 60 + dateTime.minute);

    return difference.abs() < 1;
  }

  void sendMessage() async {
    if (messageController.text.isNotEmpty) {
      messagesDetail.add(
        Message(
          text: messageController.text,
          isSender: true,
          sended: true,
          time: DateFormat("HH:mm").format(DateTime.now()),
          date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
        ),
      );
      messageController.clear();
    } else if (selectedFiles.isNotEmpty) {
      for (var file in selectedFiles) {
        var fileExtension = getFileExtension(file.name);
        var isImage = ['jpg', 'jpeg', 'png', 'gif'].contains(fileExtension.toLowerCase());

        // For images, use the complete file path
        var fileUrl = isImage ? file.path! : getFileNameWithoutExtension(file.name);

        messagesDetail.add(
          Message(
            text: '',
            isSender: true,
            sended: true,
            time: DateFormat("HH:mm").format(DateTime.now()),
            date: DateFormat("yyyy-MM-dd").format(DateTime.now()),
            isFile: true,
            fileUrl: fileUrl,
            fileSize: '${(file.size / 1024 / 1024).toStringAsFixed(2)} MB',
            fileExtension: fileExtension,
          ),
        );
      }
      selectedFiles.clear();
    }
  }

  String getFileNameWithoutExtension(String fileName) {
    int lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return fileName;
    return fileName.substring(0, lastDot);
  }

  String getFileExtension(String fileName) {
    int lastDot = fileName.lastIndexOf('.');
    if (lastDot == -1) return '';
    return fileName.substring(lastDot + 1);
  }
}
