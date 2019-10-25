import 'dart:ui' as prefix0;
import 'dart:ui';

import 'package:flutter/material.dart';

class AlignWidget extends StatefulWidget {
  final String text;
  final TextStyle textStyle;
  final Widget rightTop;
  final Widget rightBottom;

  const AlignWidget(
      {Key key, this.text, this.textStyle, this.rightTop, this.rightBottom})
      : super(key: key);

  @override
  _AlignWidgetState createState() => _AlignWidgetState();
}

class _AlignWidgetState extends State<AlignWidget> {
  @override
  Widget build(BuildContext context) {
    //先测量出文字需要占用的高度
    double textHeight =
        getTextH(widget.text ?? '', widget.textStyle?.fontSize ?? 0.0);
    return Container(
      color: Colors.amber,
      height: textHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(widget.text ?? '', style: widget.textStyle,),
          Column(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: widget.rightTop ?? SizedBox(),
              ),
              widget.rightBottom ?? SizedBox()
            ],
          )

        ],
      ),

    );
  }

  ///获取文字的高度
  static double getTextH(String text, double fontSize) {
    Paragraph paragraph;
    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, height: 1),
      ),
    );
    textPainter.layout();
    return textPainter.height;
  }
}
