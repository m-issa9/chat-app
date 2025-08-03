import 'package:get/get.dart';
import '../views/chat_screen.dart';
import '../views/user_selector_screen.dart';

class AppRoutes {
  static const String selector = '/';
  static const String chat = '/chat';

  static final routes = [
    GetPage(
      name: selector,
      page: () => UserSelectorScreen(),
    ),
    GetPage(
      name: chat,
      page: () => ChatScreen(),
    ),
  ];
}
