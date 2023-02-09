import 'package:bellachess/views/components/shared/text_variable.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimerWidget extends StatelessWidget {
  final Duration timeLeft;
  final Color color;
  final String? themename;

  const TimerWidget(
      {Key? key, required this.timeLeft, required this.color, this.themename})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            Icons.timer_outlined,
            color: color,
          ),
          Center(
            child: TextRegular(
              _durationToString(timeLeft),
              color: color,
            ),
          ),
        ],
      ),
      decoration: BoxDecoration(
        // border: Border.all(color: color, width: 2),
        borderRadius: BorderRadius.circular(10),
        color: themename == "Dark"
            ? const Color(0xffFFFFFF).withOpacity(0.2)
            : Color(0xffe5e5e5),
      ),
    );
  }

  String _durationToString(Duration duration) {
    if (duration.inHours > 0) {
      String hours = duration.inHours.toString();
      String minutes =
          duration.inMinutes.remainder(60).toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$hours:$minutes:$seconds';
    } else if (duration.inMinutes > 0) {
      String minutes = duration.inMinutes.toString();
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    } else {
      String seconds = duration.inSeconds.toString();
      return seconds;
    }
  }
}
