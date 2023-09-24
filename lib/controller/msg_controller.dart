import 'package:get/get.dart';

class MsgController extends GetxController {
  RxBool editMode = false.obs;

  isEdit() {
    editMode(!editMode.value);
  }
}
