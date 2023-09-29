import 'package:flutter/material.dart';
import 'package:chatview/chatview.dart';
import 'package:travel_planner/app/presentation/chat/widgets/chat_bubble.dart';
import 'package:travel_planner/data.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chat";
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUser = ChatUser(
    id: Data().userId,
    name: Data().userName,
    // profilePhoto: Data.profileImage,
  );
  final _chatController = ChatController(
    initialMessageList: Data().messageList,
    scrollController: ScrollController(),
    chatUsers: [
      ChatUser(
        id: Data().aiId,
        name: Data().aiName,
        // profilePhoto: Data.profileImage,
      ),
    ],
  );

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final id = int.parse(Data().messageList.last.id) + 1;
    _chatController.addMessage(
      Message(
        id: id.toString(),
        createdAt: DateTime.now(),
        message: message,
        sendBy: currentUser.id,
        replyMessage: replyMessage,
        messageType: messageType,
      ),
    );
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ChatView(
        appBar: ChatViewAppBar(
          chatTitle: Data().chatTitle,
          backGroundColor: Colors.blue[50],
          elevation: 5.0,
        ),
        chatBackgroundConfig: ChatBackgroundConfiguration(
          backgroundColor: /*Theme.of(context).colorScheme.background*/
              Colors.blue[50],
        ),
        sendMessageConfig: SendMessageConfiguration(
          textFieldBackgroundColor: Colors.blue[30],
          textFieldConfig: const TextFieldConfiguration(
            borderRadius: BorderRadius.all(Radius.circular(12)),
            textStyle: TextStyle(
              color: Colors.black,
            ),
          ),
          enableCameraImagePicker: false,
          enableGalleryImagePicker: false,
          allowRecordingVoice: false,
        ),
        chatController: _chatController,
        onSendTap: _onSendTap,
        currentUser: currentUser,
        chatViewState: Data().messageList.isNotEmpty
            ? ChatViewState.hasMessages
            : ChatViewState.loading,
        chatBubbleConfig: ChatBubbleConfiguration(
          maxWidth: MediaQuery.of(context).size.width,
          inComingChatBubbleConfig:
              chatBubble(color: Colors.blue[400], textColor: Colors.white),
          outgoingChatBubbleConfig:
              chatBubble(color: Colors.blue[200], textColor: Colors.black),
        ),
      ),
    );
  }
}
