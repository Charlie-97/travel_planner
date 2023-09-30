import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/chat/widgets/chat_bubble.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/data/model/conversation.dart';
import 'package:travel_planner/data/model/message.dart';
import 'package:travel_planner/objectbox.g.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chat";
  const ChatScreen({super.key, required this.conversation});
  final ObjConversation conversation;
  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Box<ObjConversation> box = objectbox.store.box<ObjConversation>();

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
            sendBy: element.sentBy,
          ),
        )
        .toList();
    if (messages.isEmpty) {
      messages.add(
        Message(
          id: "1",
            message:
                "Hello Traveler! 👋 \n\nHow can I assist you today with your travel plans?",
            createdAt: DateTime.now(),
            sendBy: "AI"),
      );
      addMessageTolocalDB(
        message:
            "Hello Traveler! 👋 \n\nHow can I assist you today with your travel plans?",
        sentBy: "AI",
        createdAt: DateTime.now(),
      );
    }
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

  void addMessageTolocalDB(
      {required String message,
      required DateTime createdAt,
      required String sentBy}) {
    widget.conversation.messages.add(
      ObjMessage(
        text: message,
        createdAt: createdAt,
        sentBy: sentBy,
      ),
    );
    box.put(widget.conversation);
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

    addMessageTolocalDB(
      message: message,
      createdAt: DateTime.now(),
      sentBy: currentUser.id,
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
      // backgroundColor: /*Theme.of(context).colorScheme.background*/
      //     Colors.blue[50],
      body: SafeArea(
        child: _chatController != null
            ? ChatView(
                appBar: AppBar(
                  title: const Text("TRAVEL PLANNER"),
                  backgroundColor: Colors.transparent,
                  scrolledUnderElevation: 0,
                  // actions: [
                  //   IconButton(
                  //     onPressed: () {},
                  //     icon: const Icon(
                  //       Icons.add_box_outlined,
                  //       size: 30,
                  //     ),
                  //   )
                  // ],
                ),
                
                chatBackgroundConfig: const ChatBackgroundConfiguration(
                    backgroundColor: Colors.transparent),
                sendMessageConfig: SendMessageConfiguration(
                  textFieldBackgroundColor: Colors.blue[50],
                  defaultSendButtonColor: Colors.blue[400],
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
                    : ChatViewState.noData,
                chatBubbleConfig: ChatBubbleConfiguration(
                  maxWidth: MediaQuery.of(context).size.width * .7,
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
                chatViewStateConfig: const ChatViewStateConfiguration(
                    noMessageWidgetConfig:
                        ChatViewStateWidgetConfiguration(widget: SizedBox())),
              )
            : const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularProgressIndicator.adaptive(),
                  ],
                ),
              ),
      ),
    );
  }
}
