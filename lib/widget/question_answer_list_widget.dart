import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wanandroid/bean/common_json.dart';
import 'package:wanandroid/bean/question_answer_json.dart';
import 'package:wanandroid/common/requests.dart';
import 'package:wanandroid/http/api.dart';
import 'package:wanandroid/http/dio_helper.dart';
import 'package:wanandroid/route/login_route.dart';
import 'package:wanandroid/route/question_answer_route.dart';
import 'package:wanandroid/route/web_page_detail_route.dart';
import 'package:wanandroid/widget/common_widget.dart';

class QuestionAnswerListWidget extends StatelessWidget {

  final QADatas data;

  QuestionAnswerListWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      child: QuestionItemCard(
          id: data.id,
          title: data.title,
          author: data.author,
          type: data.superChapterName+"/"+data.chapterName,
          time: data.niceShareDate,
          collect: data.collect,
      ),
      onTap:(){
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

class QuestionItemCard extends StatelessWidget {
  final int id;
  final String title;
  final String author;
  final String type;
  final String time;
  final bool collect;

  QuestionItemCard({
    this.id,
    this.title,
    this.author,
    this.type,
    this.time,
    this.collect,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: <Widget>[
          Builder(
              builder: (buildContext) {
                return Expanded(
                    flex: 1,
                    child: Container(
                      child: IconButton(
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
                      ),
                    )
                );
              }
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
                          padding: const EdgeInsets.symmetric(vertical:2.0, horizontal: 2.0),
                          margin: EdgeInsets.only(left: 5.0),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.lightGreen)
                          ),
                          child: Text(
                            '本站发布',
                            style: TextStyle(fontSize: 10.0,color:Colors.lightGreen),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical:2.0, horizontal: 2.0),
                          margin: EdgeInsets.only(left: 10.0),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.lightGreen)
                          ),
                          child: Text(
                            '问答',
                            style: TextStyle(fontSize: 10.0,color:Colors.lightGreen),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            '$author',
                            style: TextStyle(fontSize: 10.0,),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 10.0),
                          child: Text(
                            '$type',
                            style: TextStyle(fontSize: 10.0,),
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

