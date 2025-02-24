import 'package:ai_app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CopyButton extends StatefulWidget {
  const CopyButton({super.key, required this.onPressed});
  final Function() onPressed;
  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) => setState(() {
        isHovered = true;
      }),
      onPointerUp: (event) => setState(() {
        isHovered = false;
      }),
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: const Size(90, 26),
          maximumSize: const Size(90, 26),
          fixedSize: const Size(90, 26),
          overlayColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        onPressed: widget.onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Icon(
              FontAwesomeIcons.clipboard,
              size: 16,
              color: isHovered ? Colors.grey[500] : black,
            ),
            Text(
              'Copy code',
              style: TextStyle(
                fontSize: 12,
                color: isHovered ? Colors.grey[500] : black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
