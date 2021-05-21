import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:share/share.dart';

/**
 * 网页详情页
 */
class WebPageDetailRoute extends StatelessWidget {
  final String title;
  final String url;

  WebPageDetailRoute({
    Key key,
    @required this.title,
    @required this.url
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Theme.of(context).primaryColor,
      ),
      routes: {
        //使用说明Link:https://pub.dev/packages/flutter_webview_plugin#-readme-tab
        "/": (_) =>  new WebviewScaffold(
          url: "$url",
          appBar: AppBar(
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.maybePop(context);
                }),
            title: Text("$title"),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  print("分享");
                  Share.share('【$title】\n$url');
                },
              ),
            ],
          ),
        ),
      },
    );
  }
}