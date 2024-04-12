import 'package:flutter/material.dart';
import 'package:reservation/core/extensions/extension.dart';
import 'package:reservation/core/util/common_utils.dart';

class AnimatedFAB extends StatefulWidget {
  const AnimatedFAB({super.key, this.tapFunction});

  final void Function()? tapFunction;

  @override
  _AnimatedFABState createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool isExpanded = false;
  bool isAnimating = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animationController.addListener(() {
      if (_animationController.isAnimating) {
        setState(() {
          isAnimating = true;
        });
      } else if (_animationController.isCompleted) {
        setState(() {
          isAnimating = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      isExpanded = !isExpanded;
      if (isExpanded) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        width: isExpanded ? context.dynamicWidth(0.5) - 10 : 40,
        height: isExpanded ? context.dynamicHeight(0.06) : 40,
        child: FloatingActionButton(
          onPressed: _toggle,
          backgroundColor: Colors.blue,
          child: isExpanded
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add),
                    if (!isAnimating && isExpanded)
                      InkWell(
                          onTap: () {
                            CommonUtils.log("Requesting Reservation");
                            if (widget.tapFunction != null) {
                              widget.tapFunction!();
                            }
                            _toggle();
                          },
                          child: const Text('Request Reservation'))
                  ],
                )
              : const Icon(Icons.add),
        ),
      ),
    );
  }
}
