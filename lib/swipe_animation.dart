import 'package:flutter/material.dart';

const SIDE_MENU_WIDTH = 240.0;
const MIN_SCALE = 0.5;
const MAX_SCALE = 1.0;

class SwipeAnimation extends StatefulWidget {
  final Widget child;
  final Function(bool) navigationDrawerOpened;

  SwipeAnimation({Key key, this.child, this.navigationDrawerOpened})
      : super(key: key);

  @override
  SwipeAnimationState createState() => SwipeAnimationState();
}

class SwipeAnimationState extends State<SwipeAnimation>
    with SingleTickerProviderStateMixin {
  double initialX = 0;
  double lastX = 0;
  bool swipingLeft = false;

  Animation<int> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation =
        IntTween(begin: 0, end: SIDE_MENU_WIDTH.toInt()).animate(controller)
          ..addListener(() {
            _translateX(animation.value.toDouble());
          });
  }

  @override
  Widget build(BuildContext context) {
    double scaleFactor = 0;
    double scale = 0;
    if (swipingLeft) {
      // To hide the menu, when user swipes back/left
      scaleFactor = ((SIDE_MENU_WIDTH - lastX) / SIDE_MENU_WIDTH) + 0.3;
      scale = scaleFactor < MIN_SCALE ? MIN_SCALE : scaleFactor;
      scale = scale > MAX_SCALE ? MAX_SCALE : scale;
    } else {
      // To show the menu, when user swipes right/forward
      scaleFactor = (SIDE_MENU_WIDTH - lastX) / SIDE_MENU_WIDTH;
      scale = scaleFactor < MIN_SCALE ? MIN_SCALE : scaleFactor;
    }

    return GestureDetector(
      onHorizontalDragStart: (details) {
        initialX = details.globalPosition.dx;
        lastX = 0;
      },
      onHorizontalDragUpdate: (details) {
        lastX = (details.globalPosition.dx);
        if (lastX <= SIDE_MENU_WIDTH) {
          swipingLeft = lastX < initialX;
          if (!swipingLeft) {
            lastX = lastX / 2;
            _translateX(lastX);
          } else {
            if (scale < 1.0) {
              _translateX(lastX);
            }
          }
        }
      },
      onHorizontalDragEnd: (details) {
        if (swipingLeft) {
          if (lastX > SIDE_MENU_WIDTH) {
            // Do nothing
          } else if (initialX - lastX < SIDE_MENU_WIDTH / 4) {
            _translateX(SIDE_MENU_WIDTH);
          } else {
            _resetPosition(200);
          }
        } else {
          if (lastX > SIDE_MENU_WIDTH) {
            // Do nothing
          } else if (lastX - initialX > (SIDE_MENU_WIDTH / 4)) {
            _translateX(SIDE_MENU_WIDTH);
          } else {
            _resetPosition(200);
          }
        }
      },
      child: Transform.scale(
        scale: scale,
        alignment: AlignmentDirectional.centerEnd,
        child: scale == 1
            ? widget.child
            : _getContainerWithShadow(
                scale,
                widget.child,
              ),
      ),
    );
  }

  void _resetPosition(int milliseconds) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _translateX(0);
    });
  }

  void hideNavigationDrawer([double dx = SIDE_MENU_WIDTH]) {
    controller.reverse(from: dx);
  }

  void showNavigationDrawer() {
    controller.forward(from: 0);
  }

  void _translateX(double dx) {
    setState(() {
      this.lastX = dx;
    });

    if (lastX == 0.0) {
      widget.navigationDrawerOpened(false);
    } else if (lastX >= SIDE_MENU_WIDTH) {
      widget.navigationDrawerOpened(true);
    }
  }

  Container _getContainerWithShadow(double scale, Widget child) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        boxShadow: [
          BoxShadow(
            color: Colors.black38,
            blurRadius: 8,
            spreadRadius: (1 - scale) * 8,
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
