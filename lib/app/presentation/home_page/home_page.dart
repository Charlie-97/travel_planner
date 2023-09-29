import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:objectbox/objectbox.dart';
import 'package:travel_planner/app/presentation/chat/screen/chat_screen.dart';
import 'package:travel_planner/app/router/base_navigator.dart';
import 'package:travel_planner/component/constants.dart';
import 'package:travel_planner/data/model/conversation.dart';
import 'package:travel_planner/data/model/message.dart';

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
      appBar: AppBar(
        title: const Text(
          "TRAVEL PLANNER",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
      ),
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
                    conversations[index].messages.isNotEmpty ? conversations[index].messages.last.text : "",
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
          conversation.messages.add(
            ObjMessage(
              text:
                  "Great choice! December is a wonderful time for a vacation. To recommend a destination, I'll need a bit more information about your preferences. Are you looking for a warm beach destination, a snowy winter getaway, a cultural experience, or something else? Also, do you have a specific region or budget in mind?",
              sentBy: 'AI',
              createdAt: DateTime.now(),
            ),
          );
          box.put(conversation);
          setState(() {});
        },
        child: const Icon(
          Icons.add,
          size: 30,
        ),
      ),
    );
  }
}
