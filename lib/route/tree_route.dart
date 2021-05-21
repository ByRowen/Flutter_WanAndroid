import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid/bean/tree_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/widget/common_widget.dart';
import 'package:wanandroid/widget/tree_list_widget.dart';

class TreeRoute extends StatefulWidget{
  TreeRoute({Key key}) : super(key: key);

  @override
  _TreeRouteState createState() => new _TreeRouteState();
}

class _TreeRouteState extends State<TreeRoute> {
  List<TreeData> data = new List();
  bool isReqException =false;

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: getWidget(context),
      );
  }

  Widget getWidget(BuildContext context){
    if(isReqException) {
      return CommonWidget.getReloadWidget(() => getData());
    }
    if(data.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else {
      return TreeListWidget(data: data);
    }
  }

  void getData() async {
    try {
      var treeResponse = await DioHelper.getInstance().get(ApiServer.TREE);
      var treeMap   = json.decode(treeResponse.toString());
      var treeEntuty = TreeEntity.fromJson(treeMap);

      setState(() {
        isReqException =false;
        data = treeEntuty.data;
      });
    }catch(e) {
      setState(() {
        isReqException =true;
      });
      return print(e);
    }
  }
}