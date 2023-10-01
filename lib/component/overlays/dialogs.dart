import 'package:flutter/material.dart';
import 'package:travel_planner/app/router/base_navigator.dart';

class AppOverlays {
  static dynamic showDeleteConversationDialog(
    BuildContext context,
  ) async {
    final s = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(
            left: 24,
            top: 20,
          ),
          title: const Text(
            "Delete Conversation",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            "This conversation will be deleted. This action is irreversible, are you sure?",
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 10,
          ),
          actions: [
            InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              onTap: () {
                BaseNavigator.pop();
              },
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 10),
            InkWell(
              overlayColor: const MaterialStatePropertyAll(Colors.transparent),
              onTap: () async {
                BaseNavigator.pop(true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
              ),
            )
          ],
          actionsPadding: const EdgeInsets.only(
            bottom: 20,
            right: 24,
          ),
        );
      },
    );

    if (s != null) {
      return s;
    }

    return null;
  }
}
