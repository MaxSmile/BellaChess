import 'package:bellachess/views/components/shared/text_style.dart';
import 'package:flutter/material.dart';

import 'picker.dart';

enum Player { player1, player2, random }

class SidePicker extends StatefulWidget {
  final Player playerSide;
  final Function setFunc;
  final String themeName;
  const SidePicker(this.playerSide, this.setFunc, this.themeName, {Key key})
      : super(key: key);

  @override
  State<SidePicker> createState() => _SidePickerState();
}

class _SidePickerState extends State<SidePicker> {
  Map<Player, Widget> colorOptions;
  @override
  void initState() {
    playertext();
    super.initState();
  }

  playertext() {
    setState(() {
      colorOptions = <Player, Widget>{
        Player.player1: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'White',
              style: widget.playerSide == Player.player1
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        Player.player2: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Black',
              style: widget.playerSide == Player.player2
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        Player.random: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              'Random',
              style: widget.playerSide == Player.random
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
    playertext();
    return Picker<Player>(
      label: 'Select Side',
      options: colorOptions,
      selection: widget.playerSide,
      setFunc: widget.setFunc,
      themeName: widget.themeName,
    );
  }
}
