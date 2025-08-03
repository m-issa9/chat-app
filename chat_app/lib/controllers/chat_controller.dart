import 'dart:convert';
import 'package:get/get.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/message_model.dart';

class ChatController extends GetxController {
  late WebSocketChannel channel;
  var messages = <MessageModel>[].obs;

  late String sender;
  late String recipient;


  String get chatKey {
    final users = [sender, recipient]..sort();
    return 'chat_${users.join("_")}';
  }

  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments as Map<String, String>;
    sender = args['sender']!;
    recipient = args['recipient']!;

    loadMessages();

    final room = [sender, recipient]..sort();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://10.0.2.2:8000/ws/chat/${room.join("_")}/'),
    );

    channel.stream.listen((data) {
      final decoded = jsonDecode(data);
      final incomingMsg = MessageModel.fromJson(decoded);


      int index = messages.indexWhere(
            (msg) =>
        msg.message == incomingMsg.message &&
            msg.sender == incomingMsg.sender &&
            msg.sending == true,
      );

      if (index != -1) {
        messages[index].sending = false;
        messages[index] = messages[index];
      } else {
        messages.add(incomingMsg);
      }

      saveMessages();
    });
  }


  Future<void> loadMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(chatKey) ?? [];
    messages.value = stored
        .map((e) => MessageModel.fromJson(jsonDecode(e)))
        .toList();
  }


  Future<void> saveMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList(chatKey, stored);
  }


  void sendMessage(String text) {
    if (text.trim().isEmpty) return;

    final localMsg = MessageModel(
      sender: sender,
      message: text.trim(),
      sending: true,
    );

    messages.add(localMsg);
    saveMessages();

    final messageData = {
      'sender': sender,
      'recipient': recipient,
      'message': text.trim(),
    };

    channel.sink.add(jsonEncode(messageData));
  }

  @override
  void onClose() {
    channel.sink.close();
    super.onClose();
  }
}
