import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String sender;
  final String recipient;

  ChatScreen({required this.sender, required this.recipient});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late WebSocketChannel channel;
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];

  String get chatKey {
    final users = [widget.sender, widget.recipient]..sort();
    return 'chat_${users.join("_")}';
  }

  @override
  void initState() {
    super.initState();
    loadLocalMessages();
    final room = [widget.sender, widget.recipient]..sort();
    channel = WebSocketChannel.connect(
      Uri.parse('ws://127.0.0.1:8000/ws/chat/${room.join("_")}/'),
    );

    channel.stream.listen((data) {
      final msg = jsonDecode(data);
      final newMsg = {
        "sender": msg['sender'],
        "message": msg['message'],
      };
      setState(() {
        messages.add(msg);
      });
      saveMessage(msg);
    });
  }

  Future<void> loadLocalMessages() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(chatKey) ?? [];
    setState(() {
      messages = stored.map((e) => Map<String, String>.from(jsonDecode(e))).toList();
    });
  }

  Future<void> saveMessage(Map<String, String> message) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getStringList(chatKey) ?? [];
    stored.add(jsonEncode(message));
    await prefs.setStringList(chatKey, stored);
  }

  void _sendMessage() {
    if (_controller.text.isNotEmpty) {
      final messageData = {
        'message': _controller.text,
        'sender': widget.sender,
        'recipient': widget.recipient,
      };
      channel.sink.add(jsonEncode(messageData));
      final localMsg = {
        'sender': widget.sender,
        'message': _controller.text,
      };
      setState(() {
        messages.add(localMsg);
      });
      saveMessage(localMsg);
      _controller.clear();
    }
  }

  @override
  void dispose() {
    channel.sink.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${widget.recipient}')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: messages.map((msg) {
                bool isMe = msg['sender'] == widget.sender;
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.green[100] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(msg['message'] ?? ''),
                  ),
                );
              }).toList(),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(child: TextField(controller: _controller)),
                IconButton(icon: Icon(Icons.send), onPressed: _sendMessage),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
