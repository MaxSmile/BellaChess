import 'dart:io';

import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/shared/text_variable.dart';
import 'package:bellachess/views/components/webviewscreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'toggle.dart';

class Toggles extends StatelessWidget {
  final AppModel appModel;

  const Toggles(this.appModel, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(
          color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
        ),
        Toggle(
          'Show Hints',
          toggle: appModel.showHints,
          setFunc: appModel.setShowHints,
          apptheme: appModel.themeName,
        ),
        Divider(
          color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
        ),
        Toggle(
          'Allow Undo/Redo',
          toggle: appModel.allowUndoRedo,
          setFunc: appModel.setAllowUndoRedo,
          apptheme: appModel.themeName,
        ),
        Divider(
          color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
        ),
        Toggle(
          'Show Move History',
          toggle: appModel.showMoveHistory,
          setFunc: appModel.setShowMoveHistory,
          apptheme: appModel.themeName,
        ),
        Divider(
          color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
        ),
        Toggle(
          'Flip Board For Black',
          toggle: appModel.flip,
          setFunc: appModel.setFlipBoard,
          apptheme: appModel.themeName,
        ),
        Divider(
          color: appModel.themeName == "Dark" ? Colors.white : Colors.black,
        ),
        Platform.isAndroid
            ? Toggle(
                'Sound Enabled',
                toggle: appModel.soundEnabled,
                setFunc: appModel.setSoundEnabled,
                apptheme: appModel.themeName,
              )
            : Container(),
        Platform.isAndroid
            ? Divider(
                color:
                    appModel.themeName == "Dark" ? Colors.white : Colors.black,
              )
            : Container(),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) =>
                    WebViewScreensShow(),
              ),
            );
          },
          child: TextRegulars("Crypto Currency ",
              appModel.themeName == "Dark" ? Colors.white : Colors.black),
        ),
      ],
    );
  }
}
