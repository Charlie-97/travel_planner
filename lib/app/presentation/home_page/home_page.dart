import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/app/presentation/chat/screen/chat_screen.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/data/model/conversation.dart';

class HomePage extends StatefulWidget {
  static const routeName = "home_page";
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Box<ObjConversation> box = objectbox.store.box<ObjConversation>();

  @override
  Widget build(BuildContext context) {
    final conversations = box.getAll();
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
                  onTap: () {
                    BaseNavigator.pushNamed(
                      ChatScreen.routeName,
                      args: conversations[index],
                    );
                  },
                  leading: CircleAvatar(
                    child: Text("${conversations[index].id}"),
                  ),
                  trailing: IconButton(
                      onPressed: () {
                        box.remove(conversations[index].id);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete)),
                  title: Text(
                    conversations[index].title ?? "",
                  ),
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text(
                    conversations[index].messages.isNotEmpty
                        ? conversations[index].messages.last.text
                        : "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
        onPressed: () {
          //basically how you update or add conversations with message.
          //Remove id to create new conversation, add id to update the conversatiion with that id.
          final conversation = ObjConversation(id: 0, title: "Test");
          // conversation.messages.add(
          //   ObjMessage(
          //     text:
          //         "Hello I need to visit Paris",
          //     sentBy: 'AI',
          //     createdAt: DateTime.now(),
          //   ),
          // );
          box.put(conversation);
          setState(() {});
          BaseNavigator.pushNamed(ChatScreen.routeName, args: conversation);
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
     
    );
  }
}
