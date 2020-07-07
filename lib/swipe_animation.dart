import 'package:flutter/material.dart';

const LEFT_SECTION_WIDTH = 240.0;

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
  bool drawingBackward = false;

  Animation<int> animation;
  AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    animation =
        IntTween(begin: 0, end: LEFT_SECTION_WIDTH.toInt()).animate(controller)
          ..addListener(() {
            _translateX(animation.value.toDouble());
          });
  }

  @override
  Widget build(BuildContext context) {
    double scaleFactor = 0;
    double scale = 0;
    if (drawingBackward) {
      scaleFactor = ((240 - lastX) / 240) + 0.3;
      scale = scaleFactor < 0.5 ? 0.5 : scaleFactor;
      scale = scale > 1.0 ? 1.0 : scale;
    } else {
      scaleFactor = (240 - lastX) / 240;
      scale = scaleFactor < 0.5 ? 0.5 : scaleFactor;
    }

    return GestureDetector(
      onHorizontalDragStart: (details) {
        initialX = details.globalPosition.dx;
        lastX = 0;
      },
      onHorizontalDragUpdate: (details) {
        lastX = details.globalPosition.dx;
        drawingBackward = lastX < initialX;
        _translateX(lastX);
      },
      onHorizontalDragEnd: (details) {
        if (drawingBackward) {
          if (lastX > LEFT_SECTION_WIDTH) {
            // Do nothing
          } else if (initialX - lastX < LEFT_SECTION_WIDTH / 4) {
            _translateX(LEFT_SECTION_WIDTH);
          } else {
            _resetPosition(200);
          }
        } else {
          print(lastX);
          if (lastX > LEFT_SECTION_WIDTH) {
            // Do nothing
          } else if (lastX - initialX > (LEFT_SECTION_WIDTH / 4)) {
            _translateX(LEFT_SECTION_WIDTH);
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
            : Container(
                decoration: BoxDecoration(
                    shape: BoxShape
                        .rectangle, // BoxShape.circle or BoxShape.retangle
                    //color: const Color(0xFF66BB6A),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 8,
                        spreadRadius: (1 - scale) * 8,
                      ),
                    ]),
                child: widget.child,
              ),
      ),
    );
  }

  void _resetPosition(int milliseconds) {
    Future.delayed(Duration(milliseconds: milliseconds), () {
      _translateX(0);
    });
  }

  void hideNavigationDrawer() {
    controller.reverse(from: LEFT_SECTION_WIDTH);
    //_resetPosition(200);
  }

  void showNavigationDrawer() {
    //_translateX(LEFT_SECTION_WIDTH);
//    controller.reset();
    controller.forward(from: 0);
  }

  void _translateX(double dx) {
    setState(() {
      this.lastX = dx;
    });

    if (lastX == 0.0) {
      widget.navigationDrawerOpened(false);
    } else if (lastX >= LEFT_SECTION_WIDTH) {
      widget.navigationDrawerOpened(true);
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }
}
