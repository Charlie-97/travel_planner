import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';
import 'package:travel_planner/app/presentation/chat/widgets/chat_bubble.dart';
import 'package:travel_planner/data/model/conversation.dart';
import 'package:travel_planner/models/sqflite/conversation_model.dart';
import 'package:travel_planner/models/sqflite/message.dart';
import 'package:travel_planner/services/local_storage/sqflite/sqflite_service.dart';
import 'package:uuid/uuid.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = "chat";
  const ChatScreen({
    super.key,
    this.conversation,
    this.conversationModel,
  });
  final ObjConversation? conversation;
  final ConversationModel? conversationModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final SqfLiteService sqlDb = SqfLiteService.instance;
  late ConversationModel conversationModel;
  ScrollController scrollController = ScrollController();
  final uid = const Uuid();

  final currentUser = ChatUser(
    id: "user",
    name: "User",
  );
  ChatController? _chatController;
  List<Message> messages = [];

  dbCheck() async {
    if (widget.conversationModel == null) {
      final id = uid.v1();

      /// Fetch the data from Gpt server and start a new chat to get the Id
      /// And initiate the prompt engineering message
      ConversationModel conversation = ConversationModel(
        id: id,
        gptId: "testing-$id",
        title: "New Conversation",
        updatedAt: DateTime.now(),
      );
      sqlDb.addConversation(conversation);
      conversationModel = conversation;
      final dBmessages = await sqlDb.findMessages(conversationModel.gptId!);
      if (dBmessages.isNotEmpty) {
        messages = dBmessages
            .map(
              (element) => Message(
                id: element.id.toString(),
                message: element.message!,
                createdAt: element.createdAt!,
                sendBy: element.sentBy!,
              ),
            )
            .toList();
        setState(() {});
      } else {
        final id = uid.v1();
        final message = Message(
          id: id,
          message: "Hello Traveller! 👋 \n\nHow can I assist you today with your travel plans?",
          createdAt: DateTime.now(),
          sendBy: "AI",
        );
        addMessageTolocalDB(message);
        messages.add(message);
        setState(() {});
      }
    } else {
      final s = await sqlDb.getConversation(widget.conversationModel!.gptId!);
      if (s != null) {
        conversationModel = s;
        final dBmessages = await sqlDb.findMessages(conversationModel.gptId!);
        if (dBmessages.isNotEmpty) {
          messages = dBmessages.map((element) {
            return Message(
              id: element.id.toString(),
              message: element.message!,
              createdAt: element.createdAt!,
              sendBy: element.sentBy!,
            );
          }).toList();
          setState(() {});
        } else {
          final id = uid.v1();
          final message = Message(
            id: id,
            message: "Hello Traveller! 👋 \n\nHow can I assist you today with your travel plans?",
            createdAt: DateTime.now(),
            sendBy: "AI",
          );
          addMessageTolocalDB(message);
          messages.add(message);
        }
      }
    }
  }

  @override
  void initState() {
    super.initState();
    sqlDb.initMessageStream();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await dbCheck();
      _chatController = ChatController(
        initialMessageList: messages,
        scrollController: scrollController,
        chatUsers: [
          ChatUser(
            id: "AI",
            name: "Travel Bot",
            // profilePhoto: Data.profileImage,
          ),
        ],
      );
    });
  }

  void addMessageTolocalDB(Message message) async {
    final localMessage = LocalMessage(
      id: message.id,
      conversationId: conversationModel.gptId,
      message: message.message,
      sentBy: message.sendBy,
      createdAt: message.createdAt,
      imageUrl: message.messageType == MessageType.image ? message.message : null,
    );
    sqlDb.addMessage(localMessage);
  }

  void _onSendTap(
    String message,
    ReplyMessage replyMessage,
    MessageType messageType,
  ) async {
    final id = uid.v1();
    final newMessage = Message(
      id: id,
      createdAt: DateTime.now(),
      message: message,
      sendBy: currentUser.id,
      replyMessage: replyMessage,
      messageType: messageType,
    );
    addMessageTolocalDB(newMessage);
    _chatController?.addMessage(newMessage);
    Future.delayed(const Duration(milliseconds: 300), () {
      _chatController?.initialMessageList.last.setStatus = MessageStatus.undelivered;
    });
    Future.delayed(const Duration(seconds: 1), () {
      _chatController?.initialMessageList.last.setStatus = MessageStatus.read;
    });
  }

  @override
  void dispose() {
    _chatController?.dispose();
    sqlDb.closeMessageStream();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _chatController != null
            ? ChatView(
                appBar: AppBar(
                  title: Text(conversationModel.title ?? "TRAVEL PLANNER"),
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
                  backgroundColor: Colors.transparent,
                ),
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
                chatViewState: messages.isNotEmpty ? ChatViewState.hasMessages : ChatViewState.noData,
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
                chatViewStateConfig: const ChatViewStateConfiguration(noMessageWidgetConfig: ChatViewStateWidgetConfiguration(widget: SizedBox())),
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
