import 'package:flutter/material.dart';
import 'package:flutter_sliver_click/pinned_sliver.dart';

class SliverClickPage extends StatefulWidget {
  @override
  _SliverClickPageState createState() => _SliverClickPageState();
}

class _SliverClickPageState extends State<SliverClickPage> {
  @override
  Widget build(BuildContext context) {
    ListView listView = ListView.builder(
      itemBuilder: (context, index) {
        return Container(
          width: double.infinity,
          height: 100,
          child: Center(
            child: Text('序号：' + index.toString()),
          ),
        );
      },
      itemCount: 30,
    );

    List<Widget> slivers = listView.buildSlivers(context);
    slivers.add(PinnedSliverObjectWidget(
      child: Container(
        width: double.infinity,
        height: 100,
        child: GestureDetector(
          onTap: () {
            print('我被点击了');
          },
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Text("测试点击"),
          ),
        ),
      ),
    ));
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          body:listView ,
          headerSliverBuilder:(context, s) {
            return []..add(PinnedSliverObjectWidget(
              child: Container(
                width: double.infinity,
                color: Colors.amber,
                height: 100,
                child: GestureDetector(
                  onTap: () {
                    print('我被点击了');
                  },
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Text("标题"),
                    ),
                  ),
                ),
              ),
            ));
          } ,
        ),
      ),
    );
  }

}
