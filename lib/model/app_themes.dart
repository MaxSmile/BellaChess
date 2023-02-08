import 'package:flutter/material.dart';

// class TilesColors {
//   final Color lightTile  = const Color(0xFFC9B28F);
//   final Color darkTile = const Color(0xFF69493b);
//   const TilesColors();
// }

class TilesColors {
  final Color lightTile = const Color(0xFFC9B28F);

  final Color darkTile = const Color(0xFF69493b);

  final Color blacknwhitelight = const Color(0xFFf9faff);
  final Color blacknwhitedark = const Color(0xFF434546);

  final Color midnightlight = const Color(0xFFf0ebed);
  final Color midnightdark = const Color(0xFF6d779c);

  final Color greenlight = const Color(0xFF1f352b);
  final Color greendark = const Color(0xFF90b7b1);

  final Color bluelight = const Color(0xFF2c559e);
  final Color bluedark = const Color(0xFF7397d0);
  const TilesColors();
}

class AppTheme {
  String name;
  LinearGradient background;

  TilesColors tilesColors;

  Color moveHint;
  Color checkHint;
  Color latestMove;
  Color border;

  AppTheme({
    this.name,
    this.background,
    this.tilesColors = const TilesColors(),
    this.moveHint = const Color(0xdd5c81c4),
    this.latestMove = const Color(0xccc47937),
    this.checkHint = const Color(0x88ff0000),
    this.border = const Color(0xffffffff),
  });
}

List<AppTheme> get themeList {
  var themeList = <AppTheme>[
    AppTheme(
      name: 'Light',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0E082E),
          Color(0xFF231A75),
        ],
      ),
      // lightTile: const Color(0xff4faa55),
      // darkTile: const Color(0xff2560a5),
      // moveHint: const Color(0xaaffff00),
      // latestMove: const Color(0xaadb70eb),
      // border: const Color(0xff184387),
      // lightTile: const Color(0xffECD9B9),
      // darkTile: const Color(0xffBB8C61),
      moveHint: const Color(0xffFFFFFF),
      checkHint: const Color.fromARGB(135, 184, 111, 111),
      latestMove: const Color(0xffFFFFFF),
      border: const Color(0xffA68463),
    ),
    AppTheme(
      name: 'Dark',
      background: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF0E082E),
          Color(0xFF231A75),
        ],
      ),
      // lightTile: const Color(0xffECD9B9),
      // darkTile: const Color(0xffBB8C61),
      moveHint: const Color(0xffFFFFFF),
      checkHint: const Color.fromARGB(135, 184, 111, 111),
      latestMove: const Color(0xffFFFFFF),
      border: const Color(0xffA68463),
    ),
  ];
  themeList.sort((a, b) => a.name.compareTo(b.name));
  return themeList;
}
