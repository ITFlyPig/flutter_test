import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class PinnedSliverObjectWidget extends SingleChildRenderObjectWidget {
  PinnedSliverObjectWidget({
    Key key,
    Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return PinnedSliverSingleBox();
  }

  @override
  void updateRenderObject(
      BuildContext context, PinnedSliverSingleBox renderObject) {}
}

class PinnedSliverSingleBox extends RenderSliverSingleBoxAdapter {
  final double maxExtent = 0;

  PinnedSliverSingleBox({RenderBox child}) {
    this.child = child;
  }

  @override
  void performLayout() {
    child.layout(constraints.asBoxConstraints(), parentUsesSize: true);
    double childExtent = child.size.height;
    final double maxExtent = childExtent;
    final double layoutExtent = (maxExtent - constraints.scrollOffset)
        .clamp(0.0, constraints.remainingPaintExtent);

    print('performLayout axisDirection:' + constraints.axisDirection.toString() + ' growthDirection:' + constraints.growthDirection.toString() + ' userScrollDirection:' + constraints.userScrollDirection.toString());
    geometry = SliverGeometry(
      scrollExtent: 0.0,
      paintOrigin:  -constraints.scrollOffset,
      paintExtent: childExtent,
      layoutExtent: layoutExtent,
      maxPaintExtent: childExtent,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    context.paintChild(child, Offset(offset.dx, offset.dy));
  }

  @override
  void handleEvent(PointerEvent event, SliverHitTestEntry entry) {
    print('handleEvent');
    super.handleEvent(event, entry);
  }

  @override
  bool hitTest(SliverHitTestResult result,
      {double mainAxisPosition, double crossAxisPosition}) {
    return super.hitTest(result,
        mainAxisPosition: mainAxisPosition,
        crossAxisPosition: crossAxisPosition);
  }

  @override
  bool hitTestChildren(SliverHitTestResult result, {double mainAxisPosition, double crossAxisPosition}) {
    return super.hitTestChildren(result,mainAxisPosition: mainAxisPosition,crossAxisPosition: crossAxisPosition);
  }

  @override
  bool hitTestBoxChild(BoxHitTestResult result, RenderBox child, {double mainAxisPosition, double crossAxisPosition}) {
    return super.hitTestBoxChild(result, child,mainAxisPosition: mainAxisPosition,crossAxisPosition: crossAxisPosition);
  }
  @override
  double childMainAxisPosition(RenderBox child) {
    // TODO: implement childMainAxisPosition
    return super.childMainAxisPosition(child);
  }
}
