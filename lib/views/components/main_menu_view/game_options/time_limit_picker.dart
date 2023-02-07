import 'package:bellachess/views/components/main_menu_view/game_options/picker.dart';
import 'package:bellachess/views/components/shared/text_style.dart';
import 'package:flutter/material.dart';

class TimeLimitPicker extends StatefulWidget {
  final int selectedTime;
  final Function setTime;
  final String themeName;
  const TimeLimitPicker(
      {Key key, this.selectedTime, this.setTime, this.themeName})
      : super(key: key);

  @override
  State<TimeLimitPicker> createState() => _TimeLimitPickerState();
}

class _TimeLimitPickerState extends State<TimeLimitPicker> {
  Map<int, Widget> timeOptions;

  @override
  void initState() {
    // TODO: implement initState
    playertext();
    super.initState();
  }

  playertext() {
    setState(() {
      timeOptions = <int, Widget>{
        15: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '15m',
              style: widget.selectedTime == 15
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        30: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text(
              '30m',
              style: widget.selectedTime == 30
                  ? AppTextStyle.mainselect
                  : AppTextStyle.mainnotselect.copyWith(
                      color: widget.themeName == 'Dark'
                          ? Color(0xffFFFFFF).withOpacity(0.6)
                          : Colors.black.withOpacity(.6),
                    ),
            )),
        60: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text('1h',
                style: widget.selectedTime == 60
                    ? AppTextStyle.mainselect
                    : AppTextStyle.mainnotselect.copyWith(
                        color: widget.themeName == 'Dark'
                            ? Color(0xffFFFFFF).withOpacity(0.6)
                            : Colors.black.withOpacity(.6),
                      ))),
        90: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text('1.5h',
                style: widget.selectedTime == 90
                    ? AppTextStyle.mainselect
                    : AppTextStyle.mainnotselect.copyWith(
                        color: widget.themeName == 'Dark'
                            ? Color(0xffFFFFFF).withOpacity(0.6)
                            : Colors.black.withOpacity(.6),
                      ))),
        120: Padding(
            padding: EdgeInsets.all(6.0),
            child: Text('2h',
                style: widget.selectedTime == 120
                    ? AppTextStyle.mainselect
                    : AppTextStyle.mainnotselect.copyWith(
                        color: widget.themeName == 'Dark'
                            ? Color(0xffFFFFFF).withOpacity(0.6)
                            : Colors.black.withOpacity(.6),
                      ))),
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    playertext();
    return Picker<int>(
      label: 'Select Time Limit',
      options: timeOptions,
      selection: widget.selectedTime,
      setFunc: widget.setTime,
      themeName: widget.themeName,
    );
  }
}
