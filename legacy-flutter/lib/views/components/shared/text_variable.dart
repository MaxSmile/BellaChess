import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextDefault extends StatelessWidget {
  final String text;
  final Color color;

  const TextDefault(this.text, {Key? key, this.color = CupertinoColors.white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: 'Jura',
        color: color,
      ),
    );
  }
}

class TextSmall extends StatelessWidget {
  final String text;

  const TextSmall(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 20, fontFamily: 'Inter', fontWeight: FontWeight.w500));
  }
}

class TextSmallnew extends StatelessWidget {
  final String? text;
  final String? name;

  const TextSmallnew(this.text, this.name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text!,
        style: TextStyle(
            color: name == "Dark" ? Colors.white : Colors.black,
            fontSize: 24,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500));
  }
}

class TextRegular extends StatelessWidget {
  final String text;
  final Color? color;

  const TextRegular(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400));
  }
}

class TextRegularboard extends StatelessWidget {
  final String text;
  final Color? color;
  const TextRegularboard(this.text, {Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            fontSize: 15,
            fontFamily: 'Inter',
            color: color == null ? Colors.white.withOpacity(0.7) : color,
            fontWeight: FontWeight.w500));
  }
}

class TextRegulars extends StatelessWidget {
  final String text;
  final Color color;

  const TextRegulars(this.text, this.color, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: 16,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400));
  }
}

class TextLarge extends StatelessWidget {
  final String text;

  const TextLarge(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: const TextStyle(
            fontSize: 25, fontFamily: 'Inter', fontWeight: FontWeight.w500));
  }
}

class TextLarges extends StatelessWidget {
  final String text;
  final Color? color;

  const TextLarges(
    this.text, {
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(text,
        style: TextStyle(
            color: color,
            fontSize: 20,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w500));
  }
}

class Backbutton extends StatelessWidget {
  final Color? color;

  const Backbutton({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Icon(
          Icons.arrow_back,
          color: color,
        ));
  }
}
