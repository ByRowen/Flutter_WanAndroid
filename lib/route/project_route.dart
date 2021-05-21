import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wanandroid/bean/project_json.dart';
import 'package:wanandroid/bean/project_list_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';
import 'package:wanandroid/widget/common_widget.dart';
import 'package:wanandroid/widget/project_item_widget.dart';

class ProjectRoute extends StatefulWidget{
  ProjectRoute({Key key}) : super(key: key);

  @override
  _ProjectRouteState createState() => new _ProjectRouteState();
}

class _ProjectRouteState extends State<ProjectRoute> with TickerProviderStateMixin {
  List<ProjectData> _data = new List();
  List<ProjectListDataDatas> _projectList = new List();
  TabController _tabController; //tab的Controller
  ScrollController _scrollController = new ScrollController();//列表滚动控制器
  int _currentIndex = 0; //当前下标
  int _page = 0; //页
  bool isReqException =false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController( length: 0,vsync: this);
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到底部了!');
        setState(() {
          _page++;
        });
        getMoreData();
      }
    });
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return getWidget(context);
  }

  Widget getWidget(BuildContext context){
    if(isReqException) {
      return CommonWidget.getReloadWidget(() => {
        _getData()
      });
    }
    if(_data.isEmpty) {
      return CommonWidget.getLoadingWidget();
    }else {
      return Scaffold(
        //使用TabBar+TabBarView实现项目列表展示
        appBar: TabBar(
            controller: _tabController,//控制器
            isScrollable: true,//是否滚动
            labelColor: Theme.of(context).primaryColor,//选中的颜色
            labelStyle: TextStyle(fontSize: 16),//选中的样式
            unselectedLabelColor: Colors.blueGrey,//未选中的颜色
            unselectedLabelStyle: TextStyle(fontSize: 14),//未选中的样式
            indicatorColor: Theme.of(context).primaryColor,//下划线颜色
            onTap: (index) {
              //点击tab，需要更新下标，数据也要重新更新
              this.setState(() {
                _currentIndex = index;
              });
              print("tab 下标:$_currentIndex");
              _getListData();
            },
            tabs: _data.map((e) => Tab(text: e.name)).toList()//tab栏
        ),
        body: TabBarView(
          controller: _tabController,
          children: _data.map((e) { //创建Tab页
            return _getProjectListWidget();
          }).toList(),
        ),
          //使用瀑布布局展示的项目分类布局
          //body: ProjectWidget(data: data),
      );
    }
  }

  void _getData() async {
    try{
      //获取项目分类数据
      var projectResponse = await DioHelper.getInstance().get(ApiServer.PROJECT);
      var projectMap = json.decode(projectResponse.toString());
      var projectEntity = ProjectEntity.fromJson(projectMap);

      setState(() {
        isReqException = false;
        _data = projectEntity.data;
        _tabController = TabController( length: _data.length,vsync: this);
      });

      //获取项目列表数据
      _getListData();

      _tabController.addListener(() {
        this.setState(() {
          _currentIndex = _tabController.index;
        });
        print("tab 下标:$_currentIndex");
        _getListData();
      });
    }catch(e){
      setState(() {
        isReqException = true;
      });
      return print("项目"+e.toString());
    }
  }

  void _getListData() async {
    try {
      var cid = _data[_currentIndex].id;
      print("项目id=$cid");
      var projectListResponse = await DioHelper.getInstance().get(ApiServer.PROJECT_LIST+"$_page"+"/json",data: {"cid":cid});
      var projectListMap = json.decode(projectListResponse.toString());
      var projectListEntity = ProjectListEntity.fromJson(projectListMap);

      setState(() {
         _projectList= projectListEntity.data.datas;
      });
    }catch(e) {
      return print(e);
    }
  }

  void getMoreData() async {
    print("项目列表加载更多:$_page");
    var cid = _data[_currentIndex].id;
    var projectListResponse = await DioHelper.getInstance().get(ApiServer.PROJECT_LIST+"$_page"+"/json",data: {"cid":cid});
    var projectListMap = json.decode(projectListResponse.toString());
    var projectListEntity = ProjectListEntity.fromJson(projectListMap);
    setState(() {
      _projectList.addAll(projectListEntity.data.datas);
    });
  }

  Widget _getProjectListWidget() {
    return Container(
      child: new StaggeredGridView.countBuilder(
        crossAxisCount: 4,
        controller: _scrollController,
        itemCount: _projectList.length,
        itemBuilder: (BuildContext context, int index){
          return new GestureDetector(
            child: ProjectItemWidget(
              img: _projectList[index].envelopePic,
              title: _projectList[index].title,
              author: _projectList[index].author,
              time: _projectList[index].niceShareDate,
            ),
            onTap: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebPageDetailRoute(
                      title: _projectList[index].title, url: _projectList[index].link),
                ),
              );
            },
          );
        },
        staggeredTileBuilder: (index) => StaggeredTile.fit(2),
        mainAxisSpacing: 4.0,
        crossAxisSpacing: 4.0,
      ),
    );
  }
}