import 'package:flutter/material.dart';

class ColorsUtil{
  static List<MaterialColor> getColorsList(){
    List<MaterialColor> _colors = [
      Colors.red,
      Colors.amber,
      Colors.green,
      Colors.blue,
      Colors.cyan,
      Colors.orange,
      Colors.indigo,
      Colors.deepPurple,
      Colors.brown,
    ];
    return _colors;
  }

  static Map<String, Color> getThemeColors(){
    const Map<String, Color> themeColorMap = {
      'black': Colors.black,
      'red': Colors.red,
      'orange': Colors.orange,
      'yellow':Colors.yellow,
      'green': Colors.green,
      'cyan': Colors.cyan,
      'blue': Colors.blue,
      'purple': Colors.purple,
      'gray': Colors.grey,
      'deepPurple': Colors.purple,
      'blueAccent': Colors.blueAccent,
      'deepPurpleAccent': Colors.deepPurpleAccent,
      'deepOrange': Colors.orange,
      'indigo': Colors.indigo,
      'indigoAccent': Colors.indigoAccent,
      'pink': Colors.pink,
      'teal': Colors.teal,
      'greenAccent':Colors.greenAccent,
      'blueGrey':Colors.blueGrey,
      "defalut":Colors.blue,
    };
    return themeColorMap;
  }
}