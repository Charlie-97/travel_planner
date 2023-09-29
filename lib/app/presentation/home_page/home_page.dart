import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';
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
  final Box<Conversation> box = objectbox.store.box<Conversation>();

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
                  leading: const CircleAvatar(),
                  title: Text(
                    conversations[index].title ?? "",
                  ),
                  contentPadding: EdgeInsets.zero,
                  subtitle: Text(
                    conversations[index].messages.isNotEmpty
                        ? conversations[index].messages.last.text
                        : "",
                  ),
                );
              },
            )
          : const Center(
              child: Text("Empty list"),
            ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        onPressed: () {
          //basically how you update or add conversations with message.
          //Remove id to create new conversation, add id to update the conversatiion with that id.
          final conversation = Conversation(id: 2, title: "Test updated");
          conversation.messages.add(Message(text: "Get well soon"));
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
