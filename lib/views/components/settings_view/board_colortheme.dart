import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/model/app_stringfile.dart';
import 'package:bellachess/views/components/colors.dart';
import 'package:bellachess/views/components/shared/text_variable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardColortheme extends StatelessWidget {
  const BoardColortheme({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppModel>(
      builder: (context, appModel, child) => Column(
        children: [
          Container(
            child: TextLarges('Choose Board Theme',
                color:
                    appModel.themeName == "Dark" ? Colors.white : Colors.black),
            padding: const EdgeInsets.all(10),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .06,
            // width: MediaQuery.of(context).size.width,
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
                    //  appModel.setTheme(0);
                    appModel.setboardColor(BoardColor.lightTile);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(3),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 7.0,
                      decoration: BoxDecoration(
                          color: (appModel.themeName == "Dark" &&
                                  appModel.boardColor == BoardColor.lightTile)
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "B",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appModel.setboardColor(BoardColor.blacknwhite);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 7.0,
                      decoration: BoxDecoration(
                          color: (appModel.themeName == "Dark" &&
                                  appModel.boardColor == BoardColor.blacknwhite)
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "B&W",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    // appModel.setboardColor(1);
                    appModel.setboardColor(BoardColor.midnight);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 7.0,
                      decoration: BoxDecoration(
                          color: (appModel.themeName == "Dark" &&
                                  appModel.boardColor == BoardColor.midnight)
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "Mid",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appModel.setboardColor(BoardColor.green);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 7.0,
                      decoration: BoxDecoration(
                          color: (appModel.themeName == "Dark" &&
                                  appModel.boardColor == BoardColor.green)
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "Green",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    appModel.setboardColor(BoardColor.blue);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(1),
                    child: Container(
                      width: MediaQuery.of(context).size.width / 7.0,
                      decoration: BoxDecoration(
                          color: (appModel.themeName == "Dark" &&
                                  appModel.boardColor == BoardColor.blue)
                              ? Colorsdata.playbuttoncolors
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: TextRegulars(
                              "Blue",
                              appModel.themeName == "Dark"
                                  ? Colors.white
                                  : Colors.black)),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
