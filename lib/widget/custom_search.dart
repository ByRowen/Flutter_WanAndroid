import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wanandroid/bean/article_json.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';

/**
 * 自定义搜素
 */
class CustomSearchDelegate extends SearchDelegate<String> {

  List<String> hotWordDatas = List(); //热点词
  List<ArticleDetailDatas> articleDatas = List(); //搜素文章
  List<String> historyDatas = new List(); //历史词

  CustomSearchDelegate(List<String> hotWords,List<String> historyWords) {
    hotWordDatas.clear();
    historyDatas.clear();

    hotWordDatas.addAll(hotWords);
    historyDatas.addAll(historyWords);
  }

  String searchHint = "请输入搜索内容...";

  @override
  String get searchFieldLabel => searchHint;

  @override
  TextStyle get searchFieldStyle => new TextStyle(color:Colors.black12);

  // 重写搜索框右上角方法
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.search),
          onPressed: () async{
            var data = {'k': query};
            var articleResponse = await DioHelper().post(ApiServer.QUERY, data: data);
            var articleMap = json.decode(articleResponse.toString());
            var articleEntity = ArticleEntity.fromJson(articleMap);
            articleDatas = articleEntity.data.datas;
            //保存搜素关键字
            _saveSearchWord();
            //显示结果
            showResults(context);
          }
      ),
      // 显示一个清除的按钮
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
    ];
  }

  //重写左上角方法
  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  //搜索结果
  //重写键盘点击确认后方法
  @override
  Widget buildResults(BuildContext context) {
    _saveSearchWord();
    return ListView.builder(
        shrinkWrap: true,
        itemCount: articleDatas.length,
        itemBuilder: (BuildContext context, int position) {
          if (position.isOdd) Divider();
          return GestureDetector(
            child: Container(
                padding: EdgeInsets.all(10.0),
                child: ListTile(
                  title: Text(
                    articleDatas[position].title.replaceAll("<em class='highlight'>", "【").replaceAll("<\/em>", "】"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.black),
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 10.0),
                    child: Row(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6),
                          decoration: BoxDecoration(
                            border: Border.all(color: Theme.of(context).primaryColor, width: 1.0),
                            borderRadius: BorderRadius.circular((20.0)), // 圆角度
                          ),
                          child: Text(
                            articleDatas[position].superChapterName,
                            style: TextStyle(color: Theme.of(context).primaryColor,),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 15),
                          child: Text(articleDatas[position].author),
                        ),
                      ],
                    ),
                  ),
                  trailing: Icon(Icons.chevron_right),
                )),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WebPageDetailRoute(
                      title: articleDatas[position]
                          .title
                          .replaceAll("<em class='highlight'>", "")
                          .replaceAll("<\/em>", ""),
                      url: articleDatas[position].link),
                ),
              );
            },
          );
        });
  }

  //重写输入过程方法,在输入过程不断调用
  @override
  Widget buildSuggestions(BuildContext context) {
    print("buildSuggestions");
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "大家都在搜：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Wrap(
            spacing: 5.0, //两个widget之间横向的间隔
            direction: Axis.horizontal, //方向
            alignment: WrapAlignment.start, //内容排序方式
            children: _genrateWord(context, hotWordDatas,true),
          ),
          Text(
            "历史记录：",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey,
            ),
          ),
          Expanded(
              child: Wrap(
                spacing: 5.0, //两个widget之间横向的间隔
                direction: Axis.horizontal, //方向
                alignment: WrapAlignment.start, //内容排序方式
                children: _genrateWord(context, historyDatas,false),
              )
          ),
        ],
      ),
    );
  }

  //Chip组件:包括普通的Chip、ActionChiop、FilterChip、ChoiceChip，
  // 普通的Chip相当于tags标签，而且，这个标签还可以设置头像、图标，还有删除回调
  // ActionChip则相当于可点击的Chip
  // FilterChip则是可以选择和取消选择的Chip，并且有选中状态，选中后前面会显示“√”
  // ChoiceChip相当于单选的Chip，点击Chip，也有选中状态等
  List<Widget> _genrateWord(BuildContext context,List<String> words,bool isHot){
    if(words.isEmpty || words.length == 0) {
      return [];
    }
    return List<Widget>.generate(
      words.length,
          (int index) {
        return ActionChip(
          //标签文字
            label: Text(
              words[index],
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
            //点击事件
            onPressed: () async {
              query = words[index];
              /// 请求数据
              var data = {'k': query};
              var articleResponse = await DioHelper().post(ApiServer.QUERY, data: data);
              var articleMap = json.decode(articleResponse.toString());
              var articleEntity = ArticleEntity.fromJson(articleMap);
              articleDatas = articleEntity.data.datas;
              /// 显示结果
              showResults(context);
            },
            elevation: 3,
            backgroundColor: isHot?
            Color.fromARGB(180, Random().nextInt(255), Random().nextInt(255), Random().nextInt(255),)
                :Colors.grey
        );
      },
    ).toList();
  }

  void _saveSearchWord() async{
    if(hotWordDatas.contains(query)) {
      return;
    }
    if(!historyDatas.contains(query)) {
      historyDatas.add(query);
      //存储搜素关键词
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("history", (prefs.getString("history")??"")+query+" ");
    }
  }

}