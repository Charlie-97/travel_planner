import 'package:chatview/chatview.dart';
import 'package:flutter/material.dart';

ChatBubble chatBubble({
  Color? color,
  Color? textColor,
}) {
  return ChatBubble(
    borderRadius: const BorderRadius.all(Radius.circular(5)),
    color: color,
    textStyle: TextStyle(
      color: textColor,
    ),
    linkPreviewConfig: null,
  );
}
