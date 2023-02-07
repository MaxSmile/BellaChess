import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/colors.dart';
import 'package:bellachess/views/components/shared/text_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppThemePicker extends StatelessWidget {
  const AppThemePicker({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextLarges('Theme',
                color:
                    appModel.themeName == "Dark" ? Colors.white : Colors.black),
            padding: const EdgeInsets.all(10),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .06,
            decoration: BoxDecoration(
                border: Border.all(
                    color: appModel.themeName == "Dark"
                        ? Colors.white
                        : Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    appModel.setTheme(0);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.70,
                      decoration: BoxDecoration(
                          color: appModel.themeName == "Dark"
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "Dark",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appModel.setTheme(1);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.70,
                      decoration: BoxDecoration(
                          color: appModel.themeName == "Light"
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(child: TextRegular("Light")),
                    ),
                  ),
                ),
              ],
            ),
          )
          // Container(
          //   height: 110,
          //   decoration: const BoxDecoration(
          //     borderRadius: BorderRadius.all(Radius.circular(15)),
          //     color: Color(0xBB402179),
          //   ),
          //   child: CupertinoPicker(
          //     scrollController: FixedExtentScrollController(
          //       initialItem: appModel.themeIndex,
          //     ),
          //     selectionOverlay: const CupertinoPickerDefaultSelectionOverlay(
          //       background: Color(0x20000000),
          //     ),
          //     itemExtent: 50,
          //     onSelectedItemChanged: appModel.setTheme,
          //     children: themeList
          //         .map(
          //           (theme) => Container(
          //             padding: const EdgeInsets.all(10),
          //             child: TextRegular(theme.name),
          //           ),
          //         )
          //         .toList(),
          //   ),
          // ),
        ],
      ),
    );
  }
}
