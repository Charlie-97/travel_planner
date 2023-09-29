import 'package:chatview/chatview.dart';

class Data {
  Data();

  final String chatTitle = 'PlaceHolderTitle';

  final String aiName = 'Travel Assistant';
  final String aiId = '2';

  final String userName = 'PlaceHolderName';
  final String userId = '1';

  List<Message> messageList = [
    Message(
      id: "1",
      message: "Hello",
      createdAt: DateTime.now(),
      sendBy: "1",
    ),
    Message(
      id:"2",
      message: "message",
      createdAt: DateTime(2023),
      sendBy: "2",
    ),
  ];
}
