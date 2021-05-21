import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:wanandroid/bean/bannner_json.dart';

class BannerWidget extends StatefulWidget{
  List<BannerData> data;

  BannerWidget({
    Key key,
    @required this.data,
  }):super(key: key);

  @override
  _BannerWidgetState createState() => new _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10),
      //屏幕宽度
      width: MediaQuery.of(context).size.width,
      //1.8是banner宽高比，0.8是viewportFraction的值
      height: MediaQuery.of(context).size.width / 1.8 * 0.8,
      child: new Swiper(
          itemCount: widget.data.length,
          //视图宽度，即显示的item的宽度屏占比
          viewportFraction: 0.8,
          //两侧item的缩放比
          scale: 0.9,
          itemBuilder: (context,index){
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(widget.data[index].imagePath),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
          pagination: new SwiperPagination(
            builder: DotSwiperPaginationBuilder(
              color: Colors.black54,//未选择颜色
              activeColor: Colors.white,//选择颜色
              size: 5.0,//大小
              activeSize: 5.0,//选中大小
            )
          ),
          control: new SwiperControl(),
          scrollDirection: Axis.horizontal,//滚动方向，设置为Axis.vertical如果需要垂直滚动
          autoplay: true,
          onTap: (index) => print('点击了第$index个'),//点击事件
      ),
    );
  }
}