import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';

class ThridPartyRoute extends StatelessWidget {
  var thirdPartysUrl = [
    "https://github.com/best-flutter/flutter_swiper",
    "https://github.com/flutterchina/dio",
    "https://pub.dev/packages/dio_cookie_manager",
    "https://github.com/xuelongqy/flutter_easyrefresh",
    "https://pub.dev/packages/flutter_webview_plugin#-readme-tab",
    "https://pub.flutter-io.cn/packages/flutter_staggered_grid_view",
    "https://pub.dev/packages/shared_preferences",
    "https://pub.dev/packages/cached_network_image",
    "https://pub.dev/packages/share",
    "https://pub.flutter-io.cn/packages/provider",
  ];

  var thirdPartysName = [
    "轮播库：flutter_swiper",
    "网络请求库：dio",
    "网络缓存管理库：dio_cookie_manager",
    "下拉刷新库：flutter_easyrefresh",
    "网页加载库：webview",
    "瀑布流组件：flutter_staggered_grid_view",
    "数据存储库：sharePreference",
    "图片网络缓存库：cached_network_image",
    "分享库:share",
    "状态管理库:provider"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("第三方库"),
      ),
      body: ListView.builder(
          itemCount: thirdPartysName.length,
          itemBuilder: (context,index) {
            return GestureDetector(
              child: Card(
                child: ListTile(
                  title: Text(thirdPartysName[index],style: TextStyle(fontSize: 16.0)),
                  subtitle: Text("url:"+thirdPartysUrl[index],style: TextStyle(fontSize: 12.0)),
                  trailing: const Icon(Icons.chevron_right),
                ),
              ),
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WebPageDetailRoute(
                        title: thirdPartysName[index], url: thirdPartysUrl[index]),
                  ),
                );
              },
            );
          },
      ),
    );
  }

}