import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid/bean/common_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/login_route.dart';
import 'package:wanandroid/widget/common_widget.dart';

class CommonRequest{
  static void login(BuildContext context)async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginRoute()),
    );
  }

  static void addCollect(BuildContext context ,int id) async {
    var collectResponse = await DioHelper.getInstance().post(ApiServer.COLLECT + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      login(context);
    }else {
      //通知父树刷新
      CommonNotification("refresh").dispatch(context);
    }
  }

  static void cancelCollect(BuildContext context,int id) async {
    var collectResponse = await DioHelper.getInstance().post(ApiServer.UN_COLLECT_ORIGIN_ID + '$id/json');
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      login(context);
    }else {
      //通知父树刷新
      CommonNotification("refresh").dispatch(context);
    }
  }

  static void cancelPageCollect(BuildContext context,int id,int originId) async {
    var collectResponse = await DioHelper.getInstance().post(ApiServer.UN_COLLECT + '$id/json',data: {'originId': originId});
    Map map = json.decode(collectResponse.toString());
    var entity = CommonEntity.fromJson(map);
    if (entity.errorCode == -1001) {
      login(context);
    }else {
      //通知父树刷新
      CommonNotification("refresh").dispatch(context);
    }
  }
}