import 'package:flutter/material.dart';

import 'align_widget.dart';

///头部显示信息
class HeaderWidget extends StatefulWidget {
  final double height;

  const HeaderWidget({Key key, this.height}) : super(key: key);

  @override
  _HeaderWidgetState createState() => _HeaderWidgetState();
}

class _HeaderWidgetState extends State<HeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.lightBlue,
      height: widget.height,
      child: Column(
        children: <Widget>[
          _temperatureWidget(),
          Expanded(
            flex: 1,
            child: _homeAndVoiceWidget(),
          )
        ],
      ),
    );
  }

  ///显示温度的控件
  Widget _temperatureWidget() {
    return Padding(
      padding: EdgeInsets.fromLTRB(30, 30, 0, 0),
      child: AlignWidget(
        text: '13',
        textStyle: TextStyle(fontSize: 100, color: Colors.white, height: 1),
        rightTop: Text('O  晴', style: TextStyle(fontSize: 20, color: Colors.white),),
        rightBottom: Text('反馈天气', style: TextStyle(fontSize: 15, color: Colors.white)),
      ),
    );
  }

  ///右下角的房子和声音图标
  Widget _homeAndVoiceWidget() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        padding: EdgeInsets.only(right: 15, bottom: 15),
        child: Text('这里是喇叭和房子', style: TextStyle(color: Colors.white),),
      ),
    );
  }
}
