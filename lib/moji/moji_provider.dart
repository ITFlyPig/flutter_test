import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MOjiProvider with ChangeNotifier {
  String _name;
  int _age;

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  int get age => _age;

  set age(int value) {
    _age = value;
    notifyListeners();
  }
}

typedef OnUpdate = void Function(dynamic tag);
typedef DisposeProvider = void Function(dynamic tag);

abstract class BaseProvider extends ChangeNotifier {
  void disposeProvider(BuildContext context);
}

class MOProvider extends BaseProvider {
  Property<double> _headerH = Property();
  Property<int> _age = Property();

  double getHeaderH() {
    return _headerH.get() ?? 0.0;
  }

  setHeaderH(double headerH) {
    _headerH.set(headerH);
  }

  subscribeHeaderH(BuildContext context) {
    _headerH.subscribe(context);
  }

  int getAge() {
    return _age.get() ?? 0;
  }

  setAge(int age) {
    _age.set(age);
  }

  subscribeAge(BuildContext context, OnUpdate onUpdate) {
    _age.subscribe(context);
  }

  @override
  void disposeProvider(BuildContext context) {
    _headerH?.dispose(context);
    _age?.dispose(context);
  }
}

class Property<T> {
  T _value;
  Map<BuildContext, OnUpdate> subscribeMap;

  ///获取值
  T get() {
    return _value;
  }

  ///设置值
  set(T newValue) {
    if (_value != newValue) {
      _value = newValue;
      subscribeMap?.forEach((k, v) {
        v?.call(newValue);
      });
    }
  }

  ///订阅
  subscribe(BuildContext context) {
    print('subscribe 开始订阅');
    subscribeMap ??= Map();
    if (!subscribeMap.containsKey(context)) {
      subscribeMap[context] = (data){
        Element element = context;
        element.markNeedsBuild();
      };
    }
  }

  ///释放资源
  dispose(BuildContext context) {
    subscribeMap?.remove(context);

  }
}

class AccurateConsumer2<T extends BaseProvider> extends StatefulWidget {
  final Widget Function(BuildContext context, T provider) builder;

  const AccurateConsumer2({Key key, this.builder})
      : super(key: key);

  @override
  State<AccurateConsumer2<T>> createState() {
    print('builder:' + builder?.toString());
    return _AccurateConsumer2State<T>();
  }
}

class _AccurateConsumer2State<T extends BaseProvider> extends State<AccurateConsumer2<T>> {
  T provider;
  @override
  Widget build(BuildContext context) {
    provider = Provider.of(context, listen: false);
    return widget?.builder(context, provider);
  }

  @override
  void dispose() {
    super.dispose();
    print('_AccurateConsumer2State dispose');
    provider?.disposeProvider(context);
  }


}
