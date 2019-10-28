import 'package:flutter/material.dart';
import 'package:flutter_sliver_click/provider_test_page.dart';
class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        body: Center(
          child: FlatButton(
            child: Text('点击打开'),
            onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context){
                return  ProviderTestPage();
              }));
            },
          ),
        ),
      ),
    );
  }
}
