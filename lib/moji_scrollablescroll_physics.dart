import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter_sliver_click/decelerate_simulation.dart';

class MOjiScrollableScrollPhysics extends ScrollPhysics {
  /// Creates scroll physics that bounce back from the edge.
  final double headerH;

   MOjiScrollableScrollPhysics(this.headerH, {ScrollPhysics parent})
      : super(parent: parent);

  @override
  MOjiScrollableScrollPhysics applyTo(ScrollPhysics ancestor) {
    return MOjiScrollableScrollPhysics(headerH, parent: buildParent(ancestor));
  }

  /// The multiple applied to overscroll to make it appear that scrolling past
  /// the edge of the scrollable contents is harder than scrolling the list.
  /// This is done by reducing the ratio of the scroll effect output vs the
  /// scroll gesture input.
  ///
  /// This factor starts at 0.52 and progressively becomes harder to overscroll
  /// as more of the area past the edge is dragged in (represented by an increasing
  /// `overscrollFraction` which starts at 0 when there is no overscroll).
  double frictionFactor(double overscrollFraction) =>
      0.52 * math.pow(1 - overscrollFraction, 2);

  //记录滚动的方向
  double _scrollSign = 1;

  @override
  double applyPhysicsToUserOffset(ScrollMetrics position, double offset) {
    assert(offset != 0.0);
    assert(position.minScrollExtent <= position.maxScrollExtent);
    _scrollSign = offset.sign;
    if (!position.outOfRange) return offset;

    final double overscrollPastStart =
        math.max(position.minScrollExtent - position.pixels, 0.0);
    final double overscrollPastEnd =
        math.max(position.pixels - position.maxScrollExtent, 0.0);
    final double overscrollPast =
        math.max(overscrollPastStart, overscrollPastEnd);
    final bool easing = (overscrollPastStart > 0.0 && offset < 0.0) ||
        (overscrollPastEnd > 0.0 && offset > 0.0);

    final double friction = easing
        // Apply less resistance when easing the overscroll vs tensioning.
        ? frictionFactor(
            (overscrollPast - offset.abs()) / position.viewportDimension)
        : frictionFactor(overscrollPast / position.viewportDimension);
    final double direction = offset.sign;


    return direction * _applyFriction(overscrollPast, offset.abs(), friction);
  }

  static double _applyFriction(
      double extentOutside, double absDelta, double gamma) {
    assert(absDelta > 0);
    double total = 0.0;
    if (extentOutside > 0) {
      final double deltaToLimit = extentOutside / gamma;
//      if (absDelta < deltaToLimit)
      return absDelta * gamma; //gamma逐渐变小，实际应用的偏移量逐渐变小，给人的感觉就是阻力逐渐变大
//      total += extentOutside;
//      absDelta -= deltaToLimit;
    }
    return total + absDelta;
  }

  @override
  double applyBoundaryConditions(ScrollMetrics position, double value) => 0.0;

  @override
  Simulation createBallisticSimulation(
      ScrollMetrics position, double velocity) {
    final Tolerance tolerance = this.tolerance;
    //velocity：抬手时的速度：velocity > 0 ：表示往上滑动；velocity < 0：表示往下滑动
    print('createBallisticSimulation 速度:' +
        velocity.toString() +
        ' 当前位置：' +
        position.pixels.toString() +
        ' outOfRange:' +
        position.outOfRange.toString() +
        ' header:' +
        headerH.toString() + ' 方向：' + _scrollSign.toString());
    if (velocity.abs() >= tolerance.velocity ||
        position.outOfRange ||
        (velocity.abs() == 0 &&
            position.pixels.toInt() > 0 &&
            position.pixels.toInt() < headerH.toInt())) {
      //速度大于设定速度阈值或者发生overscroll时创建弹道模拟器
      //因为当速度为0时，系统传过来的正负并不能反应出滑动的方向，这手动矫正一下
      if(velocity.abs() == 0) {
        velocity = _scrollSign > 0 ? -0.0 : 0.0;
      }
      return MyBouncingScrollSimulation(
        headerH: headerH,
        spring: spring,
        position: position.pixels,
        velocity: velocity * 0.91,
        leadingExtent: position.minScrollExtent,
        trailingExtent: position.maxScrollExtent,
        tolerance: tolerance,
      );
    }
    return null;
  }

