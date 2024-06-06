

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatBubblePainter extends CustomPainter {
  final bool isMe;

  ChatBubblePainter(this.isMe);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isMe ? Colors.green : Colors.white
      ..style = PaintingStyle.fill;

    final path = Path();

    if (isMe) {
      path.moveTo(size.width - 10, 0);
      path.lineTo(size.width - 20, 10);
      path.lineTo(10, 10);
      path.arcToPoint(
        Offset(0, 20),
        radius: Radius.circular(10),
        clockwise: false,
      );
      path.lineTo(0, size.height - 10);
      path.arcToPoint(
        Offset(10, size.height),
        radius: Radius.circular(10),
      );
      path.lineTo(size.width - 10, size.height);
      path.arcToPoint(
        Offset(size.width, size.height - 10),
        radius: Radius.circular(10),
      );
      path.lineTo(size.width, 10);
      path.arcToPoint(
        Offset(size.width - 10, 0),
        radius: Radius.circular(10),
      );
    } else {
      path.moveTo(10, 0);
      path.lineTo(20, 10);
      path.lineTo(size.width - 10, 10);
      path.arcToPoint(
        Offset(size.width, 20),
        radius: Radius.circular(10),
        clockwise: false,
      );
      path.lineTo(size.width, size.height - 10);
      path.arcToPoint(
        Offset(size.width - 10, size.height),
        radius: Radius.circular(10),
      );
      path.lineTo(10, size.height);
      path.arcToPoint(
        Offset(0, size.height - 10),
        radius: Radius.circular(10),
      );
      path.lineTo(0, 10);
      path.arcToPoint(
        Offset(10, 0),
        radius: Radius.circular(10),
      );
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
