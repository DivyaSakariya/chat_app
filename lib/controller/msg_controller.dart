import 'package:get/get.dart';

class MsgController extends GetxController {
  RxBool editMode = false.obs;

  canEdit() {
    editMode(!editMode.value);
  }
}
