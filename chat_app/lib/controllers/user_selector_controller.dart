import 'package:get/get.dart';
import '../routes/app_pages.dart';
import '../controllers/chat_controller.dart';

class UserSelectorController extends GetxController {
  final List<String> users = ['a', 'b', 'c'];
  final RxString selectedSender = ''.obs;
  final RxString selectedRecipient = ''.obs;

  void setSender(String? sender) {
    if (sender == null) return;
    selectedSender.value = sender;
    if (selectedRecipient.value == sender) {
      selectedRecipient.value = '';
    }
  }

  void setRecipient(String? recipient) {
    if (recipient == null) return;
    selectedRecipient.value = recipient;
  }

  void startChat() {
    Get.lazyPut(() => ChatController());

    Get.toNamed(AppRoutes.chat, arguments: {
      'sender': selectedSender.value,
      'recipient': selectedRecipient.value,
    });
  }
}
