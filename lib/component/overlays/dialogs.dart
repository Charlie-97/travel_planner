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

  static dynamic authErrorDialog(
      {required BuildContext context,
      bool? passwordMatch,
      bool? validEmail,
      bool? validUserName,
      bool? validPassword,
      String? optionalMessage}) async {
    const invalidName = 'Please enter a valid username and try again';
    const invalidEmail = 'Please enter a valid email address and try again';
    const invalidPassword = 'Enter a valid password, minimum of 8 characters';
    const passwordMismatch = 'Passwords do not match';

    String? message;

    if (!(validUserName ?? true)) {
      message = invalidName;
    } else if (!(validEmail ?? true)) {
      message = invalidEmail;
    } else if (!(validPassword ?? true)) {
      message = invalidPassword;
    } else if (!(passwordMatch ?? true)) {
      message = passwordMismatch;
    } else if (optionalMessage!.isNotEmpty) {
      message = optionalMessage;
    }

    final s = await showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          titlePadding: const EdgeInsets.only(
            left: 24,
            top: 20,
          ),
          title: const Text(
            "Authentication Error",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Text(
            message ?? "Oops!! Something went wrong",
            style: const TextStyle(
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
                "Okay",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
