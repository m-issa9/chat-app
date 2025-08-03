class MessageModel {
  final String sender;
  final String message;
  bool sending;

  MessageModel({required this.sender, required this.message, this.sending = false});

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      sender: json['sender'],
      message: json['message'],
      sending: false,
    );
  }

  Map<String, dynamic> toJson() => {
    'sender': sender,
    'message': message,
  };
}
