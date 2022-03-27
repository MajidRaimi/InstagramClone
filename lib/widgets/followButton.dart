import 'package:flutter/material.dart';

class FollowButton extends StatelessWidget {
  const FollowButton({Key? key, this.function, required this.backGroundColor, required this.borderColor, required this.text, required this.textColor}) : super(key: key);

  final Function()? function;
  final Color backGroundColor;
  final Color borderColor;
  final String text;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: SizedBox(
        width: 250,
        height: 50,
        child: TextButton(
          onPressed: function,
          child: Container(
            decoration: BoxDecoration(
                color: backGroundColor,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(5)),
            alignment: Alignment.center,
            child: Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
