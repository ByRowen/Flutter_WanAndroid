import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/common/colors.dart';
import 'package:wanandroid/provider/theme_provider.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';

class ShareWidget extends StatelessWidget{
  var blogUrl = 'https://blog.csdn.net/yb1020368306';
  var githubUrl = 'https://github.com/ByRowen/';
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      leading: Icon(Icons.share),
      title: Text('我的资源'),
      initiallyExpanded: false,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 5.0),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0),
                ),
                child:InkWell(
                  onTap: () {
                    _onItemClick(context,"我的博客",blogUrl);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text("博客:$blogUrl",style: TextStyle(fontSize: 14.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 2.0,
              ),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(width: 2.0),
                ),
                child: InkWell(
                  onTap: () {
                    _onItemClick(context,'我的Github',githubUrl);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 35,
                    alignment: Alignment.center,
                    child: Text("Github:$githubUrl",style: TextStyle(fontSize: 14.0)),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  void _onItemClick(BuildContext context,String title,String link){
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => WebPageDetailRoute(
            title: title, url: link),
      ),
    );
  }
}