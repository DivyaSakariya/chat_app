import 'package:get/get.dart';

class StatusController extends GetxController {
  late RxMap<String, String> status = {
    'email': "diyasakaroya1227@gmail.com",
    'status': "Offline",
  }.obs;

  checkStatus({required String email, required String currentStatus}) {
    status({
      'email': email,
      'status': currentStatus,
    });
  }
}
