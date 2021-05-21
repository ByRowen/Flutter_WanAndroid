import 'package:flutter/material.dart';
import 'package:wanandroid/bean/article_json.dart';
import 'package:wanandroid/bean/favorite_json.dart';
import 'package:wanandroid/common/requests.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';

/**
 * 首页文章列表布局
 */
class FavoriteItemWidget extends StatelessWidget {
  FavoriteDataDatas data;

  FavoriteItemWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      //使用卡片布局
      child: FavoriteItemCard(
        id: data.id,
        title: data.title,
        author: data.author,
        type: data.chapterName,
        time: data.niceDate,
        originId: data.originId,
      ),
      onTap: () {
        if (0 == 1) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebPageDetailRoute(
                title: data.title, url: data.link),
          ),
        );
      },
    );
  }
}

class FavoriteItemCard extends StatelessWidget {
  final int id;
  final String title;
  final String author;
  final String type;
  final String time;
  final int originId;

  FavoriteItemCard({
    this.id,
    this.title,
    this.author,
    this.type,
    this.time,
    this.originId,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Text(
                      '$title',
                      style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    margin: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 5.0),
                          child: Text(
                            author.length==0?"分享人：鸿洋":"分享人："+author,
                            style: TextStyle(fontSize: 10.0,color: Colors.red),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            "分类："+type,
                            style: TextStyle(fontSize: 10.0,color: Colors.lightGreen),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            '收藏时间:'+time,
                            style: TextStyle(fontSize: 10.0,),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: Container(
                child:Builder(
                  builder: (buildContext){
                    return  IconButton(
                      icon:Icon(
                        Icons.favorite,
                        color: Theme.of(buildContext).primaryColor,
                      ),
                      onPressed: (){
                        CommonRequest.cancelPageCollect(buildContext,id, originId);
                      },
                    );
                  },
                ),
              )
          ),
        ],
      ),
    );
  }
}