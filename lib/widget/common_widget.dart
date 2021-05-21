import 'package:flutter/material.dart';

class CommonWidget{
  static Widget getLoadingWidget(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Text("正在加载，请稍后..."),
          )
        ],
      ),
    );
  }

  static Widget getReloadWidget<T>(T onclick()) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FlatButton(
              shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
              highlightColor: Colors.blue[700],
              colorBrightness: Brightness.dark,
              splashColor: Colors.grey,
              color: Colors.blueGrey,
              onPressed: onclick,
              child: Text("重新加载"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 26.0),
            child: Text("网络异常，请重新加载..."),
          )
        ],
      ),
    );
  }
}

class CommonNotification extends Notification {
  final String msg;
  CommonNotification(this.msg);
}