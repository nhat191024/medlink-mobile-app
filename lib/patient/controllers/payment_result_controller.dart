import 'package:medlink/utils/app_imports.dart';
import 'package:http/http.dart' as http;

class PaymentResultController extends GetxController {
  final String? token = StorageService.readData(key: LocalStorageKeys.token);

  Future<void> changeBillStatus(String billId, String status) async {
    final uri = Uri.parse('${Apis.api}payment/status');
    final response = http.MultipartRequest("POST", uri);
    response.headers['Authorization'] = 'Bearer $token';
    response.headers['Accept'] = 'application/json';
    response.headers['Content-Type'] = 'application/json';

    response.fields.addAll({'id': billId, 'status': status});

    var streamedResponse = await response.send();
    var responseBody = await streamedResponse.stream.bytesToString();
    var json = jsonDecode(responseBody);

    if (streamedResponse.statusCode == 200) {
      debugPrint('Bill status changed successfully: ${json['message']}');
    } else {
      debugPrint('Failed to change bill status: ${json['message']}');
    }
  }
}
