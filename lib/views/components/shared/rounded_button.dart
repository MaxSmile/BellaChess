import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String label;
  final Function onPressed;

  const RoundedButton(this.label, {Key key, @required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CupertinoButton(
        padding: EdgeInsets.zero,
        color: const Color(0x20000000),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        onPressed: onPressed,
      ),
      width: double.infinity,
      height: 60,
    );
  }
}
