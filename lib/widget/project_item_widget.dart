import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/**
 * 项目列表条目布局
 */
class ProjectItemWidget extends StatelessWidget {
  final String img;
  final String title;
  final String author;
  final String desc;
  final String time;
  ProjectItemWidget(
      {this.img,
        this.title,
        this.author,
        this.desc,
        this.time,});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(5.0),
            alignment: Alignment.center,
//            child: Image.network(img),
            child: CachedNetworkImage(imageUrl: img),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            child: Text(
              '$title',
              style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.bold),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 5.0),
            margin: const EdgeInsets.symmetric(vertical: 2.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex:2,
                  child: Text(
                    '$author',
                    style: TextStyle(fontSize: 10.0,),
                  ),
                ),
                Expanded(
                  flex:1,
                  child: Text(
                    time.length >10 ?time.substring(0,10):time,
                    style: TextStyle(fontSize: 10.0,),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}