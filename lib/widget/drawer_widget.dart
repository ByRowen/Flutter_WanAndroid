import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/route/favorite_route.dart';
import 'package:wanandroid/route/third_party_route.dart';
import 'package:wanandroid/widget/share_widget.dart';
import 'package:wanandroid/widget/theme_widget.dart';

class CustomDrawerWidget extends StatefulWidget{

  const CustomDrawerWidget({
    Key key,
  }) : super(key: key);

  @override
  _CustomDrawerState createState() =>new _CustomDrawerState();

}

class _CustomDrawerState extends State<CustomDrawerWidget> {
  String _colorKey;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      //MediaQuery.removePadding可以移除Drawer默认的一些留白
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,//移除抽屉菜单顶部默认留白
        child: Column(
          //对齐方式
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(top: 38.0),
              color: Theme.of(context).primaryColor,
              //剪裁图片
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ClipOval(
                      child: Image.asset("imgs/logo_our_sky.png",width: 80,),
                    ),
                  ),
                  Text(
                    "玩Android",
                    style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
                child: ListView(
                  children: <Widget>[
                    ListTile(
                      leading: const Icon(Icons.favorite),
                      title: const Text('我的收藏'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => FavoriteRoute()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.library_add_outlined),
                      title: const Text('第三方库'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ThridPartyRoute()),
                        );
                      },
                    ),
                    ThemeWidget(),
                    ShareWidget(),
                    AboutProjectWidget(),
                  ],
                )
            )
          ],
        ),
      ),
    );
  }
}

class AboutProjectWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title:Text("致谢"),
      leading: const Icon(Icons.info_outline),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(2.0),
          child: Container(
            height: 200,
            child:  Text("感谢玩Android开放的API\n感谢所有优秀的开源项目"),
          ),
        ),
      ],
    );
  }
}