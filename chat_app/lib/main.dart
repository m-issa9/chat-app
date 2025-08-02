import 'package:flutter/material.dart';
import 'chat_screen.dart';

void main() {
  runApp(MaterialApp(
    title: 'Private Chat Demo',
    debugShowCheckedModeBanner: false,
    home: UserSelector(),
  ));
}

class UserSelector extends StatefulWidget {
  @override
  _UserSelectorState createState() => _UserSelectorState();
}

class _UserSelectorState extends State<UserSelector> {
  final List<String> users = ['a', 'b', 'c'];
  String? selectedSender;
  String? selectedRecipient;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Choose Sender & Recipient')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              hint: Text("Select Sender"),
              value: selectedSender,
              isExpanded: true,
              items: users.map((user) {
                return DropdownMenuItem(value: user, child: Text(user.toUpperCase()));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedSender = val;
                  if (selectedRecipient == val) selectedRecipient = null;
                });
              },
            ),
            SizedBox(height: 10),
            DropdownButton<String>(
              hint: Text("Select Recipient"),
              value: selectedRecipient,
              isExpanded: true,
              items: users.where((u) => u != selectedSender).map((user) {
                return DropdownMenuItem(value: user, child: Text(user.toUpperCase()));
              }).toList(),
              onChanged: (val) {
                setState(() {
                  selectedRecipient = val;
                });
              },
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: selectedSender != null && selectedRecipient != null
                  ? () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(
                      sender: selectedSender!,
                      recipient: selectedRecipient!,
                    ),
                  ),
                );
              }
                  : null,
              child: Text("Start Chat"),
            )
          ],
        ),
      ),
    );
  }
}
