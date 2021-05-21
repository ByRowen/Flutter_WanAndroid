import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/bean/favorite_json.dart';
import 'package:wanandroid/common/requests.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/widget/common_widget.dart';
import 'package:wanandroid/widget/favorite_item_widget.dart';

class FavoriteRoute extends StatefulWidget {
  @override
  _FavoriteRouteState createState() => new _FavoriteRouteState();
}

class _FavoriteRouteState extends State<FavoriteRoute> {
  int _page = 0;
  List<FavoriteDataDatas> datas = new List();
  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('我的收藏'),
      ),
      body: _getWidget(),
    );
  }

  Widget _getWidget() {
    return EasyRefresh.custom(
        header: MaterialHeader(),
        footer: MaterialFooter(),
        slivers: <Widget>[
          SliverList(
              delegate: SliverChildBuilderDelegate(
                    (context,index){
                  return NotificationListener<CommonNotification>(
                    child: FavoriteItemWidget(data: datas[index]),
                    onNotification: (notification){
                      print("FavoriteRoute reRefresh");
                      _getData();
                      return true;
                    },
                  );
                },
                childCount: datas.length , //+1 添加banner显示
              )
          ),
        ]
    );
  }

  void _getData() async {
    try{
      var response = await DioHelper.getInstance().get(ApiServer.COLLECT_LIST+"$_page"+"/json");
      var favoriteMap = json.decode(response.toString());
      var entity = FavoriteEntity.fromJson(favoriteMap);
      if (entity.errorCode == -1001) {
        CommonRequest.login(context);
      }else {
        setState(() {
            datas = entity.data.datas;
        });
      }
    }catch(e) {
      return print(e);
    }
  }
}