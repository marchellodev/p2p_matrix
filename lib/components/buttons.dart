import 'package:flutter/material.dart';

class ScalableButton extends StatefulWidget {
  final Widget child;
  final Function() onPressed;
  final ScaleFormat scale;

  const ScalableButton({@required this.child, @required this.onPressed, @required this.scale});

  @override
  _ScalableButtonState createState() => _ScalableButtonState();
}

class _ScalableButtonState extends State<ScalableButton> with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;

  AnimationStatusListener listener;

  @override
  void initState() {
    controller = AnimationController(duration: const Duration(milliseconds: 50), vsync: this);
    animation = Tween<double>(begin: 1, end: widget.scale == ScaleFormat.big ? 0.86 : 0.94).animate(controller)
      ..addListener(() => setState(() {}));

    listener = (status) {
      if (status == AnimationStatus.completed) {
        controller.reverse();
        controller.removeStatusListener(listener);
      }
    };

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: (_) => controller.forward(),
        onTapUp: (_) {
          widget.onPressed();

          if (controller.isAnimating) {
            controller.addStatusListener(listener);
          } else {
            controller.reverse();
          }
        },
        onTapCancel: () => controller.reverse(),
        child: Transform.scale(
          scale: animation.value,
          child: widget.child,
        ),
      );
}

enum ScaleFormat { small, big }
