import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:wanandroid/bean/question_answer_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/widget/common_widget.dart';
import 'package:wanandroid/widget/question_answer_list_widget.dart';

class QuestionAndAnswerRoute extends StatefulWidget {

  @override
  _QuestionAndAnswerState createState() => new _QuestionAndAnswerState();
}

class _QuestionAndAnswerState extends State<QuestionAndAnswerRoute> {
  int _page = 0;
  List<QADatas> data = new List();
  bool isReqException =false;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getWidget(context),
    );
  }

  Widget _getWidget(BuildContext context){
    if(isReqException) {
      return CommonWidget.getReloadWidget(() => _getData());
    }
    if(data.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else {
      return EasyRefresh.custom(
          header: MaterialHeader(),
          footer: MaterialFooter(),
          onLoad: () async {
            setState(() {
              _page++;
            });
            _getMoreData();
          },
          slivers: <Widget>[
            SliverList(
                delegate: SliverChildBuilderDelegate(
                    (context,index){
//                        return QuestionAnswerListWidget(data: data[index]);
                        //Flutter中将这种由子向父的传递通知的机制称为通知冒泡（Notification Bubbling)
                        return NotificationListener<CommonNotification>(
                            child: QuestionAnswerListWidget(data: data[index]),
                            onNotification: (notification){
                              _getData();
                              return true;
                            },
                        );
                    },
                    childCount: data.length
                ),
            ),
          ]
      );
    }
  }

  void _getData() async {
    try{
      var QAResponse = await DioHelper.getInstance().get(ApiServer.Q_A+"$_page"+"/json");
      var QAMap = json.decode(QAResponse.toString());
      var entity = QAEntity.fromJson(QAMap);

      setState(() {
        isReqException = false;
        data = entity.data.datas;
      });
    }catch(e) {
      setState(() {
        isReqException = true;
      });
      return print("问答"+e.toString());
    }
  }

  void _getMoreData() async {
    try{
      var QAResponse = await DioHelper.getInstance().get(ApiServer.Q_A+"$_page"+"/json");
      var QAMap = json.decode(QAResponse.toString());
      var entity = QAEntity.fromJson(QAMap);

      Future.delayed(Duration(milliseconds: 200)).then((e) {
        setState(() {
          data.addAll(entity.data.datas);
        });
      });

    }catch(e) {
      return print(e);
    }
  }

}