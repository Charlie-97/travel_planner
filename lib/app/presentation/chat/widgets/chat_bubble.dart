import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

ChatBubble chatBubble({
  Color? color,
  Color? textColor,
  required bool sentByUser,
}) {
  return ChatBubble(
    borderRadius: BorderRadius.only(
      topLeft: const Radius.circular(10),
      topRight: const Radius.circular(10),
      bottomLeft: sentByUser ? const Radius.circular(10) : Radius.zero,
      bottomRight: !sentByUser ? const Radius.circular(10) : Radius.zero,
    ),
    color: color,
    textStyle: TextStyle(
      color: textColor,
      fontSize: 16, 
      height: 1.3
    ),
    linkPreviewConfig: null,
  );
}
