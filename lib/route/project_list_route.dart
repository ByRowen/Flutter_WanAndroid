import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wanandroid/bean/project_list_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';
import 'package:wanandroid/widget/common_widget.dart';
import 'package:wanandroid/widget/project_item_widget.dart';

class ProjectListRoute extends StatefulWidget {
  final int id;
  final String title;
  ProjectListRoute({
    Key key,
    @required this.id,
    @required this.title,
  });

  @override
  _ProjectListState createState() => new _ProjectListState();

}

class _ProjectListState extends State<ProjectListRoute> {

  int _page = 0;
  List<ProjectListDataDatas> data = new List();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.share),
              onPressed: (){}
          ),
        ],
      ),
      body: _getWidget(context),
    );
  }

  Widget _getWidget(BuildContext context) {
    if(data.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else{
      return new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        itemCount: data.length,
        itemBuilder: (BuildContext context, int index){
          if(index == data.length-1) {
            _page++;
            getMoreData();
            //加载更多
            return Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.center,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 24.0,
                      height: 24.0,
                      child :CircularProgressIndicator(strokeWidth: 2.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10),
                      child: Text("加载更多...",style: TextStyle(color: Theme.of(context).primaryColor)),
                    )
                  ],
                )
            );
          }
          return new GestureDetector(
            child: ProjectItemWidget(
              img: data[index].envelopePic,
              title: data[index].title,
              author: data[index].author,
              time: data[index].niceShareDate,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebPageDetailRoute(
                      title: data[index].title, url: data[index].link),
                ),
              );
            },
          );
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      );
    }
  }

  void _getData() async {
    try {
      var projectListResponse = await DioHelper.getInstance().get(ApiServer.PROJECT_LIST+"$_page"+"/json",data: {"cid":widget.id});
      var projectListMap = json.decode(projectListResponse.toString());
      var projectListEntity = ProjectListEntity.fromJson(projectListMap);

      setState(() {
        data = projectListEntity.data.datas;
      });
    }catch(e) {
      return print(e);
    }
  }

  void getMoreData() async {
    print("项目列表加载更多:$_page");
    var projectListResponse = await DioHelper.getInstance().get(ApiServer.PROJECT_LIST+"$_page"+"/json",data: {"cid":widget.id});
    var projectListMap = json.decode(projectListResponse.toString());
    var projectListEntity = ProjectListEntity.fromJson(projectListMap);
    setState(() {
      data.addAll(projectListEntity.data.datas);
    });
  }

}

