import 'package:bellachess/views/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../shared/text_variable.dart';

class Toggle extends StatelessWidget {
  final String label;
  final bool toggle;
  final Function setFunc;
  final String apptheme;

  const Toggle(this.label, {Key key, this.toggle, this.apptheme, this.setFunc})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: Row(
        children: [
          TextRegulars(label, apptheme == "Dark" ? Colors.white : Colors.black),
          const Spacer(),
          CupertinoSwitch(
            value: toggle,
            onChanged: setFunc,
            activeColor: Colorsdata.buttoncolors,
            thumbColor: Colorsdata.playbuttoncolors,
          ),
        ],
      ),
    );
  }
}