  // The ballistic simulation here decelerates more slowly than the one for
  // ClampingScrollPhysics so we require a more deliberate input gesture
  // to trigger a fling.
  @override
  double get minFlingVelocity => 10.0;

  // Methodology:
  // 1- Use https://github.com/flutter/scroll_overlay to test with Flutter and
  //    platform scroll views superimposed.
  // 2- Record incoming speed and make rapid flings in the test app.
  // 3- If the scrollables stopped overlapping at any moment, adjust the desired
  //    output value of this function at that input speed.
  // 4- Feed new input/output set into a power curve fitter. Change function
  //    and repeat from 2.
  // 5- Repeat from 2 with medium and slow flings.
  /// Momentum build-up function that mimics iOS's scroll speed increase with repeated flings.
  ///
  /// The velocity of the last fling is not an important factor. Existing speed
  /// and (related) time since last fling are factors for the velocity transfer
  /// calculations.
  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign *
        math.min(0.000816 * math.pow(existingVelocity.abs(), 1.967).toDouble(),
            40000.0);
  }

  // Eyeballed from observation to counter the effect of an unintended scroll
  // from the natural motion of lifting the finger after a scroll.
  @override
  double get dragStartDistanceMotionThreshold => 3.5;
}

class MyBouncingScrollSimulation extends Simulation {
  MyBouncingScrollSimulation({
    @required this.headerH,
    @required double position,
    @required double velocity,
    @required this.leadingExtent,
    @required this.trailingExtent,
    @required this.spring,
    Tolerance tolerance = Tolerance.defaultTolerance,
  })  : assert(position != null),
        assert(velocity != null),
        assert(leadingExtent != null),
        assert(trailingExtent != null),
        assert(leadingExtent <= trailingExtent),
        assert(spring != null),
        super(tolerance: tolerance) {
    if (position < leadingExtent) {
      //如果内容在最小滚动下面，也就是有underscroll
      _springSimulation = _underscrollSimulation(position, velocity);
      _springTime = double.negativeInfinity;
    } else if (position > trailingExtent) {
      //内容部分在最大滚动上面，也就是有overscroll
      _springSimulation = _overscrollSimulation(position, velocity);
      _springTime = double.negativeInfinity;
    } else {
      //在最小滚动和最大滚动之间，也就是没有overscroll和underscroll
      _frictionSimulation = FrictionSimulation(
          0.135, position, velocity); //摩擦减速模拟器，传入的值分别为：流体阻力系数、当前位置、当前速度
      final double finalX = _frictionSimulation.finalX; //计算出在摩擦阻力的情况下，最终停留的位置
      double _headerH = headerH;

      print('最终将会停止的位置：finalX:' + finalX.toString());
      if (finalX > leadingExtent && finalX < _headerH) {
        //如果最终的停留位置会在头部的中间，决定要么完全显示头部，要么完全隐藏头部
        double end;
        double a = -500;
        int direction = 1;
        if (velocity.toString().contains('-')) {
          //往下滑动

          print('下滑 此时速度：' + velocity.toString());
          if (finalX > headerH - 100) {
            print('隐藏头部');
            end = _headerH;
            direction = 1;
          } else {
            end = 0;
            direction = -1;
            print('显示头部');
          }
        } else {
          //往上滑动
          print('上滑');
          if (velocity.abs() > 50 || (position?.abs() ?? 0.0) > 100) {
            //往下弹显示头部
            print('隐藏头部');
            end = _headerH;
            direction = 1;
          } else {
            print('显示头部');
            end = 0;
            direction = -1;
          }
        }
        double v0 = DecelerateSimulation.getV0((position - end).abs(), a);

        _decelerateSimulation =
            DecelerateSimulation(v0.abs() * direction, a, position);
        _springTime = double.infinity;
      } else if (velocity > 0.0 && finalX > trailingExtent) {
        //如果向上滑动，且最终停留的位置会超出最大滚动位置
        _springTime = _frictionSimulation
            .timeAtX(trailingExtent); //计算到达指定位置需要的时间，这里是计算到达最大滚动位置需要的时间
        _springSimulation = _overscrollSimulation(
          trailingExtent, //开始的位置
          math.min(_frictionSimulation.dx(_springTime),
              maxSpringTransferVelocity), //计算到达最大滚动位时的速度和系统指定的最大速度，取较小的一个
        );
        assert(_springTime.isFinite);
      } else if (velocity < 0.0 && finalX < leadingExtent) {
        ////如果向下滑动，且最终停留的位置会超出最小滚动位置
        //下面同理
        _springTime = _frictionSimulation.timeAtX(leadingExtent);
        _springSimulation = _underscrollSimulation(
          leadingExtent,
          math.min(
              _frictionSimulation.dx(_springTime), maxSpringTransferVelocity),
        );
        assert(_springTime.isFinite);
      } else {
        _springTime = double.infinity;
      }
    }
    assert(_springTime != null);
  }

