import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: Transform.scale(
            scale: 8.0,
            child: Container(
              color: Colors.amber,
              child: Text(
                '13',
                style: TextStyle(fontSize: 14, height: 1),
              ),
            ),
          ),
        ),
      ),
    );

    ///下面的代码，文字会以fontSize为10的大小渲染，但是垂直方向的高度为：fontsize:30 * 1.5
    /// const Text(
    ///   'Hello, world!\nSecond line!',
    ///   style: TextStyle(
    ///     fontSize: 10,
    ///     fontFamily: 'Raleway',
    ///   ),
    ///   strutStyle: StrutStyle(
    ///     fontFamily: 'Roboto',
    ///     fontSize: 30,
    ///     height: 1.5,
    ///   ),
    /// ),
  }
}
