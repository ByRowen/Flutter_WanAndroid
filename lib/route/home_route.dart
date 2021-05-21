import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/bean/article_json.dart';
import 'package:wanandroid/bean/bannner_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/widget/article_item_widget.dart';
import 'package:wanandroid/widget/banner_widget.dart';
import 'package:wanandroid/widget/common_widget.dart';

class HomeRoute extends StatefulWidget{
  HomeRoute({Key key}) : super(key: key);

  @override
  _HomeRouteState createState() => new _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {

  int _page = 0;
  List<BannerData> bannerData = new List();
  List<ArticleDetailDatas> articleData = new List();
  bool isReqException =false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getWidget(context)
    );
  }

  Widget getWidget(BuildContext context){
    if(isReqException) {
      return CommonWidget.getReloadWidget(() => _getData());
    }
    if(bannerData.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else {
      return EasyRefresh.custom(
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
            getMoreData();
          });
        },
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context,index){
                  if(index == 0) {
                      return BannerWidget(data: bannerData);
                  }
                  if (index < articleData.length - 1){
//                    return new ArticleItemWidget(data: articleData[index]);
                      return NotificationListener<CommonNotification>(
                          child: ArticleItemWidget(data: articleData[index]),
                          onNotification: (notification){
                            _getData();
                            return true;
                          },
                      );
                  }
                  return null;
                },
                childCount: articleData.length + 1, //+1 添加banner显示
              )
          ),
        ],
      );
    }
  }

  void _getData() async{
    try{
      //获取首页Banner数据
      var bannerResponse = await DioHelper.getInstance().get(ApiServer.BANNER);
      var bannerMap = json.decode(bannerResponse.toString());
      var beanEntity = BannerEntity.fromJson(bannerMap);

      //获取首页文章数据
      var articleResponse = await DioHelper.getInstance().get(ApiServer.ARTICLE_LIST+"$_page"+"/json");
      var articleMap = json.decode(articleResponse.toString());
      var articleEntity = ArticleEntity.fromJson(articleMap);

      //更新UI数据
      setState(() {
        isReqException = false;
        bannerData = beanEntity.data;
        articleData = articleEntity.data.datas;
      });
    }catch(e){
      setState(() {
        isReqException = true;
      });
      print("首页请求数据异常:"+e.toString());
      return print(e);
    }
  }

  void getMoreData() async {
    var articleResponse = await DioHelper.getInstance().get(ApiServer.ARTICLE_LIST+"$_page"+"/json");
    var map = json.decode(articleResponse.toString());
    var articleEntity = ArticleEntity.fromJson(map);
    setState(() {
      articleData.addAll(articleEntity.data.datas);
    });
  }

}