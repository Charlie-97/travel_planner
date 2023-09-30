import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/app/presentation/chat/screen/chat_screen.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/component/overlays/dialogs.dart';
import 'package:travel_planner/data/model/conversation.dart';
import 'package:travel_planner/models/sqflite/conversation_model.dart';
import 'package:travel_planner/services/local_storage/sqflite/sqflite_service.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final SqfLiteService sqlDb = SqfLiteService.instance;
  final Box<ObjConversation> box = objectbox.store.box<ObjConversation>();

  List<ConversationModel> conversations = [];

  getConversations() async {
    final allConversation = await sqlDb.getAllConversation();
    if (allConversation.isNotEmpty) {
      conversations = allConversation;
      conversations.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
    setState(() {});
  }

  refreshConversations() async {
    final allConversation = await sqlDb.getAllConversation();
    if (allConversation.isNotEmpty) {
      conversations.clear();
      conversations = allConversation;
      conversations.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
    }
    setState(() {});
  }

  exitingConversations(String chatId) async {
    await sqlDb.getConversationExit(chatId);
  }

  @override
  void initState() {
    super.initState();
    sqlDb.initConversationStream();
    getConversations();
    sqlDb.conversationStream.stream.listen((event) async {
      if (event.isNotEmpty) {
        if (event.length == 1) {
          if (!mounted) {
            return;
          }
          final s = await sqlDb.getConversation(event.first.gptId!);
          final check = conversations.where((element) => element.gptId == event.first.gptId);
          if (check.isNotEmpty) {
            final index = conversations.indexWhere((element) => element.gptId == event.first.gptId);
            conversations.removeAt(index);
            if (s != null) {
              conversations.insert(index, s);
            } else {
              conversations.insert(index, event.first);
            }
          } else {
            if (s != null) {
              conversations.insert(0, s);
            } else {
              conversations.insert(0, event.first);
            }
          }
          conversations.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
        }
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "TRAVEL PLANNER",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
      // drawer: Drawer(
      //   child: Column(
      //     mainAxisAlignment: MainAxisAlignment.start,
      //     crossAxisAlignment: CrossAxisAlignment.stretch,
      //     children: [
      //       Container(
      //         height: 240,
      //         color: Colors.blue[400],
      //         padding: const EdgeInsets.symmetric(horizontal: 24),
      //         child: const SafeArea(
      //           child: Column(
      //             crossAxisAlignment: CrossAxisAlignment.start,
      //             children: [
      //               SizedBox(height: 10),
      //               CircleAvatar(
      //                 radius: 35,
      //                 child: Icon(
      //                   Icons.person,
      //                   size: 40,
      //                 ),
      //               ),
      //               SizedBox(height: 10),
      //               Expanded(
      //                 child: Column(
      //                   mainAxisAlignment: MainAxisAlignment.start,
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Text(
      //                       "Mr Travel Planner",
      //                       style: TextStyle(
      //                         fontSize: 20,
      //                         fontWeight: FontWeight.w600,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                     SizedBox(height: 5),
      //                     Text(
      //                       "travelplanner@gmail.com",
      //                       style: TextStyle(
      //                         fontSize: 14,
      //                         fontWeight: FontWeight.w400,
      //                         color: Colors.white,
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 30),
      //       InkWell(
      //         onTap: () {},
      //         overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      //         child: const Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 24),
      //           child: Row(
      //             children: [
      //               Icon(
      //                 Icons.payment,
      //               ),
      //               SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      //                 "Payment",
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.w500,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const Spacer(),
      //       InkWell(
      //         onTap: () {},
      //         overlayColor: const MaterialStatePropertyAll(Colors.transparent),
      //         child: const Padding(
      //           padding: EdgeInsets.symmetric(horizontal: 24),
      //           child: Row(
      //             children: [
      //               Icon(
      //                 Icons.logout,
      //                 color: Colors.red,
      //               ),
      //               SizedBox(
      //                 width: 10,
      //               ),
      //               Text(
      //                 "Log out",
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontWeight: FontWeight.w500,
      //                   color: Colors.red,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 40),
      //     ],
      //   ),
      // ),
      body: conversations.isNotEmpty
          ? ListView.separated(
              itemCount: conversations.length,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              separatorBuilder: (context, index) {
                if (conversations[index].id != conversations.last.id) {
                  return Divider(
                    color: Colors.grey.shade200,
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () async {
                    await BaseNavigator.pushNamed(
                      ChatScreen.routeName,
                      args: {"conversationModel": conversations[index]},
                    );
                    if (!mounted) return;
                    exitingConversations(conversations[index].gptId!);
                  },
                  leading: const CircleAvatar(
                    child: Icon(
                      Icons.travel_explore_rounded,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () async {
                      final result = await AppOverlays.showDeleteConversationDialog(context);
                      if (!mounted) return;
                      if (result != null) {
                        if (result == true) {
                          await sqlDb.deleteConversation(conversations[index].gptId!);
                          refreshConversations();
                        }
                      }
                      setState(() {});
                    },
                    icon: const Icon(Icons.delete),
                  ),
                  title: Text(
                    conversations[index].title ?? "",
                  ),
                  contentPadding: EdgeInsets.zero,
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text(
                        conversations[index].mostRecent?.message ?? "",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormat().add_EEEE().add_jm().format(conversations[index].updatedAt!),
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black.withOpacity(.6),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Lottie.asset(
                      "assets/bulb.json",
                      repeat: false,
                      frameRate: FrameRate.max,
                      height: 300,
                      width: 300,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Got any questions about your travel plans?\nLet us help you.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () async {
          await BaseNavigator.pushNamed(ChatScreen.routeName);
          if (!mounted) return;
          refreshConversations();
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
     
    );
  }
}
