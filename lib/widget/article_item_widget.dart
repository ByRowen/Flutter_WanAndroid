import 'package:flutter/material.dart';
import 'package:wanandroid/bean/article_json.dart';
import 'package:wanandroid/common/requests.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';

/**
 * 首页文章列表布局
 */
class ArticleItemWidget extends StatelessWidget {
  ArticleDetailDatas data;

  ArticleItemWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      //使用卡片布局
      child: ArticleItemCard(
        id: data.id,
        title: data.title,
        author: data.shareUser,
        type: data.superChapterName,
        time: data.niceShareDate,
        fresh: data.fresh,
        collect: data.collect,
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

class ArticleItemCard extends StatelessWidget {
  final int id;
  final String title;
  final String author;
  final String type;
  final String time;
  final bool fresh;
  final bool collect;

  ArticleItemCard({
    this.id,
    this.title,
    this.author,
    this.type,
    this.time,
    this.fresh,
    this.collect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 1,
              child: Container(
                child:Builder(
                  builder: (buildContext){
                    return  IconButton(
                      icon: collect?
                      Icon(
                        Icons.favorite,
                        color: Theme.of(buildContext).primaryColor,
                      ) : Icon(Icons.favorite_border),
                      onPressed: (){
                        if (collect) {
                          CommonRequest.cancelCollect(buildContext,id);
                        } else {
                          CommonRequest.addCollect(buildContext, id);
                        }
                      },
                    );
                  },
                ),
              )
          ),
          Expanded(
            flex: 8,
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
                            '$time',
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
        ],
      ),
    );
  }
}