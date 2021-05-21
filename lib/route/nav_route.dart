import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid/bean/navi_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';
import 'package:wanandroid/widget/common_widget.dart';

class NaviRoute extends StatefulWidget{
  NaviRoute({Key key}) : super(key: key);

  @override
  _NaviRouteState createState() => new _NaviRouteState();
}

class _NaviRouteState extends State<NaviRoute> {
  List<NaviData> naviData = new List();
  List<NaviDataArticle> data = new List();
  bool isReqException =false;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    try{
      var naviResponse = await DioHelper.getInstance().get(ApiServer.NAVI);
      var naviMap =json.decode(naviResponse.toString());
      var naviEntity = NaviEntity.fromJson(naviMap);

      setState(() {
        isReqException = false;
        naviData = naviEntity.data;
      });
    }catch(e){
      setState(() {
        isReqException = true;
      });
      return print("导航"+e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _getWidget(),
    );
  }

  Widget _getWidget(){
    if(isReqException) {
      return CommonWidget.getReloadWidget(() => _getData());
    }
    if(naviData.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else {
      return Container(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: ListView.builder(
                  itemCount: naviData.length,
                  itemBuilder: (context,index){
                    return new GestureDetector(
                      child: Container(
                        alignment: Alignment.center,
                        //用于设置对称方向的填充，vertical指top和bottom，horizontal指left和right
                        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueGrey),
                        ),
                        child: Text(
                          naviData[index].name,
                          style: TextStyle(fontSize: 14,),
                        ),
                      ),
                      onTap: (){
                        setState(() {
                          _index = index;
                        });
                      },
                    );
                  }
              ),
            ),
            Expanded(
              flex: 5,
              child: ListView(
                children: <Widget>[
                  _genrateWidget(_index),
                ],
              ),
            ),
          ],
        ),
      );
    }
  }

  Widget _genrateWidget(int index){
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10.0),
          alignment: Alignment.topLeft,
          child: Text(naviData[index].name,style: TextStyle(fontSize: 18.0,color: Colors.red)),
        ),
        Wrap(
            children:_genrateList(index),
            spacing: 1.0,
            direction: Axis.horizontal, //方向
            alignment: WrapAlignment.center, //内容排序方式
        ),
      ],
    );
  }

  List<Widget> _genrateList(int index){
    data = naviData[index].articles;
    return data.map((item) => NaviButtonItemWidget(data: item)).toList();
  }

}

class NaviButtonItemWidget extends StatelessWidget {
  final NaviDataArticle data;

  NaviButtonItemWidget({
    Key key,
    @required this.data
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
      highlightColor: Colors.blue[700],
      colorBrightness: Brightness.dark,
      splashColor: Colors.grey,
      color: Colors.blueGrey,
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebPageDetailRoute(
                title: data.title, url: data.link),
          ),
        );
      },
      child: Text(data.title,style: TextStyle(color: Colors.white,fontSize: 12.0),),
    );
  }
}