import 'package:flutter/material.dart';

class LossScreen extends StatelessWidget {
  final String? colorname;
  final Function? callback;

  const LossScreen({Key? key, this.callback, this.colorname}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      child: Container(
        height: MediaQuery.of(context).size.height * .43,
        width: MediaQuery.of(context).size.height * .4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
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
              colorname!,
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            Text(
              "Keep playing and improving",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(
              height: 5,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                child: Image.asset("assets/images/loss.png"),
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
