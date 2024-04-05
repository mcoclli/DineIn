import 'package:flutter/material.dart';

class ClosableWidget extends StatelessWidget {
  final Widget child;

  const ClosableWidget({super.key, required this.child, this.closeFunction});

  final void Function()? closeFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.blue, // Border color for the child
                width: 2, // Border width for the child
              ),
              borderRadius: BorderRadius.circular(10), // Rounded edges for the child
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8), // Ensures the child content respects the border radius
              child: child, // Your main content
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () {
                if (closeFunction != null) {
                  closeFunction!();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(10),
                child: const Icon(
                  Icons.close,
                  color: Colors.red,
                ), // Padding inside the container
              ),
            ),
          ),
        ],
      ),
    );
  }
}
