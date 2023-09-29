import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/chat/widgets/chat_bubble.dart';
import 'package:travel_planner/data/model/conversation.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chat";
  const ChatScreen({super.key, required this.conversation});
  final ObjConversation conversation;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final currentUser = ChatUser(
    id: "User",
    name: "User",
    // profilePhoto: Data.profileImage,
  );
  ChatController? _chatController;
  late List<Message> messages;

  @override
  void initState() {
    super.initState();

    messages = widget.conversation.messages
        .map(
          (element) => Message(
            id: element.id.toString(),
              message: element.text,
              createdAt: element.createdAt,
              sendBy: element.sentBy),
        )
        .toList();
    _chatController = ChatController(
      initialMessageList: messages,
      scrollController: ScrollController(),
      chatUsers: [
        ChatUser(
          id: "AI",
          name: "TPA",
          // profilePhoto: Data.profileImage,
        ),
      ],
    );
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) {
    final id = int.parse(messages.last.id) + 1;
    _chatController?.addMessage(
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
      _chatController?.initialMessageList.last.setStatus =
          MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController?.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  @override
  void dispose() {
    _chatController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: /*Theme.of(context).colorScheme.background*/
          Colors.blue[50],
      body: _chatController != null
          ? ChatView(
              appBar: AppBar(
                title: const Text("TRAVEL PLANNER"),
                backgroundColor: Colors.transparent,
                actions: [
                  IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add_box_outlined,
                        size: 30,
                      ))
                ],
              ),
              chatBackgroundConfig: const ChatBackgroundConfiguration(
                  backgroundColor: Colors.transparent),
              sendMessageConfig: SendMessageConfiguration(
                textFieldBackgroundColor: Colors.blue[30],
                textFieldConfig: const TextFieldConfiguration(
                  margin: EdgeInsets.symmetric(horizontal: 8),
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  textStyle: TextStyle(
                    color: Colors.black,
                  ),
                ),
                enableCameraImagePicker: false,
                enableGalleryImagePicker: false,
                allowRecordingVoice: false,
              ),
              chatController: _chatController!,
              onSendTap: _onSendTap,
              currentUser: currentUser,
              chatViewState: messages.isNotEmpty
                  ? ChatViewState.hasMessages
                  : ChatViewState.loading,
              chatBubbleConfig: ChatBubbleConfiguration(
                maxWidth: MediaQuery.of(context).size.width / 2,
                inComingChatBubbleConfig: chatBubble(
                  sentByUser: false,
                  color: Colors.blue[400],
                  textColor: Colors.white,
                ),
                outgoingChatBubbleConfig: chatBubble(
                  sentByUser: true,
                  color: Colors.blue[200],
                  textColor: Colors.black,
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
    );
  }
}
