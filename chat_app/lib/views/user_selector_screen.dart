import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_selector_controller.dart';

class UserSelectorScreen extends StatelessWidget {
  final UserSelectorController controller = Get.put(UserSelectorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Sender & Recipient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() => DropdownButton<String>(
              hint: Text("Select Sender"),
              value: controller.selectedSender.value.isEmpty
                  ? null
                  : controller.selectedSender.value,
              isExpanded: true,
              items: controller.users.map((user) {
                return DropdownMenuItem(
                    value: user, child: Text(user.toUpperCase()));
              }).toList(),
              onChanged: controller.setSender,
            )),
            SizedBox(height: 10),
            Obx(() => DropdownButton<String>(
              hint: Text("Select Recipient"),
              value: controller.selectedRecipient.value.isEmpty
                  ? null
                  : controller.selectedRecipient.value,
              isExpanded: true,
              items: controller.users
                  .where((u) => u != controller.selectedSender.value)
                  .map((user) {
                return DropdownMenuItem(
                    value: user, child: Text(user.toUpperCase()));
              }).toList(),
              onChanged: controller.setRecipient,
            )),
            SizedBox(height: 30),
            Obx(() => ElevatedButton(
              onPressed: controller.selectedSender.value.isNotEmpty &&
                  controller.selectedRecipient.value.isNotEmpty
                  ? controller.startChat
                  : null,
              child: Text("Start Chat"),
            )),
          ],
        ),
      ),
    );
  }
}
