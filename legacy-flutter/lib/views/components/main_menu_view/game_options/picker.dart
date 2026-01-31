import 'package:bellachess/views/components/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../shared/text_variable.dart';

class Picker<T> extends StatelessWidget {
  final String? label;
  final Map<T, Widget>? options;
  final T? selection;
  final Function? setFunc;
  final String? themeName;

  const Picker(
      {Key? key,
      this.label,
      this.options,
      this.selection,
      this.setFunc,
      this.themeName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextSmallnew(label, themeName),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7),
              border: Border.all(
                  color: themeName == "Dark" ? Colors.white : Colors.black)),
          child: CupertinoSlidingSegmentedControl<T>(
            children: options!,
            groupValue: selection,
            onValueChanged: (T? val) {
              print("val $val");
              setFunc!(val);
            },
            thumbColor: themeName == "Dark"
                ? Colorsdata.buttoncolors
                : Colorsdata.buttonwhitecolors,
            backgroundColor: Colors.transparent,
            // borderbackgroundColor:
            //     themeName == "Dark" ? Colors.white : Colors.black,
          ),
          width: double.infinity,
        )
      ],
    );
  }
}
