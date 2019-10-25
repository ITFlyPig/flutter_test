import 'package:flutter/material.dart';
import 'package:flutter_sliver_click/widgets/header_widget.dart';
import 'dart:ui';
class MOjiPage extends StatefulWidget {
  @override
  _MOjiPageState createState() => _MOjiPageState();
}

class _MOjiPageState extends State<MOjiPage> {
  static const int HEADER = 0;//头部
  static const int TWO_DAY = 1;//今天和明天的天气信息
  static const int HOUR_24 = 2;//24小时天气预报
  static const int DAY_15 = 3;//15天天气预报
  static const int LIFE = 4;//生活指数
  double _headerH = 0.0;//头部的高度
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.lightBlue,
      child: Scaffold(
        body: ListView.builder(
            itemBuilder: (context, index){
          return _getWidgetByIndex(context, index);
        },
//          physics: null,
//          controller: null,
        itemCount: 5,
        ),
      ),
    );
  }


  Widget _getWidgetByIndex(BuildContext context, int index) {
    Widget widget;
    switch(index) {
      case HEADER:
        widget = _getHeaderWidget();
        break;
      case TWO_DAY:
        widget = _getTwoDayWidget();
        break;
      case HOUR_24:
        widget = _get24HourWidget();
        break;
      case DAY_15:
        widget = _get15DayWidget();
        break;
      case LIFE:
        widget = _getLifeWidget();
        break;
    }
    widget ??= SizedBox();
    return widget;

  }

  ///获取天气的概况信息
  Widget _getHeaderWidget() {
    _headerH = MediaQuery.of(context).size.height - 100 - MediaQueryData.fromWindow(window).padding.top;
    return HeaderWidget(height: _headerH,);

  }

  ///获取两天的天气的信息
  Widget _getTwoDayWidget() {
    return Container(
      color: Colors.grey[300],
      height: 100,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Text('今天天气', style: TextStyle(color: Colors.white),),
            ),
            flex: 1,
          ),
          Container(
            height: double.infinity,
            width: 0.5,
            color: Colors.grey[200],
          ),
          Expanded(
            child: Center(
              child: Text('今天天气', style: TextStyle(color: Colors.white),),
            ),
            flex: 1,
          )
        ],
      ),
    );

  }

  ///获取24小时预报控件
  Widget _get24HourWidget() {
    return Container(
      height: 500,
      color: Colors.amber,
      child: Text('24小时预报', style: TextStyle(color: Colors.white)),
    );

  }

  ///获取15天预报
  Widget _get15DayWidget(){
    return Container(
      height: 600,
      color: Colors.lightBlue,
      child: Text('15天预报', style: TextStyle(color: Colors.white)),
    );

  }

  ///获取生活指数控件
  Widget _getLifeWidget() {
    return Container(
      height: 300,
      color: Colors.red[100],
      child: Text('生活指数', style: TextStyle(color: Colors.white)),
    );

  }
}
