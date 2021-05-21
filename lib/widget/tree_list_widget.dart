import 'package:flutter/material.dart';
import 'package:wanandroid/bean/tree_json.dart';
import 'package:wanandroid/common/colors.dart';
import 'package:wanandroid/route/tree_detail_route.dart';

class TreeListWidget extends StatelessWidget {
  final List<TreeData> data;
  List<MaterialColor> _colors = ColorsUtil.getColorsList();

  TreeListWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
        itemCount: data.length,
        separatorBuilder: (context, index) => Divider(height: .1),
        itemBuilder: (context,index){
          return Card(
            color: _colors[index%_colors.length],
            child: Column(
              children: <Widget>[
                Text(
                    data[index].name,
                    style: TextStyle(fontSize: 18.0,color: Colors.white),
                ),
                ChildTreeWidget(data: data[index].children),
              ],
            ),
          );
        },
    );
  }

}

class ChildTreeWidget extends StatelessWidget {
  final List<TreeDatachild> data;

  ChildTreeWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(10.0),
        child: Wrap(
          children: _generateList(),
          spacing: 1.0,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.end,
        ),
    );
  }

  List<Widget> _generateList(){
    return data.map((item) => TreeButtonItemWidget(data: item)).toList();
  }

}

class TreeButtonItemWidget extends StatelessWidget {
  final TreeDatachild data;

  TreeButtonItemWidget({
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
          print("点击了name:"+data.name);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TreeDetailRoute(name: data.name,id: data.id,),
            ),
          );
        },
        child: Text(data.name,style: TextStyle(color: Colors.white,fontSize: 12.0)),
    );
  }
}