import 'package:flutter/physics.dart';
import 'dart:math' as math;

///
/// 模拟匀减速直线运动
///
class DecelerateSimulation extends Simulation {

  final double _v0;//初速度
  final double _a;
  final double _start;

  DecelerateSimulation(this._v0, this._a, this._start);//加速度


  @override
  double dx(double time) {
    double dx = _v0.abs() - _a.abs() * time;
    return _v0.sign * (dx < 0 ? 0: dx);
  }

  @override
  bool isDone(double time) {
    return dx(time).abs() == 0;
  }

  @override
  double x(double time) {
    return _start +  (_v0.abs() * time - (_a.abs() * math.pow(time, 2)) / 2) * _v0.sign;
  }


  ///计算出初始速度
  static double getV0(double x, double a) {
    return a.sign * math.sqrt(2 * a.abs() * x.abs());
  }

}