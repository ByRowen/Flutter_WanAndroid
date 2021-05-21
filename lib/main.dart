import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/common/colors.dart';
import 'package:wanandroid/provider/theme_provider.dart';
import 'package:wanandroid/route/home_route.dart';
import 'package:wanandroid/route/nav_route.dart';
import 'package:wanandroid/route/project_route.dart';
import 'package:wanandroid/route/question_answer_route.dart';
import 'package:wanandroid/route/tree_route.dart';
import 'package:wanandroid/widget/custom_search.dart';
import 'package:wanandroid/widget/drawer_widget.dart';

import 'bean/hot_json.dart';
import 'common/strings.dart';
import 'http/api.dart';
import 'http/dio_helper.dart';

void main() async {
  //runApp前调用，初始化绑定，手势、渲染、服务等
  WidgetsFlutterBinding.ensureInitialized();
  String colorKey = await getThemeKey(); //在界面加载前读取存储的主题数据
  runApp(MyApp(colorKey: colorKey));
}

Future<String> getThemeKey() async {
  SharedPreferences sp = await SharedPreferences.getInstance();
  String colorKey = sp.getString("theme_color");
  if (colorKey == null) {
    //首次启动没有保存 默认为第一个主题颜色
    colorKey = "defalut";
  }
  return colorKey;
}

class MyApp extends StatelessWidget {
  Color _themeColor;
  String colorKey;

  MyApp({Key key, @required this.colorKey}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppThemeProvider()),
      ],
      child: Consumer<AppThemeProvider>(
          builder: (context,appInfo,_){
            String color =appInfo.themeColor;
            if(color == null) {
              color = colorKey;
            }
            var map = ColorsUtil.getThemeColors();
            if (map[color] != null) {
              _themeColor = map[color];
            }
            print("主题颜色:"+color);
            return MaterialApp(
              title: '玩Android',
              //去掉右上角的debug贴纸
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                primaryColor: _themeColor,
                floatingActionButtonTheme: FloatingActionButtonThemeData(backgroundColor: _themeColor),
              ),
              home: MyHomePage(title: '玩Android'),
            );
          }
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  int _selectedIndex = 0;
  String title = StringConstant.appName;
  //PageView的控制器
  var _pageController = PageController(initialPage: 0);

  var pages = <Widget>[
    HomeRoute(),
    NaviRoute(),
    QuestionAndAnswerRoute(),
    TreeRoute(),
    ProjectRoute(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //导航栏
      appBar: AppBar(
        title: Text(title),
        //修改抽屉图标样式
        leading: Builder(
          builder: (context){
            return IconButton(
              icon: Icon(Icons.dashboard, color: Colors.white), //自定义图标
              onPressed: () {
                // 打开抽屉菜单
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                _openSearch();//打开搜素页
              }
          )
        ],
      ),
      //抽屉
      drawer: new CustomDrawerWidget(),
      body: PageView.builder(
        //相当于android中ViewPager的滑动事件
        onPageChanged: _pageChange,
        controller: _pageController,
        itemCount: pages.length,
        itemBuilder: (BuildContext context, int index) {
          return pages.elementAt(_selectedIndex);
        },
      ),
      //底部导航栏
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('首页')),
          BottomNavigationBarItem(icon: Icon(Icons.navigation), title: Text('导航')),
          BottomNavigationBarItem(icon: Icon(Icons.question_answer), title: Text('问答')),
          BottomNavigationBarItem(icon: Icon(Icons.filter_list), title: Text('体系')),
          BottomNavigationBarItem(icon: Icon(Icons.apps), title: Text('项目')),
        ],
        //当前选中下标
        currentIndex: _selectedIndex,
        //显示模式
        type: BottomNavigationBarType.fixed,
        //选中颜色
        fixedColor: Theme.of(context).primaryColor,
        //点击事件
        onTap: _onItemTapped,
      ),
    );
  }

  void _onItemTapped(int index) {
    print("点击了:$index");
    //bottomNavigationBar 和 PageView 关联,页面跳转
    _pageController.jumpToPage(index);
  }

  void _pageChange(int index) {
    setState(() {
      _selectedIndex = index;
      //根据下标修改标题
      switch (index) {
        case 0:
          title = StringConstant.appName;
          break;
        case 1:
          title = StringConstant.navi;
          break;
        case 2:
          title = StringConstant.qa;
          break;
        case 3:
          title = StringConstant.tree;
          break;
        case 4:
          title = StringConstant.project;
          break;
      }
    });
  }

  void _openSearch() async {
    try {
      //获取热点词语
      var hotResponse = await DioHelper.getInstance().get(ApiServer.HOT_KEY);
      var hotMap = json.decode(hotResponse.toString());
      var hotEntity = HotWordEntity.fromJson(hotMap);

      //获取历史搜素关键词
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var historyWord = prefs.getString("history")??"";

      List<String> hotWords = List();
      List<String> historyWords = List();
      if(hotEntity.data.isNotEmpty) {
        hotEntity.data.forEach((element) {
          hotWords.add(element.name);
        });
      }
      if(historyWord.isNotEmpty && historyWord.length > 0) {
        var list = historyWord.split(" ");
        list.forEach((element) {
          if(element.isNotEmpty && element.length > 0) {
            historyWords.add(element);
          }
        });
      }
      //3个参数：上下文，搜索代理，关键词,其中前两个必传，query可选
      showSearch(context: context, delegate: CustomSearchDelegate(hotWords,historyWords));
    }catch(e) {
      return print(e);
    }
  }
}
