import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:wanandroid/bean/project_json.dart';
import 'package:wanandroid/common/colors.dart';
import 'package:wanandroid/route/project_list_route.dart';

class ProjectWidget extends StatelessWidget {
  final List<ProjectData> data;
  List<MaterialColor> _colors = ColorsUtil.getColorsList();

  ProjectWidget({
    Key key,
    @required this.data
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return new StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: data.length,
      itemBuilder: (BuildContext context, int index){
        return new GestureDetector(
          child: new Container(
              color: _colors[index%_colors.length],
              child: new Center(
                child: new Text(
                  data[index].name,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0
                  ),
                ),
              )),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProjectListRoute(id: data[index].id,title: data[index].name,),
              ),
            );
          },
        );
      },
      staggeredTileBuilder: (int index) => new StaggeredTile.count(2, index.isEven ? 2 : 1),
      mainAxisSpacing: 4.0,
      crossAxisSpacing: 4.0,
    );
  }
}