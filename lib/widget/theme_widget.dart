import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/common/colors.dart';
import 'package:wanandroid/provider/theme_provider.dart';

class ThemeWidget extends StatefulWidget{
  @override
  _ThemeWidgetState createState() => new _ThemeWidgetState();
}

class _ThemeWidgetState extends State<ThemeWidget> {
  String _colorKey;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.color_lens),
      title: Text('选择主题'),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: ColorsUtil.getThemeColors().keys.map((key) {
              Color value = ColorsUtil.getThemeColors()[key];
              //Ink控件用于在[Material]控件上绘制图像和其他装饰，以便[InkWell]、[InkResponse]控件的“水波纹”效果在其上面显示
              return InkWell(
                onTap: () {
                  setState(() {
                    _colorKey = key;
                  });
                  _saveThemeColors(key);
                  //设置主题
                  Provider.of<AppThemeProvider>(context, listen: false).setTheme(key);
                },
                child: Container(
                  width: 25,
                  height: 25,
                  color: value,
                  alignment: Alignment.center,
                  child: _colorKey == key ? Icon(Icons.done, color: Colors.white,) : null,
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  void _saveThemeColors(String color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("theme_color", color);
  }

}