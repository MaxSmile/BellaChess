// ignore_for_file: prefer_const_constructors

import 'package:bellachess/views/components/shared/text_style.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'picker.dart';

class AIDifficultyPicker extends StatefulWidget {
  final int aiDifficulty;
  final Function setFunc;
  final String themeName;

  AIDifficultyPicker(this.aiDifficulty, this.setFunc, this.themeName, {Key key})
      : super(key: key);

  @override
  State<AIDifficultyPicker> createState() => _AIDifficultyPickerState();
}

class _AIDifficultyPickerState extends State<AIDifficultyPicker> {
  Map<int, Widget> difficultyOptions;

  @override
  void initState() {
    // TODO: implement initState
    playertext(widget.aiDifficulty);
    super.initState();
  }

  playertext(int playerCount) {
    setState(() {
      difficultyOptions = <int, Widget>{
        1: Padding(
          padding: EdgeInsets.all(6.0),
          child: Text(
            '1',
            style: widget.aiDifficulty == 1
                ? AppTextStyle.mainselect
                : AppTextStyle.mainnotselect.copyWith(
                    color: widget.themeName == 'Dark'
                        ? Color(0xffFFFFFF).withOpacity(0.6)
                        : Colors.black.withOpacity(.6),
                  ),
          ),
        ),
        2: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '2',
              style: widget.aiDifficulty == 2
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        3: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '3',
              style: widget.aiDifficulty == 3
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        4: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '4',
              style: widget.aiDifficulty == 4
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        5: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '5',
              style: widget.aiDifficulty == 5
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        6: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '6',
              style: widget.aiDifficulty == 6
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    playertext(widget.aiDifficulty);
    return Picker<int>(
      label: 'Difficulty',
      options: difficultyOptions,
      selection: widget.aiDifficulty,
      setFunc: widget.setFunc,
      themeName: widget.themeName,
    );
  }
}
