import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'moji/moji_provider.dart';

class ProviderTestPage extends StatefulWidget {
  @override
  _ProviderTestPageState createState() => _ProviderTestPageState();
}

class _ProviderTestPageState extends State<ProviderTestPage> {

  @override
  void initState() {
    super.initState();
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => MOProvider(),
        ),
      ],
      child: Material(
        child: SafeArea(
          child: Scaffold(
            body: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: AccurateConsumer2<MOProvider>(
                        builder: (context,moProvider) {
                          print('build 高度1');
                          moProvider.subscribeHeaderH(context);
                          return Text('高度1：' + moProvider.getHeaderH()?.toString());
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AccurateConsumer2<MOProvider>(
                        builder: (context, moProvider) {
                          print('build 年龄');
                          return Text('年龄：' + moProvider?.getAge()?.toString());
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: AccurateConsumer2<MOProvider>(
                        builder: (context,moProvider) {
                          print('build 高度2');
                          moProvider.subscribeHeaderH(context);
                          return Text('高度2：' + moProvider.getHeaderH()?.toString());
                        },
                      ),
                    )
                  ],
                ),
                LayoutBuilder(
                  builder: (context, _) {
                    return FlatButton(
                      child: Text('年龄增加'),
                      onPressed: () {
                        MOProvider mojiProvider =
                            Provider.of<MOProvider>(context, listen: false);
                        mojiProvider.setHeaderH(mojiProvider.getHeaderH() + 1);
                      },
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
