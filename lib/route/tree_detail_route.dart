import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/bean/article_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/widget/article_item_widget.dart';

class TreeDetailRoute extends StatefulWidget {
  final String name;
  final int id;

  TreeDetailRoute({
    Key key,
    @required this.name,
    @required this.id,
  });

  @override
  _TreeDetailRoiteState createState() =>_TreeDetailRoiteState();

}

class _TreeDetailRoiteState extends State<TreeDetailRoute> {
  int _page = 0;
  List<ArticleDetailDatas> data = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try{
      var treeArticleResponse = await DioHelper.getInstance().get(ApiServer.ARTICLE_LIST+"$_page"+"/json",data: {
        "cid":widget.id
      });
      var treeArticleMap = json.decode(treeArticleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(treeArticleMap);

      setState(() {
        data = articleEntity.data.datas;
      });
    }catch(e) {
      return print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: EasyRefresh.custom(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        onRefresh: () async{
          //延时任务
          await Future.delayed(Duration(seconds: 1),(){
            setState(() {
              _page = 0;
            });
            _getData();
          });
        },
        onLoad: () async{
          //延时任务
          await Future.delayed(Duration(seconds: 1),() async {
            setState(() {
              _page++;
            });
            //获取更多数据
            _getMoreData();
          });
        },
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context,index){
                      return new ArticleItemWidget(data: data[index]);
                },
                childCount: data.length , //+1 添加banner显示
              )
          ),
        ],
      ),
    );
  }

  void _getMoreData() async {
    var articleResponse = await DioHelper.getInstance().get(ApiServer.ARTICLE_LIST+"$_page"+"/json",data: {"cid":widget.id});
    var map = json.decode(articleResponse.toString());
    var articleEntity = ArticleEntity.fromJson(map);
    setState(() {
      data.addAll(articleEntity.data.datas);
    });
  }

}