import 'package:bellachess/model/app_model.dart';
import 'package:bellachess/views/components/colors.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestartExitButtons extends StatelessWidget {
  final AppModel appModel;

  const RestartExitButtons(this.appModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            child: Container(
                height: MediaQuery.of(context).size.height * .08,
                decoration: BoxDecoration(
                    color: Colorsdata.playbuttoncolors,
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Restart",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                    ),
                  ),
                )),
            onTap: () {
              appModel.newGame(context);
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: GestureDetector(
            child: Container(
                height: MediaQuery.of(context).size.height * .08,
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(10)),
                child: Center(
                  child: Text(
                    "Exit",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 20,
                    ),
                  ),
                )),
            onTap: () {
              appModel.exitChessView();
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
