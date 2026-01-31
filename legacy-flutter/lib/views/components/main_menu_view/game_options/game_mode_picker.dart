import 'package:flutter/material.dart';

import 'picker.dart';

class GameModePicker extends StatefulWidget {
  final int playerCount;
  final Function setFunc;
  final String? themeName;

  const GameModePicker(this.playerCount, this.setFunc, this.themeName,
      {Key? key})
      : super(key: key);

  @override
  State<GameModePicker> createState() => _GameModePickerState();
}

class _GameModePickerState extends State<GameModePicker> {
  Map<int, Widget>? playerCountOptions;
  @override
  void initState() {
    playertext(widget.playerCount);
  }

  playertext(int playerCount) {
    setState(() {
      playerCountOptions = <int, Widget>{
        1: Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            'One Player',
            style: widget.playerCount == 1
                ? TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)
                : TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: widget.themeName == 'Dark'
                        ? Color(0xffFFFFFF).withOpacity(0.6)
                        : Colors.black.withOpacity(.6)),
          ),
        ),
        2: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Two Player',
              style: widget.playerCount == 2
                  ? const TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w600)
                  : TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6)),
            )),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    playertext(widget.playerCount);
    return Picker<int>(
      label: 'Select Mode',
      options: playerCountOptions,
      selection: widget.playerCount,
      setFunc: widget.setFunc,
      themeName: widget.themeName,
    );
  }
}
