import 'package:flutter/material.dart';

class WinScreen extends StatelessWidget {
  final Function? callback;

  const WinScreen({Key? key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        height: MediaQuery.of(context).size.height * .43,
        width: MediaQuery.of(context).size.height * .4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          // border: Border.all(color: Colors.white, width: 0.2),
          // boxShadow: [
          //   BoxShadow(
          //     color: Colors.grey,
          //     spreadRadius: 1,
          //     blurRadius: 2,
          //     offset: Offset(1, 2),
          //   ),
          // ],
          color: const Color(0xFF2b2c2f),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  color: Colors.white,
                  onPressed: () {
                    callback!("ok");
                  },
                  icon: Icon(Icons.close),
                ),
              ],
            ),
            Text(
              "Congratualtion!",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              "You're the winner!",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                child: Image.asset("assets/images/win.png"),
                onTap: () {
                  // Navigator.pop(context);
                },
              ),
            ),
            InkWell(
              onTap: () {
                callback!("play");
              },
              child: Container(
                height: MediaQuery.of(context).size.height * .05,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    color: const Color(0xFFbb8c61)),
                child: Center(
                  child: Text(
                    "Play Again",
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