  ///据开始位置和结束位置，计算出速度
  double getVelocity(double drag, double start, double end) {
    return (start - end) * math.log(drag);
  }

  /// The maximum velocity that can be transferred from the inertia of a ballistic
  /// scroll into overscroll.
  static const double maxSpringTransferVelocity = 5000.0;

  /// When [x] falls below this value the simulation switches from an internal friction
  /// model to a spring model which causes [x] to "spring" back to [leadingExtent].
  final double leadingExtent;

  /// When [x] exceeds this value the simulation switches from an internal friction
  /// model to a spring model which causes [x] to "spring" back to [trailingExtent].
  final double trailingExtent;

  /// The spring used used to return [x] to either [leadingExtent] or [trailingExtent].
  final SpringDescription spring;

  final double headerH;

  FrictionSimulation _frictionSimulation;
  Simulation _springSimulation;
  DecelerateSimulation _decelerateSimulation;
  double _springTime;
  double _timeOffset = 0.0;

  //ScrollSpringSimulation：回滚模拟器，只要传入开始位置、结束位置和当前的速度
  Simulation _underscrollSimulation(double x, double dx) {
    return ScrollSpringSimulation(spring, x, leadingExtent, dx);
  }

  Simulation _overscrollSimulation(double x, double dx) {
    return ScrollSpringSimulation(spring, x, trailingExtent, dx);
  }

  //据时间选择不同的弹道模拟器
  Simulation _simulation(double time) {
    Simulation simulation;
    if (_decelerateSimulation != null) {
      print('使用线性减速');
      simulation = _decelerateSimulation;
    } else {
      if (time > _springTime) {
        //回弹模拟器
        print('使用回弹');
        _timeOffset = _springTime.isFinite ? _springTime : 0.0; //确保时间的值是有限的
        simulation = _springSimulation;
      } else {
        //摩擦模拟器
        print('使用摩擦');
        _timeOffset = 0.0; //时间直接置为0
        simulation = _frictionSimulation;
      }
    }

    return simulation..tolerance = tolerance; //
  }

  @override
  double x(double time) {
    print('x :' + _simulation(time).x(time - _timeOffset).toString());
    return _simulation(time).x(time - _timeOffset);
  }

  @override
  double dx(double time) {
    print('dx:' + _simulation(time).dx(time - _timeOffset).toString());
    return _simulation(time).dx(time - _timeOffset);
  }

  @override
  bool isDone(double time) {
    return _simulation(time).isDone(time - _timeOffset);
  }

  @override
  String toString() {
    return '$runtimeType(leadingExtent: $leadingExtent, trailingExtent: $trailingExtent)';
  }
}
